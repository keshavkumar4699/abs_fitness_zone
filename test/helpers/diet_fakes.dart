import 'dart:convert';
import 'dart:io';

import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/core/paging.dart';
import 'package:abs_fitness/features/diet/application/meal_reminders.dart';
import 'package:abs_fitness/features/diet/data/diet_repository.dart';
import 'package:abs_fitness/features/diet/domain/diet_models.dart';
import 'package:abs_fitness/features/diet/domain/food.dart';
import 'package:abs_fitness/features/diet/domain/nutrition.dart';

/// The real seeded food list (300 foods), ids = seed keys.
List<Food> seedFoods() {
  final lines = File('supabase/seed/foods.csv').readAsLinesSync().where((l) => l.trim().isNotEmpty).toList();
  final head = lines.first.split(',');
  return [
    for (final line in lines.skip(1))
      () {
        final v = line.split(',');
        final r = {for (var i = 0; i < head.length; i++) head[i]: i < v.length ? v[i] : ''};
        double n(String k) => double.parse(r[k]!);
        return Food(
          id: r['key']!,
          seedKey: r['key'],
          name: r['name']!,
          localName: r['local_name'],
          category: r['category']!,
          servingUnit: r['unit']!,
          servingG: n('serving_g'),
          qtyStep: n('step'),
          kcal: n('kcal'),
          protein: n('protein_g'),
          carbs: n('carbs_g'),
          fat: n('fat_g'),
          fibre: n('fibre_g'),
          vegType: r['veg_type']!,
          jainOk: r['jain_ok'] == '1',
          allergens: r['allergens']!.split(';').where((a) => a.isNotEmpty).toList(),
          grocery: [
            for (final part in r['grocery']!.split(';').where((p) => p.isNotEmpty))
              () {
                final i = part.lastIndexOf(':');
                final amount = part.substring(i + 1);
                final unit = amount.endsWith('pc')
                    ? 'pc'
                    : amount.endsWith('ml')
                    ? 'ml'
                    : 'g';
                return GroceryPart(
                  item: part.substring(0, i),
                  qty: double.parse(amount.replaceAll(RegExp('[a-z]'), '')),
                  unit: unit,
                );
              }(),
          ],
          source: 'gym_seed',
          updatedAt: DateTime.utc(2026, 11, 1),
        );
      }(),
  ];
}

final _foods = seedFoods();
final _byKey = {for (final f in _foods) f.id: f};

Food food(String key) => _byKey[key]!;

/// The six starter templates (the same data the database seeds), with foods
/// embedded like the API returns them.
List<DietTemplate> starterTemplates() {
  final data = jsonDecode(File('supabase/seed/diet_templates.json').readAsStringSync()) as List<dynamic>;
  return [
    for (final (n, t) in data.cast<Map<String, dynamic>>().indexed)
      DietTemplate(
        id: 'dt-${n + 1}',
        name: t['name'] as String,
        description: t['description'] as String?,
        goal: t['goal'] as String?,
        dietPref: t['diet_pref'] as String?,
        kcalTarget: t['kcal_target'] as int,
        proteinG: t['protein_g'] as int?,
        carbsG: t['carbs_g'] as int?,
        fatG: t['fat_g'] as int?,
        macroPreset: t['macro_preset'] as String?,
        supplements: (t['supplements'] as List<dynamic>).cast<String>(),
        isStarter: true,
        meals: [
          for (final (mi, m) in (t['meals'] as List<dynamic>).cast<Map<String, dynamic>>().indexed)
            DietMeal(
              id: 'dt-${n + 1}-m$mi',
              slot: m['meal_slot'] as String,
              time: '${m['time_of_day']}:00',
              position: mi + 1,
              notes: m['notes'] as String?,
              items: [
                for (final (ii, i) in (m['items'] as List<dynamic>).cast<Map<String, dynamic>>().indexed)
                  DietItem(
                    id: 'dt-${n + 1}-m$mi-i$ii',
                    foodId: i['food'] as String,
                    qty: (i['qty'] as num).toDouble(),
                    altGroup: i['alt_group'] as int,
                    position: ii + 1,
                    food: food(i['food'] as String),
                  ),
              ],
            ),
        ],
      ),
  ];
}

DietTemplate vegFatLoss() => starterTemplates().first;

/// Aarav (m-1) follows the veg fat loss plan from Sun 1 Nov 2026.
MemberDiet aaravDiet() => MemberDiet(
  id: 'md-aarav',
  memberId: 'm-1',
  templateId: 'snap-aarav',
  sourceTemplateId: 'dt-1',
  name: 'Veg fat loss 1,500 kcal',
  startDate: DateTime.utc(2026, 11, 1),
  assignedAt: DateTime.utc(2026, 10, 31, 12),
  template: vegFatLoss().copyWith(id: 'snap-aarav', isGymTemplate: false, isStarter: false, sourceTemplateId: 'dt-1'),
);

