import 'dart:convert';
import 'dart:io';

import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/core/paging.dart';
import 'package:abs_fitness/features/exercises/data/exercise_repository.dart';
import 'package:abs_fitness/features/exercises/domain/exercise.dart';
import 'package:abs_fitness/features/workouts/application/rest_alerts.dart';
import 'package:abs_fitness/features/workouts/data/workouts_repository.dart';
import 'package:abs_fitness/features/workouts/domain/workout_logic.dart';
import 'package:abs_fitness/features/workouts/domain/workout_models.dart';
import 'package:flutter/foundation.dart' show Uint8List;

/// The real seeded catalogue (876 exercises), ids = dataset ids.
List<Exercise> seedCatalogue() {
  final data = jsonDecode(File('supabase/seed/exercises.json').readAsStringSync()) as List<dynamic>;
  return [
    for (final x in data.cast<Map<String, dynamic>>())
      Exercise(
        id: x['id'] as String,
        sourceId: x['id'] as String,
        name: (x['name'] as String).trim(),
        primaryMuscles: (x['primaryMuscles'] as List<dynamic>).cast<String>(),
        secondaryMuscles: (x['secondaryMuscles'] as List<dynamic>).cast<String>(),
        equipment: x['equipment'] as String?,
        level: x['level'] as String?,
        category: x['category'] as String?,
        mechanic: x['mechanic'] as String?,
        force: x['force'] as String?,
        trackingType: _tracking(x),
        instructions: (x['instructions'] as List<dynamic>).cast<String>(),
        images: (x['images'] as List<dynamic>).cast<String>(),
        updatedAt: DateTime.utc(2026, 11, 1),
      ),
  ];
}

TrackingType _tracking(Map<String, dynamic> x) {
  final cat = x['category'], eq = x['equipment'];
  if (cat == 'stretching' || eq == 'foam roll') return TrackingType.time;
  if (cat == 'cardio') {
    return RegExp(
          'treadmill|bicycling|rowing|running|jogging|walking|elliptical',
          caseSensitive: false,
        ).hasMatch(x['name'] as String)
        ? TrackingType.distanceTime
        : TrackingType.time;
  }
  if (cat == 'plyometrics') return TrackingType.reps;
  const noLoad = {null, 'body only', 'bands', 'exercise ball', 'foam roll', 'other'};
  if (x['force'] == 'static' && noLoad.contains(eq)) return TrackingType.time;
  if (noLoad.contains(eq)) return TrackingType.reps;
  return TrackingType.repsWeight;
}

class FakeExerciseRepository implements ExerciseRepository {
  FakeExerciseRepository({List<Exercise>? exercises}) : exercises = exercises ?? seedCatalogue();

  final List<Exercise> exercises;
  final Set<String> favs = {'Barbell_Squat'};
  Set<String> equipment = {...kEquipment}..remove('kettlebells');
  final calls = <String>[];
  Object? error;

  @override
  Future<List<Exercise>> catalogue() async {
    if (error != null) throw error!;
    return exercises;
  }

  @override
  Future<Set<String>> favourites() async => {...favs};

  @override
  Future<void> setFavourite(String exerciseId, {required bool on}) async {
    calls.add('fav:$exerciseId:$on');
    on ? favs.add(exerciseId) : favs.remove(exerciseId);
  }

  @override
  Future<TrainingSettings> trainingSettings() async => TrainingSettings(equipment: equipment);

  @override
  Future<void> saveEquipment(Set<String> equipment) async {
    calls.add('equipment:${equipment.length}');
    this.equipment = {...equipment};
  }

  @override
  Future<String> saveCustom(ExerciseDraft draft, {Uint8List? photo}) async {
    calls.add('custom:${draft.name}');
    final id = draft.id ?? 'custom-${exercises.length}';
    exercises
      ..removeWhere((e) => e.id == id)
      ..add(
        Exercise(
          id: id,
          name: draft.name,
          localName: draft.localName,
          primaryMuscles: draft.primaryMuscles,
          secondaryMuscles: draft.secondaryMuscles,
          equipment: draft.equipment,
          level: draft.level,
          category: draft.category,
          trackingType: draft.trackingType,
          instructions: draft.instructions,
          tips: draft.tips,
          videoUrl: draft.videoUrl,
          isCustom: true,
          createdBy: 'u-trainer',
          updatedAt: DateTime.utc(2026, 11, 3),
        ),
      );
    return id;
  }

