import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../../members/application/members_providers.dart';
import '../../members/data/members_repository.dart';
import '../data/diet_repository.dart';
import '../domain/diet_models.dart';
import '../domain/food.dart';
import '../domain/nutrition.dart';
import 'meal_reminders.dart';

part 'diet_providers.g.dart';

// ---------------------------------------------------------------------------
// Food database (6.1)
// ---------------------------------------------------------------------------
/// The foods, indexed for instant search. Loaded once per session and
/// refreshed on pull-to-refresh or after an edit.
@Riverpod(keepAlive: true)
Future<FoodIndex> foodCatalogue(Ref ref) async => FoodIndex(await ref.watch(dietRepositoryProvider).foods());

// ---------------------------------------------------------------------------
// Template library (6.6)
// ---------------------------------------------------------------------------
@riverpod
class DietTemplateList extends _$DietTemplateList {
  @override
  Future<Paged<DietTemplate>> build(String search) => ref.watch(dietRepositoryProvider).templates(search: search);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref.read(dietRepositoryProvider).templates(search: search, offset: current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

@riverpod
Future<DietTemplate> dietTemplateDetail(Ref ref, String id) => ref.watch(dietRepositoryProvider).template(id);

// ---------------------------------------------------------------------------
// A member's plans and logs (cached on the phone)
// ---------------------------------------------------------------------------
@riverpod
Future<List<MemberDiet>> memberDiets(Ref ref, String memberId) async {
  final cache = ref.watch(myDietCacheProvider);
  try {
    final list = await ref.watch(dietRepositoryProvider).diets(memberId);
    unawaited(cache.saveDiets(memberId, list));
    return list;
  } on NetworkFailure {
    final saved = cache.diets(memberId);
    if (saved != null) return saved;
    rethrow;
  }
}

/// The running plan, else the next queued one.
@riverpod
Future<MemberDiet?> currentDiet(Ref ref, String memberId) async {
  final list = await ref.watch(memberDietsProvider(memberId).future);
  return list.where((d) => d.status == DietStatus.active).firstOrNull ??
      list.where((d) => d.status == DietStatus.queued).firstOrNull;
}

/// The plan followed on [day] (active, or an earlier one that covered it).
MemberDiet? dietOn(List<MemberDiet> diets, DateTime day) {
  for (final d in diets) {
    if (d.status == DietStatus.queued || d.status == DietStatus.dropped || d.startDate == null) continue;
    if (d.startDate!.isAfter(day)) continue;
    if (d.endDate != null && d.endDate!.isBefore(day)) continue;
    return d;
  }
  return null;
}

/// The last 8 weeks of meals, water and supplements, with marks still
/// waiting in the outbox applied on top (so offline taps stick).
@riverpod
class MemberDietLogs extends _$MemberDietLogs {
  @override
  Future<DietLogs> build(String memberId) async {
    final cache = ref.watch(myDietCacheProvider);
    final since = IstDates.today(now: ref.watch(clockProvider)()).subtract(const Duration(days: 56));
    DietLogs logs;
    try {
      logs = await ref.watch(dietRepositoryProvider).logs(memberId, since: since);
      unawaited(cache.saveLogs(memberId, logs));
    } on NetworkFailure {
      final saved = cache.logs(memberId);
      if (saved == null) rethrow;
      logs = saved;
    }
    for (final op in ref.read(dietOutboxProvider).pending()) {
      logs = _applyOp(logs, op, memberId);
    }
    return logs;
  }

  static DateTime _day(String s) {
    final d = DateTime.parse(s);
    return DateTime.utc(d.year, d.month, d.day);
  }

  static DietLogs _applyOp(DietLogs logs, Map<String, dynamic> op, String memberId) {
    final day = _day(op['day'] as String);
    switch (op['kind']) {
      case 'meal':
        final raw = op['log'] as Map<String, dynamic>?;
        return withMeal(logs, day, op['slot'] as String, raw == null ? null : MealLog.fromJson(raw));
      case 'water':
        return withWater(logs, day, op['glasses'] as int);
      case 'supp':
        return withSupplement(logs, day, op['name'] as String, taken: op['taken'] as bool);
    }
    return logs;
  }

  static DietLogs withMeal(DietLogs logs, DateTime day, String slot, MealLog? log) =>
      logs.copyWith(meals: [...logs.meals.where((m) => !(m.day == day && m.slot == slot)), ?log]);

  static DietLogs withWater(DietLogs logs, DateTime day, int glasses) => logs.copyWith(
    water: [
      ...logs.water.where((w) => w.day != day),
      WaterLog(day: day, glasses: glasses),
    ],
  );

  static DietLogs withSupplement(DietLogs logs, DateTime day, String name, {required bool taken}) => logs.copyWith(
    supplements: [
      ...logs.supplements.where((s) => !(s.day == day && s.name == name)),
      if (taken) SupplementLog(day: day, name: name),
    ],
  );

  void _set(DietLogs Function(DietLogs) change) {
    final cur = state.value;
    if (cur != null) state = AsyncData(change(cur));
  }

  Future<void> _send(Map<String, dynamic> op) async {
    final outbox = ref.read(dietOutboxProvider);
    await outbox.put(op);
    try {
      final saved = await outbox.flush(ref.read(dietRepositoryProvider));
      final key = op['key'] as String;
      if (op['kind'] == 'meal' && saved.containsKey(key)) {
        final day = _day(op['day'] as String);
        _set((l) => withMeal(l, day, op['slot'] as String, saved[key]));
      }
    } catch (_) {
      // Still queued; it uploads on the next launch or refresh.
    }
  }

  /// Marks a meal Eaten / Partly / Skipped / Swapped, or clears it.
  Future<void> markMeal({
    required DateTime day,
    required DietMeal meal,
    required String? status,
    int? alt,
    required FoodLookup lookup,
    String? dietId,
  }) async {
    unawaited(HapticFeedback.selectionClick());
    final local = status == null
        ? null
        : () {
            final m = markedMacros(meal, status, alt, lookup);
            return MealLog(
              memberId: memberId,
              memberDietId: dietId,
              day: day,
              slot: meal.slot,
              status: status,
              altGroup: status == 'swapped' ? (alt ?? 1) : null,
              kcal: (m.kcal * 10).round() / 10,
              protein: (m.protein * 10).round() / 10,
              carbs: (m.carbs * 10).round() / 10,
              fat: (m.fat * 10).round() / 10,
            );
          }();
    _set((l) => withMeal(l, day, meal.slot, local));
    await _send({...DietOutbox.meal(day, meal.slot, status, status == 'swapped' ? alt : null), 'log': local?.toJson()});
  }

  Future<void> setWater(DateTime day, int glasses) async {
    _set((l) => withWater(l, day, glasses));
    await _send(DietOutbox.water(day, glasses));
  }

  Future<void> setSupplement(DateTime day, String name, {required bool taken}) async {
    unawaited(HapticFeedback.selectionClick());
    _set((l) => withSupplement(l, day, name, taken: taken));
    await _send(DietOutbox.supplement(day, name, taken: taken));
  }
}

/// The member's latest weight: the newest measurement, else the health form.
@riverpod
Future<double?> memberWeight(Ref ref, String memberId) async {
  final repo = ref.watch(membersRepositoryProvider);
  try {
    final ms = await repo.measurements(memberId);
    final w = ms.where((m) => m.weightKg != null).firstOrNull?.weightKg;
    if (w != null) return w.toDouble();
    return (await repo.health(memberId))?.weightKg?.toDouble();
  } catch (_) {
    return null;
  }
}

/// Adherence, missed meals and the week-by-week chart (6.11).
class DietStats {
  const DietStats({
    required this.diet,
    required this.adherence7d,
    required this.missed7d,
    required this.weekly,
    required this.waterGoal,
    required this.waterAvg7d,
  });

  final MemberDiet? diet;
  final double? adherence7d;
  final int missed7d;
  final List<({DateTime week, double? adherence})> weekly;
  final int waterGoal;
  final double waterAvg7d;
}

@riverpod
Future<DietStats> dietStats(Ref ref, String memberId) async {
  final diet = await ref.watch(currentDietProvider(memberId).future);
  final logs = await ref.watch(memberDietLogsProvider(memberId).future);
  final weight = await ref.watch(memberWeightProvider(memberId).future);
  final today = IstDates.today(now: ref.watch(clockProvider)());
  final active = diet?.status == DietStatus.active ? diet : null;
  final perDay = active?.template?.meals.length ?? 0;
  final mine = active == null ? const <MealLog>[] : logs.meals.where((m) => m.memberDietId == active.id).toList();
  final lastWeek = [for (var i = 1; i <= 7; i++) logs.glassesOn(today.subtract(Duration(days: i)))];
  return DietStats(
    diet: diet,
    adherence7d: active == null
        ? null
        : dietAdherence(
            mealsPerDay: perDay,
            start: active.startDate!,
            end: active.endDate,
            logs: mine,
            from: today.subtract(const Duration(days: 6)),
            to: today,
            today: today,
          ),
    missed7d: active == null ? 0 : missedMeals(mealsPerDay: perDay, start: active.startDate!, logs: mine, today: today),
    weekly: active == null ? const [] : weeklyAdherence(diet: active, mealsPerDay: perDay, logs: mine, today: today),
    waterGoal: waterGoal(weight),
    waterAvg7d: lastWeek.fold(0, (a, b) => a + b) / 7,
  );
}

// ---------------------------------------------------------------------------
// Coaches: overview, flags, comments
// ---------------------------------------------------------------------------
@riverpod
class DietOverviewList extends _$DietOverviewList {
  @override
  Future<Paged<DietRow>> build(String? trainerId, String search) =>
      ref.watch(dietRepositoryProvider).overview(trainerId: trainerId, search: search);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref
          .read(dietRepositoryProvider)
          .overview(trainerId: trainerId, search: search, offset: current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

@riverpod
Future<DietFlags> dietFlags(Ref ref, String memberId) => ref.watch(dietRepositoryProvider).flags(memberId);

@riverpod
Future<List<DietComment>> dietComments(Ref ref, String memberId) =>
    ref.watch(dietRepositoryProvider).comments(memberId);

/// Uploads diet marks waiting in the outbox; the member home watches this,
/// so it runs on every launch and pull-to-refresh.
@riverpod
Future<int> syncDiet(Ref ref) async {
  final done = await ref.read(dietOutboxProvider).flush(ref.read(dietRepositoryProvider));
  return done.length;
}

// ---------------------------------------------------------------------------
// Meal reminders (6.10)
// ---------------------------------------------------------------------------
@Riverpod(keepAlive: true)
class MealReminderSwitch extends _$MealReminderSwitch {
  static const _key = 'meal_reminders_on';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  /// Turns reminders on (scheduling [reminders]) or off.
  Future<void> set(
    bool on,
    List<MealReminder> reminders, {
    required String channelName,
    required String channelDescription,
  }) async {
    state = on;
    await ref.read(sharedPreferencesProvider).setBool(_key, on);
    final r = ref.read(mealRemindersProvider);
    on
        ? await r.schedule(reminders, channelName: channelName, channelDescription: channelDescription)
        : await r.cancelAll();
  }

  /// Re-schedules after the plan changes, when reminders are on.
  Future<void> resync(
    List<MealReminder> reminders, {
    required String channelName,
    required String channelDescription,
  }) async {
    if (state) {
      await ref
          .read(mealRemindersProvider)
          .schedule(reminders, channelName: channelName, channelDescription: channelDescription);
    }
  }
}

extension DietRefresh on WidgetRef {
  void refreshDiet(String memberId) {
    invalidate(memberDietsProvider(memberId));
    invalidate(memberDietLogsProvider(memberId));
    invalidate(dietCommentsProvider(memberId));
    invalidate(dietFlagsProvider(memberId));
    invalidate(dietOverviewListProvider);
    invalidate(memberEventsProvider(memberId));
  }

  /// Saves a food and refreshes the catalogue.
  Future<String> saveFood(Food food) async {
    final id = await read(dietRepositoryProvider).saveFood(food);
    invalidate(foodCatalogueProvider);
    return id;
  }
}
