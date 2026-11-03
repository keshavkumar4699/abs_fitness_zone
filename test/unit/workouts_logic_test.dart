import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/core/utils/ids.dart';
import 'package:abs_fitness/features/exercises/domain/exercise.dart';
import 'package:abs_fitness/features/workouts/data/workouts_repository.dart';
import 'package:abs_fitness/features/workouts/domain/workout_logic.dart';
import 'package:abs_fitness/features/workouts/domain/workout_models.dart';
import 'package:abs_fitness/features/workouts/domain/workout_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/workout_fakes.dart';

SetLog s(String ex, int n, {double? w, int? r}) => SetLog(exerciseId: ex, setNo: n, weight: w, reps: r);

void main() {
  final today = DateTime.utc(2026, 11, 3); // a Tuesday

  group('estimated 1RM (Epley, like the database)', () {
    test('weight × (1 + reps / 30), one decimal', () {
      expect(estimateOneRm(100, 1), 103.3);
      expect(estimateOneRm(40, 8), 50.7);
      expect(estimateOneRm(42.5, 5), 49.6);
    });

    test('needs weight and 1–30 reps', () {
      expect(estimateOneRm(null, 5), isNull);
      expect(estimateOneRm(0, 5), isNull);
      expect(estimateOneRm(40, 0), isNull);
      expect(estimateOneRm(40, 31), isNull);
    });
  });

  group('progression (5.2)', () {
    const item = WorkoutItem(exerciseId: 'x', reps: 8, repsMax: 10, targetWeight: 40);

    test('+2.5 kg a week', () {
      final t = pplTemplate();
      expect(progressedTarget(item, t, 1).weight, 40);
      expect(progressedTarget(item, t, 3).weight, 45);
      expect(progressedTarget(item, t, 3).reps, 8);
    });

    test('+1 rep a week moves the range too', () {
      final t = fatLossTemplate();
      final r = progressedTarget(item, t, 4);
      expect(r.reps, 11);
      expect(r.repsMax, 13);
      expect(r.weight, 40);
    });

    test('program week counts from the start date', () {
      final p = aaravProgram();
      expect(programWeek(p, DateTime.utc(2026, 10, 27)), 1);
      expect(programWeek(p, DateTime.utc(2026, 11, 2)), 1);
      expect(programWeek(p, today), 2);
      expect(programWeek(p, DateTime.utc(2027, 3, 1)), 8, reason: 'clamped to the program length');
    });
  });

  group('schedule (5.11)', () {
    final p = aaravProgram(); // Tue / Thu / Sat → Push / Pull / Legs

    test('weekday i of the plan is day i', () {
      expect(plannedDayOn(p, today)?.name, 'Push');
      expect(plannedDayOn(p, DateTime.utc(2026, 11, 5))?.name, 'Pull');
      expect(plannedDayOn(p, DateTime.utc(2026, 11, 7))?.name, 'Legs');
      expect(plannedDayOn(p, DateTime.utc(2026, 11, 4)), isNull, reason: 'Wednesday is a rest day');
      expect(plannedDayOn(p, DateTime.utc(2026, 10, 20)), isNull, reason: 'before the start');
    });

    test('planned sessions and the next one', () {
      final s = plannedSessions(p, DateTime.utc(2026, 10, 20), DateTime.utc(2026, 11, 3));
      expect(s.map((x) => x.date.day), [27, 29, 31, 3]);
      expect(nextSession(p, DateTime.utc(2026, 11, 4))?.date, DateTime.utc(2026, 11, 5));
    });

    test('default weekdays match the database', () {
      expect(defaultWeekdays(3), [1, 3, 5]);
      expect(defaultWeekdays(4), [1, 2, 4, 5]);
      expect(defaultWeekdays(7), [1, 2, 3, 4, 5, 6, 7]);
    });
  });

  group('adherence and streak (5.5, 5.8)', () {
    final p = aaravProgram();
    final logs = aaravLogs();

    test('3 of 4 planned sessions → 0.75 (today counts as planned)', () {
      expect(adherence(p, logs, today), 0.75);
    });

    test('matches the database example: 2 of 7 → 0.29', () {
      final daily = p.copyWith(startDate: today.subtract(const Duration(days: 6)), weekdays: [1, 2, 3, 4, 5, 6, 7]);
      final two = [
        logs[0].copyWith(day: today.subtract(const Duration(days: 2))),
        logs[1].copyWith(day: today.subtract(const Duration(days: 2))),
        logs[2].copyWith(day: today.subtract(const Duration(days: 4))),
      ];
      expect(adherence(daily, two, today), 0.29);
    });

    test('nothing planned yet → null', () {
      expect(adherence(p.copyWith(startDate: DateTime.utc(2026, 11, 10)), logs, today), isNull);
    });

    test('streak: today does not break it until it is over', () {
      expect(streak(p, logs, today), 3);
      expect(streak(p, logs.sublist(0, 2), today), 2);
      expect(streak(p, [logs[0], logs[2]], today), 1, reason: 'Thursday was missed');
    });

    test('workouts per Monday-start week', () {
      expect(workoutsPerWeek(logs, today, weeks: 3), [0, 3, 0]);
    });
  });

  group('personal records (5.9), like the database', () {
    final history = [s('sq', 1, w: 40, r: 5), s('sq', 2, w: 40, r: 6), s('pu', 1, r: 10)];

    test('first time is a baseline', () {
      expect(detectPrs([s('new', 1, w: 100, r: 5)], history), isEmpty);
    });

    test('heavier weight, more reps at a weight, best e1RM, bodyweight reps', () {
      final prs = detectPrs([
        s('sq', 1, w: 42.5, r: 5),
        s('sq', 2, w: 40, r: 8),
        s('pu', 1, r: 12),
        s('pu', 2, r: 11),
      ], history);
      PrHit at(String ex, int n) => prs.firstWhere((p) => p.exerciseId == ex && p.setNo == n);
      expect(at('sq', 1).kinds, contains('weight'));
      expect(at('sq', 2).kinds, containsAll(['reps', 'e1rm']), reason: '40 × 8 beats 40 × 6 and has the best e1RM');
      expect(at('pu', 1).kinds, ['reps']);
      expect(prs.where((p) => p.exerciseId == 'pu'), hasLength(1), reason: 'only the best set per kind');
    });

    test('equal is not a record', () {
      expect(detectPrs([s('sq', 1, w: 40, r: 6)], history), isEmpty);
    });
  });

  group('workout session (5.6)', () {
    final catalogue = ExerciseIndex(seedCatalogue());
    WorkoutSession session() => WorkoutSession.forDay(
      clientId: 'c1',
      program: aaravProgram(),
      day: aaravProgram().template!.orderedDays.first,
      catalogue: catalogue,
      history: aaravLogs(),
      now: DateTime.utc(2026, 11, 3, 4, 30),
      today: today,
    );

    test('prefills last time, falls back to the week\'s target', () {
      final x = session();
      final bench = x.exercises.first;
      expect(bench.name, 'Barbell Bench Press - Medium Grip');
      expect(bench.sets.map((e) => e.reps), [8, 8, 7], reason: 'from last Tuesday');
      expect(bench.sets.first.targetWeight, 42.5, reason: 'week 2 adds 2.5 kg');
      final lateral = x.exercises[2];
      expect(lateral.sets.first.weight, 6.5, reason: 'never done: the plan, 4 kg + 2.5 for week 2');
    });

    test('supersets rest only after their last exercise', () {
      final x = session();
      expect(x.restAfter(0), 90);
      expect(x.restAfter(2), 0, reason: 'lateral raise is followed by its superset partner');
      expect(x.restAfter(3), 60);
    });

    test('payload holds only ticked sets, with the tracked fields', () {
      var x = session();
      final ex = x.exercises.first;
      x = x.copyWith(
        exercises: [
          ex.copyWith(
            sets: [
              ex.sets[0].copyWith(done: true, weight: 42.5, reps: 8, doneAt: DateTime.utc(2026, 11, 3, 4, 40)),
              ...ex.sets.skip(1),
            ],
          ),
          ...x.exercises.skip(1),
        ],
      );
      final p = x.toPayload(finishedAt: DateTime.utc(2026, 11, 3, 5, 30), complete: x.isComplete);
      expect(p['status'], 'partial');
      expect(p['sets'], [
        {
          'exercise_id': 'Barbell_Bench_Press_-_Medium_Grip',
          'set_no': 1,
          'weight': 42.5,
          'reps': 8,
          'duration_s': null,
          'distance_m': null,
          'done_at': '2026-11-03T04:40:00.000Z',
        },
      ]);
      expect(x.volume, 340);
      expect(WorkoutSession.fromJson(x.toJson()), x, reason: 'survives being saved on the phone');
    });
  });

  group('outbox (offline logging)', () {
    test('keeps payloads until the server takes them', () async {
      SharedPreferences.setMockInitialValues({});
      final outbox = WorkoutOutbox(await SharedPreferences.getInstance());
      final repo = FakeWorkoutsRepository()..offline = true;
      final p = {
        'client_id': 'abc',
        'name': 'Push',
        'started_at': '2026-11-03T04:30:00Z',
        'finished_at': '2026-11-03T05:30:00Z',
        'status': 'completed',
        'sets': <Object>[],
      };
      await outbox.put(p);
      await outbox.put(p);
      expect(outbox.pending(), hasLength(1), reason: 'the same workout replaces itself');
      expect(await outbox.flush(repo), isEmpty);
      expect(outbox.pending(), hasLength(1));
      repo.offline = false;
      expect((await outbox.flush(repo)).keys, ['abc']);
      expect(outbox.pending(), isEmpty);
    });

    test('drops a payload the server refuses for good', () async {
      SharedPreferences.setMockInitialValues({});
      final outbox = WorkoutOutbox(await SharedPreferences.getInstance());
      final repo = FakeWorkoutsRepository()..error = const RuleFailure('workouts can be edited for 24 hours');
      await outbox.put({'client_id': 'old'});
      await outbox.flush(repo);
      expect(outbox.pending(), isEmpty);
    });
  });

  group('exercise library (4.3, 4.4)', () {
    final index = ExerciseIndex(seedCatalogue());

    test('search across 800+ exercises in under 100 ms', () {
      expect(index.length, 876);
      final sw = Stopwatch()..start();
      for (final q in ['squat', 'bench', 'curl', 'stretch', 'row', 'pu']) {
        index.query(ExerciseFilter(search: q));
      }
      sw.stop();
      expect(sw.elapsedMilliseconds / 6, lessThan(100));
    });

    test('ranks names that start with the query first', () {
      final r = index.query(const ExerciseFilter(search: 'squat'));
      expect(r.first.name.toLowerCase(), startsWith('squat'));
      expect(r.map((e) => e.name), contains('Barbell Squat'));
    });

    test('filters by muscle, equipment, level and our equipment', () {
      final chest = index.query(const ExerciseFilter(muscle: 'chest', equipment: 'dumbbell'));
      expect(chest, isNotEmpty);
      expect(chest.every((e) => e.equipment == 'dumbbell' && e.allMuscles.contains('chest')), isTrue);
      expect(chest.first.primaryMuscles, contains('chest'), reason: 'primary matches first');
      final ours = index.query(const ExerciseFilter(ourEquipmentOnly: true), gymEquipment: {'body only'});
      expect(ours.every((e) => e.equipment == null || e.equipment == 'body only'), isTrue);
      final favs = index.query(const ExerciseFilter(favouritesOnly: true), favourites: {'Plank'});
      expect(favs.map((e) => e.id), ['Plank']);
    });

    test('Hindi names are searchable', () {
      final local = ExerciseIndex([
        Exercise(id: 'a', name: 'Bodyweight Squat', localName: 'उठक-बैठक', updatedAt: DateTime.utc(2026)),
      ]);
      expect(local.query(const ExerciseFilter(search: 'बैठक')), hasLength(1));
    });

    test('alternatives: same muscle, different equipment', () {
      final squat = index['Barbell_Squat']!;
      final alts = index.alternatives(squat);
      expect(alts, isNotEmpty);
      expect(alts.every((e) => e.primaryMuscles.contains('quadriceps') && e.equipment != 'barbell'), isTrue);
    });

    test('image URLs: the bucket by default, or the owner\'s base', () {
      expect(
        exerciseImageUrl('Plank/0.jpg', supabaseUrl: 'https://x.supabase.co/'),
        'https://x.supabase.co/storage/v1/object/public/exercises/Plank/0.jpg',
      );
      expect(
        exerciseImageUrl('Plank/0.jpg', supabaseUrl: 'https://x.supabase.co', imageBase: 'https://cdn.test/ex/'),
        'https://cdn.test/ex/Plank/0.jpg',
      );
      expect(exerciseImageUrl(null, supabaseUrl: 'https://x.supabase.co'), isNull);
    });

    test('custom exercise videos must be YouTube', () {
      expect(ExerciseDraft.isYoutube('https://youtu.be/abc'), isTrue);
      expect(ExerciseDraft.isYoutube('https://www.youtube.com/watch?v=abc'), isTrue);
      expect(ExerciseDraft.isYoutube('https://vimeo.com/1'), isFalse);
    });
  });

  test('client ids are version-4 UUIDs', () {
    final id = newUuid();
    expect(id, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
    expect(newUuid(), isNot(id));
  });
}