  @override
  Future<void> archive(String id) async {
    calls.add('archive:$id');
    final i = exercises.indexWhere((e) => e.id == id);
    exercises[i] = exercises[i].copyWith(archivedAt: DateTime.utc(2026, 11, 3));
  }
}

WorkoutItem _i(
  String ex,
  int pos, {
  int sets = 3,
  int? reps,
  double? weight,
  int? secs,
  int rest = 90,
  String? group,
}) => WorkoutItem(
  id: 'it-$ex-$pos',
  exerciseId: ex,
  position: pos,
  sets: sets,
  reps: reps,
  targetWeight: weight,
  durationS: secs,
  restS: rest,
  groupKey: group,
);

WorkoutTemplate pplTemplate({String id = 'tpl-ppl', bool library = true}) => WorkoutTemplate(
  id: id,
  name: 'Push / Pull / Legs',
  description: 'The classic three-day split.',
  goal: 'muscle_gain',
  level: 'intermediate',
  weeks: 8,
  progression: Progression.weight,
  progressionStep: 2.5,
  isGymTemplate: library,
  isStarter: library,
  days: [
    WorkoutDay(
      id: '$id-d1',
      dayIndex: 1,
      name: 'Push',
      items: [
        _i('Barbell_Bench_Press_-_Medium_Grip', 1, reps: 8, weight: 40),
        _i('Dumbbell_Shoulder_Press', 2, reps: 10, weight: 10),
        _i('Side_Lateral_Raise', 3, reps: 15, weight: 4, rest: 45, group: 'A'),
        _i('Triceps_Pushdown', 4, reps: 12, weight: 15, rest: 60, group: 'A'),
      ],
    ),
    WorkoutDay(
      id: '$id-d2',
      dayIndex: 2,
      name: 'Pull',
      items: [
        _i('Barbell_Deadlift', 1, reps: 5, weight: 50, rest: 180),
        _i('Pullups', 2, reps: 6),
        _i('Barbell_Curl', 3, reps: 10, weight: 15),
      ],
    ),
    WorkoutDay(
      id: '$id-d3',
      dayIndex: 3,
      name: 'Legs',
      items: [
        _i('Barbell_Squat', 1, sets: 4, reps: 8, weight: 40, rest: 150),
        _i('Leg_Press', 2, reps: 12, weight: 60),
        _i('Plank', 3, secs: 30, rest: 45),
      ],
    ),
  ],
);

WorkoutTemplate fatLossTemplate() => WorkoutTemplate(
  id: 'tpl-fat',
  name: 'Beginner fat loss',
  description: 'Three easy full-body days.',
  goal: 'fat_loss',
  level: 'beginner',
  weeks: 6,
  progression: Progression.reps,
  progressionStep: 1,
  isStarter: true,
  days: [
    WorkoutDay(
      id: 'tpl-fat-d1',
      name: 'Full body A',
      items: [_i('Bodyweight_Squat', 1, reps: 12, rest: 60), _i('Pushups', 2, reps: 10, rest: 60)],
    ),
    WorkoutDay(
      id: 'tpl-fat-d2',
      dayIndex: 2,
      name: 'Cardio and core',
      items: [_i('Crunches', 1, reps: 15, rest: 45), _i('Plank', 2, secs: 30, rest: 45)],
    ),
  ],
);

/// Aarav (m-1) runs Push / Pull / Legs on Tue/Thu/Sat from 27 Oct and did
/// all three sessions last week; today (Tue 3 Nov) is a Push day.
MemberProgram aaravProgram() => MemberProgram(
  id: 'prog-1',
  memberId: 'm-1',
  templateId: 'snap-1',
  sourceTemplateId: 'tpl-ppl',
  name: 'Push / Pull / Legs',
  startDate: DateTime.utc(2026, 10, 27),
  endDate: DateTime.utc(2026, 12, 21),
  weekdays: const [2, 4, 6],
  template: pplTemplate(id: 'snap-1', library: false),
  assignedAt: DateTime.utc(2026, 10, 26, 6),
);