MealLog _log(String member, String diet, DateTime day, DietMeal m, String status, {int? alt}) {
  final x = markedMacros(m, status, alt, (id) => _byKey[id]);
  return MealLog(
    id: 'ml-${day.day}-${m.slot}',
    memberId: member,
    memberDietId: diet,
    day: day,
    slot: m.slot,
    status: status,
    altGroup: status == 'swapped' ? alt : null,
    kcal: x.kcal,
    protein: x.protein,
    carbs: x.carbs,
    fat: x.fat,
  );
}

/// 1 Nov: every meal eaten. 2 Nov: lunch partly, dinner swapped, bedtime
/// skipped. 3 Nov (today): early morning and breakfast eaten, 4 glasses.
DietLogs aaravLogs() {
  final t = aaravDiet().template!;
  final d1 = DateTime.utc(2026, 11, 1), d2 = DateTime.utc(2026, 11, 2), d3 = DateTime.utc(2026, 11, 3);
  return DietLogs(
    meals: [
      for (final m in t.meals) _log('m-1', 'md-aarav', d1, m, 'eaten'),
      for (final m in t.meals)
        _log('m-1', 'md-aarav', d2, m, switch (m.slot) {
          'lunch' => 'partly',
          'dinner' => 'swapped',
          'bedtime' => 'skipped',
          _ => 'eaten',
        }, alt: m.slot == 'dinner' ? 1 : null),
      _log('m-1', 'md-aarav', d3, t.meal('early_morning')!, 'eaten'),
      _log('m-1', 'md-aarav', d3, t.meal('breakfast')!, 'eaten'),
    ],
    water: [
      WaterLog(day: d1, glasses: 9),
      WaterLog(day: d2, glasses: 7),
      WaterLog(day: d3, glasses: 4),
    ],
    supplements: [SupplementLog(day: d2, name: 'Multivitamin')],
  );
}

class FakeDietRepository implements DietRepository {
  FakeDietRepository({List<Food>? foods, bool withAarav = true})
    : foodList = foods ?? [..._foods],
      templateList = starterTemplates() {
    if (withAarav) {
      dietsByMember['m-1'] = [aaravDiet()];
      logsByMember['m-1'] = aaravLogs();
      commentsByMember['m-1'] = [
        DietComment(
          id: 'dc-1',
          authorName: 'Vikram Trainer',
          body: 'Great start! Add a glass of water before each meal.',
          createdAt: DateTime.utc(2026, 11, 2, 14),
        ),
      ];
    }
  }

  final List<Food> foodList;
  final List<DietTemplate> templateList;
  final Map<String, List<MemberDiet>> dietsByMember = {};
  final Map<String, DietLogs> logsByMember = {};
  final Map<String, List<DietComment>> commentsByMember = {};
  final Map<String, DietFlags> flagsByMember = {
    'm-1': const DietFlags(
      memberId: 'm-1',
      name: 'Aarav Sharma',
      dietPref: 'veg',
      allergies: ['peanut'],
      avoid: ['mushroom'],
    ),
    'm-2': const DietFlags(memberId: 'm-2', name: 'Priya Verma', conditions: 'Thyroid', hasConditions: true),
  };
  final calls = <String>[];
  Object? error;

  /// Make every log/mark call fail as if offline.
  bool offline = false;
  int _seq = 0;

  void _check() {
    if (error != null) throw error!;
  }

  @override
  Future<List<Food>> foods() async {
    _check();
    return foodList;
  }

  @override
  Future<String> saveFood(Food food) async {
    calls.add('food:${food.name}');
    final id = food.id.isEmpty ? 'custom-food-${++_seq}' : food.id;
    final saved = food.copyWith(
      id: id,
      source: food.id.isEmpty ? 'custom' : food.source,
      reviewedAt: DateTime.utc(2026, 11, 3),
      createdBy: food.id.isEmpty ? 'u-trainer' : food.createdBy,
    );
    foodList
      ..removeWhere((f) => f.id == id)
      ..add(saved);
    return id;
  }

  @override
  Future<void> markReviewed(String foodId) async {
    calls.add('review:$foodId');
    final i = foodList.indexWhere((f) => f.id == foodId);
    foodList[i] = foodList[i].copyWith(reviewedAt: DateTime.utc(2026, 11, 3));
  }

