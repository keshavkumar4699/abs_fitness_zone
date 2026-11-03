import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../domain/workout_models.dart';

part 'workouts_repository.g.dart';

enum AssignMode { replace, queue }

/// One logged set with the day it was done (exercise progress, 5.8).
class DatedSet {
  const DatedSet(this.day, this.set);

  final DateTime day;
  final SetLog set;
}

/// Workout templates, programs and logs (F5). Every write goes through a
/// database RPC that checks the caller's role.
abstract interface class WorkoutsRepository {
  Future<Paged<WorkoutTemplate>> templates({String search = '', int offset = 0});
  Future<WorkoutTemplate> template(String id);
  Future<String> saveTemplate(WorkoutTemplate t);
  Future<String> duplicateTemplate(String id, {String? name});
  Future<void> archiveTemplate(String id);

  Future<int> assign({
    required String templateId,
    required List<String> memberIds,
    DateTime? start,
    List<int>? weekdays,
    AssignMode mode = AssignMode.replace,
  });
  Future<void> endProgram(String programId);

  /// A member's programs, newest first, each with its template snapshot.
  Future<List<MemberProgram>> programs(String memberId);

  Future<Paged<WorkoutLog>> logs(String memberId, {int offset = 0});

  /// Logs (with sets) since [since], for stats, calendar and "last time".
  Future<List<WorkoutLog>> recentLogs(String memberId, {required DateTime since});
  Future<List<DatedSet>> exerciseHistory(String memberId, String exerciseId);

  Future<SaveLogResult> saveLog(Map<String, dynamic> payload);
  Future<void> comment(String logId, {String? body, String? emoji});
  Future<Paged<CoachRow>> coachOverview({String? trainerId, String search = '', int offset = 0});
}

Never _rethrow(Object e) {
  if (e is AppFailure) throw e;
  if (e is PostgrestException) {
    switch (e.code) {
      case '42501':
        throw const NotAllowedFailure();
      case 'P0002':
        throw const NotFoundFailure();
      case '22023' || '23514' || '23505':
        throw RuleFailure(e.message);
    }
    throw ServerFailure(e.message);
  }
  final t = e.toString();
  if (t.contains('SocketException') || t.contains('ClientException') || e is TimeoutException) {
    throw const NetworkFailure();
  }
  throw ServerFailure(t);
}

Future<T> _guard<T>(Future<T> Function() run) async {
  try {
    return await run();
  } catch (e) {
    _rethrow(e);
  }
}

class SupabaseWorkoutsRepository implements WorkoutsRepository {
  SupabaseWorkoutsRepository(this._db);

  final SupabaseClient _db;
  static const _full = '*, workout_days(*, workout_items(*))';
  static const _logFull = '*, set_logs(*), workout_comments(*)';

