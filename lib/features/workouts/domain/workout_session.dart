import 'package:freezed_annotation/freezed_annotation.dart';

import '../../exercises/domain/exercise.dart';
import 'workout_logic.dart';
import 'workout_models.dart';

part 'workout_session.freezed.dart';
part 'workout_session.g.dart';

/// One set row in the player (5.6): the target, what was done, and a tick.
@freezed
abstract class SessionSet with _$SessionSet {
  const factory SessionSet({
    required int setNo,
    double? targetWeight,
    int? targetReps,
    int? targetDuration,
    double? weight,
    int? reps,
    int? durationS,
    int? distanceM,
    @Default(false) bool done,
    DateTime? doneAt,
  }) = _SessionSet;

  factory SessionSet.fromJson(Map<String, dynamic> json) => _$SessionSetFromJson(json);
}

@freezed
abstract class SessionExercise with _$SessionExercise {
  const SessionExercise._();

  const factory SessionExercise({
    required String exerciseId,
    required String name,
    @Default(TrackingType.repsWeight) TrackingType trackingType,
    @Default(ItemBlock.main) ItemBlock block,
    String? groupKey,
    @Default(60) int restS,
    String? tempo,
    String? notes,
    @Default(<SessionSet>[]) List<SessionSet> sets,
  }) = _SessionExercise;

  factory SessionExercise.fromJson(Map<String, dynamic> json) => _$SessionExerciseFromJson(json);

  int get doneCount => sets.where((s) => s.done).length;
  bool get isDone => sets.isNotEmpty && sets.every((s) => s.done);
}

/// A workout in progress. Saved on the phone after every change, so it
/// survives the app closing and works fully offline.
@freezed
abstract class WorkoutSession with _$WorkoutSession {
  const WorkoutSession._();

  const factory WorkoutSession({
    required String clientId,
    required String memberId,
    String? programId,
    String? dayId,
    required String name,
    required DateTime startedAt,
    @Default(<SessionExercise>[]) List<SessionExercise> exercises,
    @Default(0) int current,
    DateTime? restEndsAt,
    @Default(0) int restTotalS,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => _$WorkoutSessionFromJson(json);

  /// Builds the session for a program day: targets after the week's
  /// progression, weight and reps prefilled from last time.
  factory WorkoutSession.forDay({
    required String clientId,
    required MemberProgram program,
    required WorkoutDay day,
    required ExerciseIndex catalogue,
    required Iterable<WorkoutLog> history,
    required DateTime now,
    required DateTime today,
  }) {
    final t = program.template!;
    final week = programWeek(program, today, weeks: t.weeks);
    return WorkoutSession(
      clientId: clientId,
      memberId: program.memberId,
      programId: program.id,
      dayId: day.id,
      name: day.name,
      startedAt: now,
      exercises: [
        for (final item in day.ordered)
          () {
            final ex = catalogue[item.exerciseId];
            final target = progressedTarget(item, t, week);
            final last = lastTimeSets(item.exerciseId, history);
            return SessionExercise(
              exerciseId: item.exerciseId,
              name: ex?.name ?? '—',
              trackingType: ex?.trackingType ?? TrackingType.repsWeight,
              block: item.block,
              groupKey: item.groupKey,
              restS: item.restS,
              tempo: item.tempo,
              notes: item.notes,
              sets: [
                for (var n = 1; n <= item.sets; n++)
                  () {
                    final prev = last.isEmpty ? null : (n <= last.length ? last[n - 1] : last.last);
                    return SessionSet(
                      setNo: n,
                      targetWeight: target.weight,
                      targetReps: target.reps,
                      targetDuration: item.durationS,
                      // Last time first, then the plan.
                      weight: prev?.weight ?? target.weight,
                      reps: prev?.reps ?? target.reps,
                      durationS: prev?.durationS ?? item.durationS,
                      distanceM: prev?.distanceM ?? item.distanceM,
                    );
                  }(),
              ],
            );
          }(),
      ],
    );
  }

  int get totalSets => exercises.fold(0, (a, e) => a + e.sets.length);
  int get doneSets => exercises.fold(0, (a, e) => a + e.doneCount);
  double get progress => totalSets == 0 ? 0 : doneSets / totalSets;
  bool get isComplete => totalSets > 0 && doneSets == totalSets;

  List<SetLog> get doneSetLogs => [
    for (final e in exercises)
      for (final s in e.sets.where((s) => s.done))
        SetLog(
          exerciseId: e.exerciseId,
          setNo: s.setNo,
          weight: e.trackingType.usesWeight ? s.weight : null,
          reps: e.trackingType.usesReps ? s.reps : null,
          durationS: e.trackingType.usesTime ? s.durationS : null,
          distanceM: e.trackingType == TrackingType.distanceTime ? s.distanceM : null,
          doneAt: s.doneAt,
        ),
  ];

  double get volume => setVolume(doneSetLogs);

  /// Rest after a set of exercise [i]: none between exercises of a superset
  /// until its last one.
  int restAfter(int i) {
    final e = exercises[i];
    final next = i + 1 < exercises.length ? exercises[i + 1] : null;
    if (e.groupKey != null && next?.groupKey == e.groupKey) return 0;
    return e.restS;
  }

  /// What `save_workout_log` expects.
  Map<String, dynamic> toPayload({required DateTime finishedAt, required bool complete, String? notes}) => {
    'client_id': clientId,
    'program_id': programId,
    'day_id': dayId,
    'name': name,
    'started_at': startedAt.toUtc().toIso8601String(),
    'finished_at': finishedAt.toUtc().toIso8601String(),
    'status': complete ? 'completed' : 'partial',
    'notes': notes,
    'sets': [
      for (final s in doneSetLogs)
        {
          'exercise_id': s.exerciseId,
          'set_no': s.setNo,
          'weight': s.weight,
          'reps': s.reps,
          'duration_s': s.durationS,
          'distance_m': s.distanceM,
          'done_at': (s.doneAt ?? finishedAt).toUtc().toIso8601String(),
        },
    ],
  };
}

/// The finish screen's numbers (5.6).
class WorkoutSummary {
  const WorkoutSummary({
    required this.name,
    required this.duration,
    required this.volume,
    required this.setsDone,
    required this.prs,
    required this.complete,
    this.synced = false,
  });

  final String name;
  final Duration duration;
  final double volume;
  final int setsDone;
  final List<PrHit> prs;
  final bool complete;

  /// False while it waits in the outbox for a connection.
  final bool synced;

  WorkoutSummary copyWith({List<PrHit>? prs, bool? synced, double? volume}) => WorkoutSummary(
    name: name,
    duration: duration,
    volume: volume ?? this.volume,
    setsDone: setsDone,
    prs: prs ?? this.prs,
    complete: complete,
    synced: synced ?? this.synced,
  );
}