  @override
  Future<void> archiveFood(String foodId) async {
    calls.add('archive-food:$foodId');
    final i = foodList.indexWhere((f) => f.id == foodId);
    foodList[i] = foodList[i].copyWith(archivedAt: DateTime.utc(2026, 11, 3));
  }

  @override
  Future<Paged<DietTemplate>> templates({String search = '', int offset = 0}) async {
    _check();
    final s = search.trim().toLowerCase();
    final list = templateList.where((t) => t.isGymTemplate && (s.isEmpty || t.name.toLowerCase().contains(s))).toList()
      ..sort((a, b) => a.isStarter != b.isStarter ? (a.isStarter ? -1 : 1) : a.name.compareTo(b.name));
    return Paged(list.skip(offset).take(kPageSize).toList(), hasMore: false);
  }

  @override
  Future<DietTemplate> template(String id) async {
    _check();
    final t =
        templateList.where((t) => t.id == id).firstOrNull ??
        [for (final l in dietsByMember.values) ...l].where((d) => d.templateId == id).firstOrNull?.template;
    if (t == null) throw const NotFoundFailure();
    return t;
  }

  DietTemplate _withFoods(DietTemplate t) => t.copyWith(
    meals: [
      for (final m in t.meals)
        m.copyWith(
          items: [
            for (final i in m.items) i.copyWith(food: i.food ?? foodList.where((f) => f.id == i.foodId).firstOrNull),
          ],
        ),
    ],
  );

  @override
  Future<String> saveTemplate(DietTemplate t) async {
    calls.add('save:${t.name}');
    final id = t.id ?? 'dt-new-${++_seq}';
    final saved = _withFoods(t.copyWith(id: id));
    final i = templateList.indexWhere((x) => x.id == id);
    if (i >= 0) {
      templateList[i] = saved;
    } else {
      // A member's snapshot?
      for (final entry in dietsByMember.entries) {
        final j = entry.value.indexWhere((d) => d.templateId == id);
        if (j >= 0) {
          entry.value[j] = entry.value[j].copyWith(template: saved, name: saved.name);
          return id;
        }
      }
      templateList.add(saved);
    }
    return id;
  }

  @override
  Future<void> archiveTemplate(String id) async {
    calls.add('archive:$id');
    templateList.removeWhere((t) => t.id == id);
  }

  @override
  Future<int> assign({required String templateId, required List<String> memberIds, DateTime? start}) async {
    calls.add('assign:$templateId:${memberIds.join(',')}:${start == null ? '-' : dietDate(start)}');
    final t = await template(templateId);
    final today = DateTime.utc(2026, 11, 3);
    final from = start ?? today;
    for (final m in memberIds) {
      final list = dietsByMember.putIfAbsent(m, () => []);
      list.removeWhere((d) => d.status == DietStatus.queued);
      final future = from.isAfter(today);
      if (!future) {
        for (var i = 0; i < list.length; i++) {
          if (list[i].status == DietStatus.active) {
            list[i] = list[i].copyWith(status: DietStatus.replaced, endDate: from.subtract(const Duration(days: 1)));
          }
        }
      }
      final id = 'md-${++_seq}';
      list.insert(
        0,
        MemberDiet(
          id: id,
          memberId: m,
          templateId: 'snap-$id',
          sourceTemplateId: templateId,
          name: t.name,
          startDate: from,
          status: future ? DietStatus.queued : DietStatus.active,
          assignedAt: DateTime.utc(2026, 11, 3, 4),
          template: t.copyWith(id: 'snap-$id', isGymTemplate: false, isStarter: false, sourceTemplateId: templateId),
        ),
      );
    }
    return memberIds.length;
  }

  @override
  Future<void> endDiet(String dietId) async {
    calls.add('end:$dietId');
    for (final list in dietsByMember.values) {
      final i = list.indexWhere((d) => d.id == dietId);
      if (i >= 0) list[i] = list[i].copyWith(status: DietStatus.ended, endDate: DateTime.utc(2026, 11, 3));
    }
  }

  @override
  Future<List<MemberDiet>> diets(String memberId) async {
    _check();
    if (offline) throw const NetworkFailure();
    return [...?dietsByMember[memberId]];
  }

  @override
  Future<DietLogs> logs(String memberId, {required DateTime since}) async {
    _check();
    if (offline) throw const NetworkFailure();
    return logsByMember[memberId] ?? const DietLogs();
  }

  MemberDiet? _active(String memberId) =>
      dietsByMember[memberId]?.where((d) => d.status == DietStatus.active).firstOrNull;