  @override
  Future<Paged<WorkoutTemplate>> templates({String search = '', int offset = 0}) => _guard(() async {
    var q = _db.from('workout_templates').select(_full).eq('is_gym_template', true).isFilter('archived_at', null);
    final s = sanitizeSearch(search);
    if (s.isNotEmpty) q = q.ilike('name', '%$s%');
    final rows = await q.order('is_starter', ascending: false).order('name').range(offset, offset + kPageSize - 1);
    final items = rows.map(WorkoutTemplate.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<WorkoutTemplate> template(String id) => _guard(() async {
    final row = await _db.from('workout_templates').select(_full).eq('id', id).maybeSingle();
    if (row == null) throw const NotFoundFailure();
    return WorkoutTemplate.fromJson(row);
  });

  @override
  Future<String> saveTemplate(WorkoutTemplate t) =>
      _guard(() => _db.rpc<String>('save_template', params: {'p': t.toPayload()}));

  @override
  Future<String> duplicateTemplate(String id, {String? name}) =>
      _guard(() => _db.rpc<String>('duplicate_template', params: {'p_template_id': id, 'p_name': name}));

  @override
  Future<void> archiveTemplate(String id) =>
      _guard(() => _db.rpc<void>('archive_template', params: {'p_template_id': id}));

  @override
  Future<int> assign({
    required String templateId,
    required List<String> memberIds,
    DateTime? start,
    List<int>? weekdays,
    AssignMode mode = AssignMode.replace,
  }) => _guard(
    () => _db.rpc<int>(
      'assign_program',
      params: {
        'p_template_id': templateId,
        'p_member_ids': memberIds,
        'p_start': workoutDate(start),
        'p_weekdays': weekdays,
        'p_mode': mode.name,
      },
    ),
  );

  @override
  Future<void> endProgram(String programId) =>
      _guard(() => _db.rpc<void>('end_program', params: {'p_program_id': programId}));

  @override
  Future<List<MemberProgram>> programs(String memberId) => _guard(() async {
    final rows = await _db
        .from('member_programs')
        .select('*, template:template_id($_full)')
        .eq('member_id', memberId)
        .order('start_date', ascending: false)
        .limit(20);
    return rows.map(MemberProgram.fromJson).toList();
  });

  @override
  Future<Paged<WorkoutLog>> logs(String memberId, {int offset = 0}) => _guard(() async {
    final rows = await _db
        .from('workout_logs')
        .select(_logFull)
        .eq('member_id', memberId)
        .order('started_at', ascending: false)
        .range(offset, offset + kPageSize - 1);
    final items = rows.map(WorkoutLog.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<List<WorkoutLog>> recentLogs(String memberId, {required DateTime since}) => _guard(() async {
    final rows = await _db
        .from('workout_logs')
        .select(_logFull)
        .eq('member_id', memberId)
        .gte('day', workoutDate(since)!)
        .order('started_at', ascending: false)
        .limit(200);
    return rows.map(WorkoutLog.fromJson).toList();
  });

  @override
  Future<List<DatedSet>> exerciseHistory(String memberId, String exerciseId) => _guard(() async {
    final rows = await _db
        .from('set_logs')
        .select('*, workout_logs(day)')
        .eq('member_id', memberId)
        .eq('exercise_id', exerciseId)
        .order('done_at')
        .limit(500);
    return [
      for (final r in rows)
        DatedSet(DateTime.parse((r['workout_logs'] as Map<String, dynamic>)['day'] as String), SetLog.fromJson(r)),
    ];
  });

  @override
  Future<SaveLogResult> saveLog(Map<String, dynamic> payload) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('save_workout_log', params: {'p': payload});
    return SaveLogResult.fromJson(res);
  });

  @override
  Future<void> comment(String logId, {String? body, String? emoji}) =>
      _guard(() => _db.rpc<String>('comment_workout', params: {'p_log_id': logId, 'p_body': body, 'p_emoji': emoji}));

  @override
  Future<Paged<CoachRow>> coachOverview({String? trainerId, String search = '', int offset = 0}) => _guard(() async {
    final rows = await _db.rpc<List<dynamic>>(
      'coach_overview',
      params: {'p_trainer_id': trainerId, 'p_search': search.trim(), 'p_offset': offset, 'p_limit': kPageSize},
    );
    final items = rows.cast<Map<String, dynamic>>().map(CoachRow.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });
}

@Riverpod(keepAlive: true)
WorkoutsRepository workoutsRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabaseWorkoutsRepository(client);
}

/// Finished workouts waiting to be uploaded (the one offline-write
/// exception in the spec: logs are personal and non-financial). Each entry is
/// a `save_workout_log` payload keyed by its client id, so re-sending is safe.
class WorkoutOutbox {
  WorkoutOutbox(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'workout_outbox_v1';

  List<Map<String, dynamic>> pending() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _write(List<Map<String, dynamic>> items) => _prefs.setString(_key, jsonEncode(items));

  Future<void> put(Map<String, dynamic> payload) async {
    final items = pending()..removeWhere((p) => p['client_id'] == payload['client_id']);
    await _write([...items, payload]);
  }

  Future<void> remove(String clientId) async {
    await _write(pending()..removeWhere((p) => p['client_id'] == clientId));
  }

  /// Uploads what it can; returns the results by client id. Stops at the
  /// first network failure (still offline); drops payloads the server refuses
  /// for good (e.g. past the 24 h edit window) so they can't block the queue.
  Future<Map<String, SaveLogResult>> flush(WorkoutsRepository repo) async {
    final out = <String, SaveLogResult>{};
    for (final p in pending()) {
      final id = p['client_id'] as String;
      try {
        out[id] = await repo.saveLog(p);
        await remove(id);
      } on NetworkFailure {
        break;
      } on RuleFailure {
        await remove(id);
      } on NotFoundFailure {
        await remove(id);
      }
    }
    return out;
  }
}

@Riverpod(keepAlive: true)
WorkoutOutbox workoutOutbox(Ref ref) => WorkoutOutbox(ref.watch(sharedPreferencesProvider));

/// The member's programs and recent logs, saved on the phone so the player
/// opens offline (5.6 "works fully offline during a session").
class MyWorkoutCache {
  MyWorkoutCache(this._prefs);

  final SharedPreferences _prefs;
  String _k(String what, String memberId) => 'my_workouts_${what}_$memberId';

  Future<void> savePrograms(String memberId, List<MemberProgram> programs) =>
      _prefs.setString(_k('programs', memberId), jsonEncode([for (final p in programs) p.toJson()]));

  List<MemberProgram>? programs(String memberId) {
    final raw = _prefs.getString(_k('programs', memberId));
    if (raw == null) return null;
    try {
      return [
        for (final j in (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>()) MemberProgram.fromJson(j),
      ];
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLogs(String memberId, List<WorkoutLog> logs) =>
      _prefs.setString(_k('logs', memberId), jsonEncode([for (final l in logs) l.toJson()]));

  List<WorkoutLog>? logs(String memberId) {
    final raw = _prefs.getString(_k('logs', memberId));
    if (raw == null) return null;
    try {
      return [for (final j in (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>()) WorkoutLog.fromJson(j)];
    } catch (_) {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
MyWorkoutCache myWorkoutCache(Ref ref) => MyWorkoutCache(ref.watch(sharedPreferencesProvider));
