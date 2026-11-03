import '../../../core/utils/dates.dart';
import 'workout_models.dart';

/// Pure workout maths, shared by the player, the progress screens and the
/// coach views. Dates are IST calendar dates (UTC midnight).

DateTime _d(DateTime x) => DateTime.utc(x.year, x.month, x.day);
int _daysBetween(DateTime a, DateTime b) => _d(b).difference(_d(a)).inDays;

/// Estimated one-rep max (Epley), as the database computes it: weight ×
/// (1 + reps / 30) for 1–30 reps, rounded to 0.1 kg.
double? estimateOneRm(double? weight, int? reps) {
  if (weight == null || weight <= 0 || reps == null || reps < 1 || reps > 30) return null;
  return (weight * (1 + reps / 30) * 10).round() / 10;
}

double setVolume(Iterable<SetLog> sets) => sets.fold(0.0, (a, s) => a + s.volume);

/// Week 1, 2, … of a program on [day] (clamped to the program length).
int programWeek(MemberProgram p, DateTime day, {int? weeks}) {
  final start = p.startDate;
  if (start == null) return 1;
  final w = (_daysBetween(start, day) ~/ 7) + 1;
  final max = weeks ?? p.template?.weeks ?? 52;
  return w.clamp(1, max < 1 ? 1 : max);
}

/// The target for an item in a given week, after the template's progressive
/// overload rule (5.2): +step kg or +step reps per week.
({double? weight, int? reps, int? repsMax}) progressedTarget(WorkoutItem item, WorkoutTemplate t, int week) {
  final step = t.progressionStep ?? 0;
  final n = (week - 1).clamp(0, 52);
  switch (t.progression) {
    case Progression.weight when item.targetWeight != null:
      return (weight: item.targetWeight! + step * n, reps: item.reps, repsMax: item.repsMax);
    case Progression.reps when item.reps != null:
      final add = (step * n).round();
      return (
        weight: item.targetWeight,
        reps: item.reps! + add,
        repsMax: item.repsMax == null ? null : item.repsMax! + add,
      );
    default:
      return (weight: item.targetWeight, reps: item.reps, repsMax: item.repsMax);
  }
}

/// The program day planned for [day] (weekday i of the plan → day i), or
/// null on a rest day or outside the program's dates.
WorkoutDay? plannedDayOn(MemberProgram p, DateTime day) {
  final start = p.startDate, end = p.endDate, t = p.template;
  if (start == null || end == null || t == null) return null;
  final dd = _d(day);
  if (dd.isBefore(start) || dd.isAfter(end)) return null;
  final i = p.weekdays.indexOf(dd.weekday);
  final days = t.orderedDays;
  // Normally one weekday per day; if the plan has more weekdays than days,
  // the days repeat in order.
  return i < 0 || days.isEmpty ? null : days[i % days.length];
}

/// Every planned session from [from] to [to] (inclusive), within the program.
List<({DateTime date, WorkoutDay day})> plannedSessions(MemberProgram p, DateTime from, DateTime to) {
  final out = <({DateTime date, WorkoutDay day})>[];
  if (p.startDate == null || p.endDate == null) return out;
  var d = _d(from).isBefore(p.startDate!) ? p.startDate! : _d(from);
  final last = _d(to).isAfter(p.endDate!) ? p.endDate! : _d(to);
  while (!d.isAfter(last)) {
    final day = plannedDayOn(p, d);
    if (day != null) out.add((date: d, day: day));
    d = d.add(const Duration(days: 1));
  }
  return out;
}

/// The next planned session on or after [today].
({DateTime date, WorkoutDay day})? nextSession(MemberProgram p, DateTime today) {
  final s = plannedSessions(p, today, _d(today).add(const Duration(days: 14)));
  return s.isEmpty ? null : s.first;
}

Set<DateTime> _loggedDays(MemberProgram p, Iterable<WorkoutLog> logs) => {
  for (final l in logs)
    if (l.programId == p.id) _d(l.day ?? IstDates.istDate(l.startedAt)),
};

/// Share of planned sessions in the last [days] days that have a workout
/// logged, as the database's `program_adherence` computes it. Null when
/// nothing was planned yet.
double? adherence(MemberProgram p, Iterable<WorkoutLog> logs, DateTime today, {int days = 28}) {
  final start = p.startDate, end = p.endDate;
  if (start == null || end == null) return null;
  final from = _d(today).subtract(Duration(days: days - 1));
  final planned = plannedSessions(p, from, today).length;
  if (planned == 0) return null;
  final windowStart = start.isAfter(from) ? start : from;
  final windowEnd = end.isBefore(_d(today)) ? end : _d(today);
  final done = _loggedDays(p, logs).where((d) => !d.isBefore(windowStart) && !d.isAfter(windowEnd)).length;
  return ((done < planned ? done : planned) / planned * 100).round() / 100;
}

/// Planned sessions completed in a row, most recent first. Today doesn't
/// break the streak until it's over.
int streak(MemberProgram p, Iterable<WorkoutLog> logs, DateTime today) {
  final logged = _loggedDays(p, logs);
  final planned = plannedSessions(p, p.startDate ?? today, today).reversed;
  var n = 0;
  for (final s in planned) {
    if (logged.contains(s.date)) {
      n++;
    } else if (s.date == _d(today)) {
      continue;
    } else {
      break;
    }
  }
  return n;
}