  @override
  Future<MealLog?> logMeal({required DateTime day, required String slot, String? status, int? alt}) async {
    if (offline) throw const NetworkFailure();
    calls.add('meal:${dietDate(day)}:$slot:$status${alt == null ? '' : ':$alt'}');
    const member = 'm-1';
    final diet = _active(member);
    final meal = diet?.template?.meal(slot);
    if (diet == null || meal == null) throw const NotFoundFailure();
    final logs = logsByMember[member] ?? const DietLogs();
    final rest = logs.meals.where((m) => !(m.day == day && m.slot == slot)).toList();
    if (status == null) {
      logsByMember[member] = logs.copyWith(meals: rest);
      return null;
    }
    final saved = _log(member, diet.id, day, meal, status, alt: alt);
    logsByMember[member] = logs.copyWith(meals: [...rest, saved]);
    return saved;
  }

  @override
  Future<void> setWater(DateTime day, int glasses) async {
    if (offline) throw const NetworkFailure();
    calls.add('water:${dietDate(day)}:$glasses');
    final logs = logsByMember['m-1'] ?? const DietLogs();
    logsByMember['m-1'] = logs.copyWith(
      water: [
        ...logs.water.where((w) => w.day != day),
        WaterLog(day: day, glasses: glasses),
      ],
    );
  }

  @override
  Future<void> setSupplement(DateTime day, String name, {required bool taken}) async {
    if (offline) throw const NetworkFailure();
    calls.add('supp:${dietDate(day)}:$name:$taken');
    final logs = logsByMember['m-1'] ?? const DietLogs();
    logsByMember['m-1'] = logs.copyWith(
      supplements: [
        ...logs.supplements.where((s) => !(s.day == day && s.name == name)),
        if (taken) SupplementLog(day: day, name: name),
      ],
    );
  }

  @override
  Future<DietFlags> flags(String memberId) async {
    _check();
    return flagsByMember[memberId] ?? DietFlags(memberId: memberId);
  }

  @override
  Future<List<DietFlags>> flagsFor(List<String> memberIds) async => [
    for (final id in memberIds) flagsByMember[id] ?? DietFlags(memberId: id),
  ];

  @override
  Future<void> setPreferences(
    String memberId, {
    String? dietPref,
    List<String> allergies = const [],
    List<String> avoid = const [],
  }) async {
    calls.add('prefs:$memberId:$dietPref:${allergies.join('+')}:${avoid.join('+')}');
    final cur = flagsByMember[memberId] ?? DietFlags(memberId: memberId);
    flagsByMember[memberId] = cur.copyWith(dietPref: dietPref, allergies: allergies, avoid: avoid);
  }

  @override
  Future<List<DietComment>> comments(String memberId) async => [...?commentsByMember[memberId]];

  @override
  Future<void> comment(String memberId, String body) async {
    calls.add('comment:$memberId:$body');
    commentsByMember
        .putIfAbsent(memberId, () => [])
        .insert(
          0,
          DietComment(
            id: 'dc-${++_seq}',
            authorName: 'Vikram Trainer',
            body: body,
            createdAt: DateTime.utc(2026, 11, 3, 5),
          ),
        );
  }

  @override
  Future<Paged<DietRow>> overview({String? trainerId, String search = '', int offset = 0}) async {
    _check();
    final rows = <DietRow>[
      const DietRow(
        memberId: 'm-2',
        name: 'Priya Verma',
        memberCode: 'ABS-0002',
        status: 'expiring',
        hasConditions: true,
      ),
      DietRow(
        memberId: 'm-1',
        name: 'Aarav Sharma',
        memberCode: 'ABS-0001',
        status: 'active',
        trainerId: '3',
        dietId: 'md-aarav',
        dietName: 'Veg fat loss 1,500 kcal',
        dietStatus: DietStatus.active,
        dietStart: DateTime.utc(2026, 11, 1),
        kcalTarget: 1500,
        mealsPerDay: 7,
        adherence: 0.91,
        missed7d: 1,
        loggedToday: 2,
        lastLoggedAt: DateTime.utc(2026, 11, 3, 3),
      ),
    ];
    final s = search.trim().toLowerCase();
    return Paged([
      for (final r in rows)
        if (s.isEmpty || r.name.toLowerCase().contains(s)) r,
    ], hasMore: false);
  }
}

class RecordingMealReminders implements MealReminders {
  final scheduled = <MealReminder>[];
  int cancels = 0;

  @override
  Future<void> schedule(List<MealReminder> reminders) async {
    scheduled
      ..clear()
      ..addAll(reminders);
  }

  @override
  Future<void> cancelAll() async {
    cancels++;
    scheduled.clear();
  }
}