WorkoutLog _log(
  String id,
  DateTime day,
  String dayId,
  String name,
  List<SetLog> sets, {
  List<WorkoutComment> comments = const [],
}) => WorkoutLog(
  id: id,
  clientId: 'client-$id',
  memberId: 'm-1',
  programId: 'prog-1',
  dayId: dayId,
  name: name,
  startedAt: day.add(const Duration(hours: 1)),
  finishedAt: day.add(const Duration(hours: 1, minutes: 52)),
  day: day,
  durationS: 52 * 60,
  totalVolume: setVolume(sets),
  sets: sets,
  comments: comments,
);

SetLog _s(String ex, int n, {double? w, int? r, int? secs, bool pr = false}) => SetLog(
  exerciseId: ex,
  setNo: n,
  weight: w,
  reps: r,
  durationS: secs,
  isPr: pr,
  prKinds: pr ? const ['weight'] : const [],
);

List<WorkoutLog> aaravLogs() => [
  _log(
    'log-3',
    DateTime.utc(2026, 10, 31),
    'snap-1-d3',
    'Legs',
    [
      _s('Barbell_Squat', 1, w: 45, r: 8, pr: true),
      _s('Barbell_Squat', 2, w: 45, r: 8),
      _s('Barbell_Squat', 3, w: 42.5, r: 8),
      _s('Barbell_Squat', 4, w: 42.5, r: 7),
      _s('Leg_Press', 1, w: 60, r: 12),
      _s('Plank', 1, secs: 40),
    ],
    comments: [
      WorkoutComment(
        id: 'c1',
        authorName: 'Vikram Rao',
        body: 'Solid squats!',
        emoji: 'fire',
        createdAt: DateTime.utc(2026, 10, 31, 12),
      ),
    ],
  ),
  _log('log-2', DateTime.utc(2026, 10, 29), 'snap-1-d2', 'Pull', [
    _s('Barbell_Deadlift', 1, w: 50, r: 5),
    _s('Barbell_Deadlift', 2, w: 50, r: 5),
    _s('Pullups', 1, r: 6),
    _s('Barbell_Curl', 1, w: 15, r: 10),
  ]),
  _log('log-1', DateTime.utc(2026, 10, 27), 'snap-1-d1', 'Push', [
    _s('Barbell_Bench_Press_-_Medium_Grip', 1, w: 40, r: 8),
    _s('Barbell_Bench_Press_-_Medium_Grip', 2, w: 40, r: 8),
    _s('Barbell_Bench_Press_-_Medium_Grip', 3, w: 40, r: 7),
    _s('Dumbbell_Shoulder_Press', 1, w: 10, r: 10),
  ]),
];

class FakeWorkoutsRepository implements WorkoutsRepository {
  FakeWorkoutsRepository({
    List<WorkoutTemplate>? templates,
    Map<String, List<MemberProgram>>? programs,
    List<WorkoutLog>? logs,
  }) : library = templates ?? [pplTemplate(), fatLossTemplate()],
       programsByMember =
           programs ??
           {
             'm-1': [aaravProgram()],
           },
       logStore = logs ?? aaravLogs();

  final List<WorkoutTemplate> library;
  final Map<String, List<MemberProgram>> programsByMember;
  final List<WorkoutLog> logStore;
  final calls = <String>[];
  final saved = <Map<String, dynamic>>[];
  Object? error;
  bool offline = false;
  int _seq = 10;