/// Workouts in each of the last [weeks] Monday-start weeks, oldest first.
List<int> workoutsPerWeek(Iterable<WorkoutLog> logs, DateTime today, {int weeks = 8}) {
  final monday = _d(today).subtract(Duration(days: _d(today).weekday - 1));
  final counts = List<int>.filled(weeks, 0);
  for (final l in logs) {
    final day = _d(l.day ?? IstDates.istDate(l.startedAt));
    final w = monday.difference(day.subtract(Duration(days: day.weekday - 1))).inDays ~/ 7;
    if (w >= 0 && w < weeks) counts[weeks - 1 - w]++;
  }
  return counts;
}

/// The sets of [exerciseId] from the most recent workout that has it (for
/// prefilling "last time" in the player).
List<SetLog> lastTimeSets(String exerciseId, Iterable<WorkoutLog> history) {
  final sorted = [...history]..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  for (final l in sorted) {
    final sets = l.sets.where((s) => s.exerciseId == exerciseId).toList()..sort((a, b) => a.setNo.compareTo(b.setNo));
    if (sets.isNotEmpty) return sets;
  }
  return const [];
}

/// Personal records in [sets] against every earlier set in [history], with
/// the database's rules: heaviest weight, best estimated 1RM, and more reps
/// than ever at that weight or heavier (or more bodyweight reps). Only the
/// best set per kind counts, and a first-ever exercise sets the baseline.
List<PrHit> detectPrs(List<SetLog> sets, Iterable<SetLog> history) {
  final hits = <String, PrHit>{};
  void add(SetLog s, String kind) {
    final key = '${s.exerciseId}#${s.setNo}';
    final prev = hits[key];
    hits[key] =
        (prev ??
                PrHit(
                  exerciseId: s.exerciseId,
                  setNo: s.setNo,
                  weight: s.weight,
                  reps: s.reps,
                  e1rm: estimateOneRm(s.weight, s.reps),
                ))
            .copyWith(kinds: [...?prev?.kinds, kind]);
  }

  final byExercise = <String, List<SetLog>>{};
  for (final s in sets) {
    byExercise.putIfAbsent(s.exerciseId, () => []).add(s);
  }
  for (final entry in byExercise.entries) {
    final prev = history.where((h) => h.exerciseId == entry.key).toList();
    if (prev.isEmpty) continue;
    final mine = entry.value;
    final prevWeight = prev.map((h) => h.weight ?? 0).fold<double>(0, (a, b) => b > a ? b : a);
    final prevE1rm = prev.map((h) => estimateOneRm(h.weight, h.reps) ?? 0).fold<double>(0, (a, b) => b > a ? b : a);

    final weighted = mine.where((s) => (s.weight ?? 0) > 0 && (s.reps ?? 0) > 0).toList()
      ..sort((a, b) {
        final w = b.weight!.compareTo(a.weight!);
        return w != 0 ? w : (b.reps!.compareTo(a.reps!) != 0 ? b.reps!.compareTo(a.reps!) : a.setNo.compareTo(b.setNo));
      });
    if (weighted.isNotEmpty && weighted.first.weight! > prevWeight) add(weighted.first, 'weight');

    final byE1rm = mine.where((s) => estimateOneRm(s.weight, s.reps) != null).toList()
      ..sort((a, b) {
        final e = estimateOneRm(b.weight, b.reps)!.compareTo(estimateOneRm(a.weight, a.reps)!);
        return e != 0 ? e : a.setNo.compareTo(b.setNo);
      });
    if (byE1rm.isNotEmpty && estimateOneRm(byE1rm.first.weight, byE1rm.first.reps)! > prevE1rm) {
      add(byE1rm.first, 'e1rm');
    }

    final repsCandidates =
        mine.where((s) {
          if ((s.reps ?? 0) <= 0) return false;
          final atOrAbove = prev.where((h) => (h.weight ?? 0) >= (s.weight ?? 0)).map((h) => h.reps ?? 0);
          if (atOrAbove.isEmpty) return false;
          return s.reps! > atOrAbove.reduce((a, b) => a > b ? a : b);
        }).toList()..sort((a, b) {
          final w = (b.weight ?? 0).compareTo(a.weight ?? 0);
          return w != 0
              ? w
              : (b.reps!.compareTo(a.reps!) != 0 ? b.reps!.compareTo(a.reps!) : a.setNo.compareTo(b.setNo));
        });
    if (repsCandidates.isNotEmpty) add(repsCandidates.first, 'reps');
  }
  return hits.values.toList();
}

/// Weekday labels → ISO weekday numbers helper for assigning (Mon = 1).
List<int> defaultWeekdays(int days) => switch (days) {
  1 => [1],
  2 => [1, 4],
  3 => [1, 3, 5],
  4 => [1, 2, 4, 5],
  5 => [1, 2, 3, 4, 5],
  6 => [1, 2, 3, 4, 5, 6],
  _ => [1, 2, 3, 4, 5, 6, 7],
};
