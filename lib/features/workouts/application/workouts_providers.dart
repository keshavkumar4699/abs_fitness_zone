import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/ids.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../members/application/members_providers.dart';
import '../data/workouts_repository.dart';
import '../domain/workout_logic.dart';
import '../domain/workout_models.dart';
import '../domain/workout_session.dart';
import 'rest_alerts.dart';

part 'workouts_providers.g.dart';

// ---------------------------------------------------------------------------
// Template library (5.3)
// ---------------------------------------------------------------------------
@riverpod
class TemplateList extends _$TemplateList {
  @override
  Future<Paged<WorkoutTemplate>> build(String search) =>
      ref.watch(workoutsRepositoryProvider).templates(search: search);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref.read(workoutsRepositoryProvider).templates(search: search, offset: current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

@riverpod
Future<WorkoutTemplate> templateDetail(Ref ref, String id) => ref.watch(workoutsRepositoryProvider).template(id);

// ---------------------------------------------------------------------------
// A member's programs and logs (cached on the phone for offline use)
// ---------------------------------------------------------------------------
@riverpod
Future<List<MemberProgram>> memberPrograms(Ref ref, String memberId) async {
  final cache = ref.watch(myWorkoutCacheProvider);
  try {
    final list = await ref.watch(workoutsRepositoryProvider).programs(memberId);
    unawaited(cache.savePrograms(memberId, list));
    return list;
  } on NetworkFailure {
    final saved = cache.programs(memberId);
    if (saved != null) return saved;
    rethrow;
  }
}

/// The running program, else the next queued one.
@riverpod
Future<MemberProgram?> currentProgram(Ref ref, String memberId) async {
  final list = await ref.watch(memberProgramsProvider(memberId).future);
  return list.where((p) => p.status == ProgramStatus.active).firstOrNull ??
      (list.where((p) => p.status == ProgramStatus.queued).toList()
            ..sort((a, b) => a.startDate!.compareTo(b.startDate!)))
          .firstOrNull;
}

/// The last 12 weeks of workouts with their sets (stats, calendar, "last
/// time" prefill and local PR checks).
@riverpod
Future<List<WorkoutLog>> recentWorkouts(Ref ref, String memberId) async {
  final cache = ref.watch(myWorkoutCacheProvider);
  final since = IstDates.today(now: ref.watch(clockProvider)()).subtract(const Duration(days: 84));
  try {
    final list = await ref.watch(workoutsRepositoryProvider).recentLogs(memberId, since: since);
    unawaited(cache.saveLogs(memberId, list));
    return list;
  } on NetworkFailure {
    final saved = cache.logs(memberId);
    if (saved != null) return saved;
    rethrow;
  }
}

@riverpod
class WorkoutHistory extends _$WorkoutHistory {
  @override
  Future<Paged<WorkoutLog>> build(String memberId) => ref.watch(workoutsRepositoryProvider).logs(memberId);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref.read(workoutsRepositoryProvider).logs(memberId, offset: current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

@riverpod
Future<List<DatedSet>> exerciseHistory(Ref ref, String memberId, String exerciseId) =>
    ref.watch(workoutsRepositoryProvider).exerciseHistory(memberId, exerciseId);

/// Adherence, streak, workouts per week and what's planned next (5.8).
class WorkoutStats {
  const WorkoutStats({
    required this.program,
    required this.adherence,
    required this.streak,
    required this.perWeek,
    required this.today,
    required this.next,
    required this.doneToday,
  });

  final MemberProgram? program;
  final double? adherence;
  final int streak;
  final List<int> perWeek;

  /// The day planned for today (null on a rest day).
  final WorkoutDay? today;
  final ({DateTime date, WorkoutDay day})? next;
  final bool doneToday;
}

@riverpod
Future<WorkoutStats> workoutStats(Ref ref, String memberId) async {
  final program = await ref.watch(currentProgramProvider(memberId).future);
  final logs = await ref.watch(recentWorkoutsProvider(memberId).future);
  final today = IstDates.today(now: ref.watch(clockProvider)());
  final active = program?.status == ProgramStatus.active ? program : null;
  return WorkoutStats(
    program: program,
    adherence: active == null ? null : adherence(active, logs, today),
    streak: active == null ? 0 : streak(active, logs, today),
    perWeek: workoutsPerWeek(logs, today),
    today: active == null ? null : plannedDayOn(active, today),
    next: program == null ? null : nextSession(program, today),
    doneToday: logs.any((l) => (l.day ?? IstDates.istDate(l.startedAt)) == today),
  );
}

// ---------------------------------------------------------------------------
// Coach overview (5.5)
// ---------------------------------------------------------------------------
@riverpod
class CoachList extends _$CoachList {
  @override
  Future<Paged<CoachRow>> build(String? trainerId, String search) =>
      ref.watch(workoutsRepositoryProvider).coachOverview(trainerId: trainerId, search: search);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref
          .read(workoutsRepositoryProvider)
          .coachOverview(trainerId: trainerId, search: search, offset: current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

/// Uploads finished workouts waiting in the outbox; the member home watches
/// this, so it runs on every launch and pull-to-refresh.
@riverpod
Future<int> syncWorkouts(Ref ref) async {
  final done = await ref.read(workoutOutboxProvider).flush(ref.read(workoutsRepositoryProvider));
  return done.length;
}

extension WorkoutRefresh on WidgetRef {
  void refreshWorkouts(String memberId) {
    invalidate(memberProgramsProvider(memberId));
    invalidate(recentWorkoutsProvider(memberId));
    invalidate(workoutHistoryProvider(memberId));
    invalidate(coachListProvider);
    invalidate(memberEventsProvider(memberId));
  }
}

// ---------------------------------------------------------------------------
// The workout player (5.6, 5.7)
// ---------------------------------------------------------------------------
@Riverpod(keepAlive: true)
class ActiveWorkout extends _$ActiveWorkout {
  static const _key = 'active_workout_v1';

  @override
  WorkoutSession? build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(_key);
    if (raw == null) return null;
    try {
      return WorkoutSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  DateTime _now() => ref.read(clockProvider)();

  void _set(WorkoutSession? s) {
    state = s;
    final prefs = ref.read(sharedPreferencesProvider);
    if (s == null) {
      unawaited(prefs.remove(_key));
    } else {
      unawaited(prefs.setString(_key, jsonEncode(s.toJson())));
    }
  }

  /// Starts a program day (or resumes the one already running for it).
  Future<WorkoutSession> start({required MemberProgram program, required WorkoutDay day}) async {
    final running = state;
    if (running != null && running.programId == program.id && running.dayId == day.id) return running;
    final catalogue = await ref.read(exerciseCatalogueProvider.future);
    final history = ref.read(recentWorkoutsProvider(program.memberId)).value ?? const <WorkoutLog>[];
    final now = _now();
    final s = WorkoutSession.forDay(
      clientId: newUuid(),
      program: program,
      day: day,
      catalogue: catalogue,
      history: history,
      now: now,
      today: IstDates.today(now: now),
    );
    _set(s);
    return s;
  }

  /// Re-opens a saved workout to fix a set (allowed for 24 hours, 5.7).
  Future<WorkoutSession> edit(WorkoutLog log) async {
    final catalogue = await ref.read(exerciseCatalogueProvider.future);
    final s = WorkoutSession.fromLog(log, catalogue);
    _set(s);
    return s;
  }

  void goTo(int index) {
    final s = state;
    if (s == null || index < 0 || index >= s.exercises.length) return;
    _set(s.copyWith(current: index));
  }

  SessionSet _setAt(int e, int i) => state!.exercises[e].sets[i];

  void _replaceSet(int e, int i, SessionSet next) {
    final s = state!;
    final ex = s.exercises[e];
    final sets = [...ex.sets]..[i] = next;
    final all = [...s.exercises]..[e] = ex.copyWith(sets: sets);
    _set(s.copyWith(exercises: all));
  }

  void updateSet(int e, int i, {double? weight, int? reps, int? durationS, int? distanceM}) {
    if (state == null) return;
    final cur = _setAt(e, i);
    _replaceSet(
      e,
      i,
      cur.copyWith(
        weight: weight ?? cur.weight,
        reps: reps ?? cur.reps,
        durationS: durationS ?? cur.durationS,
        distanceM: distanceM ?? cur.distanceM,
      ),
    );
  }

  /// Ticks (or unticks) a set; ticking starts the rest timer.
  void toggleSet(int e, int i) {
    if (state == null) return;
    final cur = _setAt(e, i);
    final done = !cur.done;
    _replaceSet(e, i, cur.copyWith(done: done, doneAt: done ? _now() : null));
    if (done) {
      unawaited(HapticFeedback.lightImpact());
      final rest = state!.restAfter(e);
      if (rest > 0) startRest(rest);
    }
  }

  void addSet(int e) {
    final s = state;
    if (s == null) return;
    final ex = s.exercises[e];
    final last = ex.sets.isEmpty ? null : ex.sets.last;
    final next = SessionSet(
      setNo: ex.sets.length + 1,
      targetWeight: last?.targetWeight,
      targetReps: last?.targetReps,
      targetDuration: last?.targetDuration,
      weight: last?.weight,
      reps: last?.reps,
      durationS: last?.durationS,
      distanceM: last?.distanceM,
    );
    final all = [...s.exercises]..[e] = ex.copyWith(sets: [...ex.sets, next]);
    _set(s.copyWith(exercises: all));
  }

  void startRest(int seconds) {
    final s = state;
    if (s == null) return;
    final ends = _now().add(Duration(seconds: seconds));
    _set(s.copyWith(restEndsAt: ends, restTotalS: seconds));
    unawaited(ref.read(restAlertsProvider).schedule(ends, title: 'Rest over', body: 'Time for your next set'));
  }

  void addRest(int seconds) {
    final s = state;
    final ends = s?.restEndsAt;
    if (s == null || ends == null) return;
    final next = ends.add(Duration(seconds: seconds));
    _set(s.copyWith(restEndsAt: next, restTotalS: s.restTotalS + seconds));
    unawaited(ref.read(restAlertsProvider).schedule(next, title: 'Rest over', body: 'Time for your next set'));
  }

  void endRest() {
    final s = state;
    if (s == null || s.restEndsAt == null) return;
    _set(s.copyWith(restEndsAt: null, restTotalS: 0));
    unawaited(ref.read(restAlertsProvider).cancel());
  }

  void discard() {
    unawaited(ref.read(restAlertsProvider).cancel());
    _set(null);
  }

  /// Saves the workout (complete or partial): into the outbox first, so it is
  /// never lost, then uploads. Returns the summary for the celebration.
  Future<WorkoutSummary> finish({String? notes}) async {
    final s = state!;
    final now = _now();
    final payload = s.toPayload(finishedAt: now, complete: s.isComplete, notes: notes);
    final history = ref.read(recentWorkoutsProvider(s.memberId)).value ?? const <WorkoutLog>[];
    var summary = WorkoutSummary(
      name: s.name,
      duration: (s.editingFinishedAt ?? now).difference(s.startedAt),
      volume: s.volume,
      setsDone: s.doneSets,
      prs: detectPrs(s.doneSetLogs, [for (final l in history.where((l) => l.clientId != s.clientId)) ...l.sets]),
      complete: s.editingFinishedAt != null || s.isComplete,
    );
    final outbox = ref.read(workoutOutboxProvider);
    await outbox.put(payload);
    await ref.read(restAlertsProvider).cancel();
    _set(null);
    try {
      final results = await outbox.flush(ref.read(workoutsRepositoryProvider));
      final mine = results[s.clientId];
      if (mine != null) {
        summary = summary.copyWith(prs: mine.prs, synced: true, volume: mine.totalVolume ?? summary.volume);
      }
    } catch (_) {
      // Still queued; it uploads on the next launch or refresh.
    }
    ref
      ..invalidate(recentWorkoutsProvider(s.memberId))
      ..invalidate(workoutHistoryProvider(s.memberId));
    return summary;
  }
}