  void _maybeThrow() {
    if (offline) throw const NetworkFailure();
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<Paged<WorkoutTemplate>> templates({String search = '', int offset = 0}) async {
    _maybeThrow();
    final s = search.trim().toLowerCase();
    final list = library.where((t) => s.isEmpty || t.name.toLowerCase().contains(s)).toList();
    return Paged(list.skip(offset).take(kPageSize).toList(), hasMore: false);
  }

  @override
  Future<WorkoutTemplate> template(String id) async {
    _maybeThrow();
    for (final t in library) {
      if (t.id == id) return t;
    }
    for (final p in programsByMember.values.expand((x) => x)) {
      if (p.templateId == id) return p.template!;
    }
    throw const NotFoundFailure();
  }

  @override
  Future<String> saveTemplate(WorkoutTemplate t) async {
    _maybeThrow();
    calls.add('save:${t.name}:${t.days.length}');
    if (t.days.isEmpty) throw const RuleFailure('a program needs 1 to 7 days');
    final id = t.id ?? 'tpl-${_seq++}';
    final days = [
      for (final (n, d) in t.orderedDays.indexed)
        d.copyWith(
          id: '$id-d${n + 1}',
          dayIndex: n + 1,
          items: [for (final (p, i) in d.ordered.indexed) i.copyWith(id: '$id-d${n + 1}-$p', position: p + 1)],
        ),
    ];
    final saved = t.copyWith(id: id, days: days);
    final i = library.indexWhere((x) => x.id == id);
    if (i >= 0) {
      library[i] = saved;
    } else {
      // A member's snapshot?
      var replaced = false;
      for (final list in programsByMember.values) {
        for (var k = 0; k < list.length; k++) {
          if (list[k].templateId == id) {
            list[k] = list[k].copyWith(template: saved.copyWith(isGymTemplate: false));
            replaced = true;
          }
        }
      }
      if (!replaced) library.add(saved);
    }
    return id;
  }

  @override
  Future<String> duplicateTemplate(String id, {String? name}) async {
    _maybeThrow();
    final src = await template(id);
    calls.add('duplicate:$id');
    final newId = 'tpl-${_seq++}';
    library.add(
      src.copyWith(
        id: newId,
        name: name ?? '${src.name} (copy)',
        isStarter: false,
        isGymTemplate: true,
        sourceTemplateId: id,
      ),
    );
    return newId;
  }

  @override
  Future<void> archiveTemplate(String id) async {
    calls.add('archive:$id');
    library.removeWhere((t) => t.id == id);
  }

  @override
  Future<int> assign({
    required String templateId,
    required List<String> memberIds,
    DateTime? start,
    List<int>? weekdays,
    AssignMode mode = AssignMode.replace,
  }) async {
    _maybeThrow();
    final t = await template(templateId);
    calls.add('assign:$templateId:${memberIds.join(',')}:${mode.name}:${weekdays?.join('') ?? ''}');
    final s = start ?? DateTime.utc(2026, 11, 3);
    for (final m in memberIds) {
      final list = programsByMember.putIfAbsent(m, () => []);
      if (mode == AssignMode.replace) {
        for (var k = 0; k < list.length; k++) {
          if (list[k].status == ProgramStatus.active) list[k] = list[k].copyWith(status: ProgramStatus.replaced);
        }
      }
      final snapshotId = 'snap-${_seq++}';
      list.insert(
        0,
        MemberProgram(
          id: 'prog-${_seq++}',
          memberId: m,
          templateId: snapshotId,
          sourceTemplateId: templateId,
          name: t.name,
          startDate: s,
          endDate: s.add(Duration(days: t.weeks * 7 - 1)),
          weekdays: weekdays ?? defaultWeekdays(t.days.length),
          status: mode == AssignMode.queue && list.any((p) => p.status == ProgramStatus.active)
              ? ProgramStatus.queued
              : ProgramStatus.active,
          template: t.copyWith(id: snapshotId, isGymTemplate: false),
        ),
      );
    }
    return memberIds.length;
  }

  @override
  Future<void> endProgram(String programId) async {
    calls.add('end:$programId');
    for (final list in programsByMember.values) {
      for (var k = 0; k < list.length; k++) {
        if (list[k].id == programId) list[k] = list[k].copyWith(status: ProgramStatus.cancelled);
      }
    }
  }

  @override
  Future<List<MemberProgram>> programs(String memberId) async {
    _maybeThrow();
    return [...?programsByMember[memberId]];
  }

  @override
  Future<Paged<WorkoutLog>> logs(String memberId, {int offset = 0}) async {
    _maybeThrow();
    final list = logStore.where((l) => l.memberId == memberId).toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return Paged(list.skip(offset).take(kPageSize).toList(), hasMore: false);
  }

  @override
  Future<List<WorkoutLog>> recentLogs(String memberId, {required DateTime since}) async {
    _maybeThrow();
    return (await logs(memberId)).items.where((l) => !l.day!.isBefore(since)).toList();
  }

  @override
  Future<List<DatedSet>> exerciseHistory(String memberId, String exerciseId) async {
    _maybeThrow();
    return [
      for (final l in logStore.reversed.where((l) => l.memberId == memberId))
        for (final s in l.sets.where((s) => s.exerciseId == exerciseId)) DatedSet(l.day!, s),
    ];
  }

  @override
  Future<SaveLogResult> saveLog(Map<String, dynamic> payload) async {
    _maybeThrow();
    calls.add('saveLog:${payload['client_id']}');
    saved.add(payload);
    final sets = [for (final s in (payload['sets'] as List<dynamic>).cast<Map<String, dynamic>>()) SetLog.fromJson(s)];
    final history = [for (final l in logStore.where((l) => l.clientId != payload['client_id'])) ...l.sets];
    final prs = detectPrs(sets, history);
    final started = DateTime.parse(payload['started_at'] as String);
    final log = WorkoutLog(
      id: 'log-${_seq++}',
      clientId: payload['client_id'] as String,
      memberId: 'm-1',
      programId: payload['program_id'] as String?,
      dayId: payload['day_id'] as String?,
      name: payload['name'] as String,
      startedAt: started,
      finishedAt: DateTime.parse(payload['finished_at'] as String),
      day: DateTime.utc(2026, 11, 3),
      totalVolume: setVolume(sets),
      status: payload['status'] as String,
      sets: [
        for (final s in sets)
          s.copyWith(
            isPr: prs.any((p) => p.exerciseId == s.exerciseId && p.setNo == s.setNo),
            prKinds: [...?prs.where((p) => p.exerciseId == s.exerciseId && p.setNo == s.setNo).firstOrNull?.kinds],
          ),
      ],
    );
    logStore
      ..removeWhere((l) => l.clientId == log.clientId)
      ..insert(0, log);
    return SaveLogResult(logId: log.id, totalVolume: log.totalVolume, prs: prs);
  }

  @override
  Future<void> comment(String logId, {String? body, String? emoji}) async {
    _maybeThrow();
    calls.add('comment:$logId:${body ?? ''}:${emoji ?? ''}');
    final i = logStore.indexWhere((l) => l.id == logId);
    logStore[i] = logStore[i].copyWith(
      comments: [
        ...logStore[i].comments,
        WorkoutComment(
          id: 'c-${_seq++}',
          authorName: 'Vikram Rao',
          body: body,
          emoji: emoji,
          createdAt: DateTime.utc(2026, 11, 3, 6),
        ),
      ],
    );
  }

  @override
  Future<Paged<CoachRow>> coachOverview({String? trainerId, String search = '', int offset = 0}) async {
    _maybeThrow();
    final rows = [
      CoachRow(
        memberId: 'm-1',
        name: 'Aarav Sharma',
        memberCode: 'ABS-0001',
        trainerId: '3',
        status: 'active',
        programId: 'prog-1',
        programName: 'Push / Pull / Legs',
        programStatus: ProgramStatus.active,
        programStart: DateTime.utc(2026, 10, 27),
        programEnd: DateTime.utc(2026, 12, 21),
        lastWorkoutAt: DateTime.utc(2026, 10, 31, 6),
        workouts7d: 3,
        adherence: 0.75,
        plannedToday: true,
      ),
      const CoachRow(memberId: 'm-2', name: 'Priya Verma', memberCode: 'ABS-0002', status: 'expiring'),
      CoachRow(
        memberId: 'm-4',
        name: 'Sneha Kumari',
        memberCode: 'ABS-0004',
        status: 'frozen',
        programId: 'prog-9',
        programName: 'Beginner fat loss',
        programStatus: ProgramStatus.active,
        lastWorkoutAt: DateTime.utc(2026, 10, 22, 6),
        adherence: 0.25,
        missed7d: 2,
      ),
    ];
    final s = search.trim().toLowerCase();
    return Paged(rows.where((r) => s.isEmpty || r.name.toLowerCase().contains(s)).toList(), hasMore: false);
  }
}

class RecordingRestAlerts implements RestAlerts {
  final scheduled = <DateTime>[];
  int cancels = 0;

  @override
  Future<void> schedule(DateTime at, {required String title, required String body}) async => scheduled.add(at);

  @override
  Future<void> cancel() async => cancels++;
}
