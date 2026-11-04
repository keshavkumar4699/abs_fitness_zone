import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../exercises/data/exercise_repository.dart' show CatalogueStore, FileCatalogueStore, PrefsCatalogueStore;
import '../domain/diet_models.dart';
import '../domain/food.dart';

part 'diet_repository.g.dart';

/// Foods, diet templates, members' plans and their logs (F6). Every write
/// except foods goes through a database RPC that checks the caller's role.
abstract interface class DietRepository {
  /// The whole food database: the saved copy, updated with whatever changed
  /// on the server since (opens offline after the first sync).
  Future<List<Food>> foods();

  /// Creates or updates a food; returns its id.
  Future<String> saveFood(Food food);
  Future<void> markReviewed(String foodId);
  Future<void> archiveFood(String foodId);

  Future<Paged<DietTemplate>> templates({String search = '', int offset = 0});
  Future<DietTemplate> template(String id);
  Future<String> saveTemplate(DietTemplate t);
  Future<void> archiveTemplate(String id);
  Future<int> assign({required String templateId, required List<String> memberIds, DateTime? start});
  Future<void> endDiet(String dietId);

  /// A member's plans, newest first, each with its snapshot and foods.
  Future<List<MemberDiet>> diets(String memberId);

  /// Meals, water and supplements logged since [since].
  Future<DietLogs> logs(String memberId, {required DateTime since});

  /// Marks a meal, or clears it when [status] is null.
  Future<MealLog?> logMeal({required DateTime day, required String slot, String? status, int? alt});
  Future<void> setWater(DateTime day, int glasses);
  Future<void> setSupplement(DateTime day, String name, {required bool taken});

  Future<DietFlags> flags(String memberId);
  Future<List<DietFlags>> flagsFor(List<String> memberIds);
  Future<void> setPreferences(
    String memberId, {
    String? dietPref,
    List<String> allergies = const [],
    List<String> avoid = const [],
  });

  Future<List<DietComment>> comments(String memberId);
  Future<void> comment(String memberId, String body);
  Future<Paged<DietRow>> overview({String? trainerId, String search = '', int offset = 0});
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

bool _isOffline(Object e) {
  final t = e.toString();
  return e is TimeoutException || t.contains('SocketException') || t.contains('ClientException') || e is NetworkFailure;
}

class SupabaseDietRepository implements DietRepository {
  SupabaseDietRepository(this._db, this._store);

  final SupabaseClient _db;
  final CatalogueStore _store;

  static const _full = '*, diet_meals(*, diet_meal_items(*, food:food_id(*)))';

  @override
  Future<List<Food>> foods() async {
    final cached = await _store.read();
    final byId = {for (final r in cached?.rows ?? const <Map<String, dynamic>>[]) r['id'] as String: r};
    try {
      final since = cached?.syncedAt;
      var syncedAt = since ?? DateTime.utc(2000);
      const page = 1000;
      for (var offset = 0; ; offset += page) {
        var q = _db.from('foods').select();
        if (since != null) q = q.gte('updated_at', since.toIso8601String());
        final rows = await q.order('updated_at').order('id').range(offset, offset + page - 1);
        for (final r in rows) {
          byId[r['id'] as String] = r;
          final t = DateTime.parse(r['updated_at'] as String);
          if (t.isAfter(syncedAt)) syncedAt = t;
        }
        if (rows.length < page) break;
      }
      await _store.write(syncedAt, byId.values.toList());
    } catch (e) {
      if (byId.isEmpty) throw _isOffline(e) ? const NetworkFailure() : ServerFailure(e.toString());
    }
    return [for (final r in byId.values) Food.fromJson(r)];
  }

  @override
  Future<String> saveFood(Food food) => _guard(() async {
    final row = food.toRow();
    if (food.id.isEmpty) {
      final saved = await _db.from('foods').insert(row).select('id').single();
      return saved['id'] as String;
    }
    final rows = await _db.from('foods').update(row).eq('id', food.id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
    return food.id;
  });

  @override
  Future<void> markReviewed(String foodId) => _guard(() async {
    final rows = await _db
        .from('foods')
        .update({'reviewed_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', foodId)
        .select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<void> archiveFood(String foodId) => _guard(() async {
    final rows = await _db
        .from('foods')
        .update({'archived_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', foodId)
        .select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<Paged<DietTemplate>> templates({String search = '', int offset = 0}) => _guard(() async {
    var q = _db.from('diet_templates').select(_full).eq('is_gym_template', true).isFilter('archived_at', null);
    final s = sanitizeSearch(search);
    if (s.isNotEmpty) q = q.ilike('name', '%$s%');
    final rows = await q.order('is_starter', ascending: false).order('name').range(offset, offset + kPageSize - 1);
    final items = rows.map(DietTemplate.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<DietTemplate> template(String id) => _guard(() async {
    final row = await _db.from('diet_templates').select(_full).eq('id', id).maybeSingle();
    if (row == null) throw const NotFoundFailure();
    return DietTemplate.fromJson(row);
  });

  @override
  Future<String> saveTemplate(DietTemplate t) =>
      _guard(() => _db.rpc<String>('save_diet_template', params: {'p': t.toPayload()}));

  @override
  Future<void> archiveTemplate(String id) =>
      _guard(() => _db.rpc<void>('archive_diet_template', params: {'p_template_id': id}));

  @override
  Future<int> assign({required String templateId, required List<String> memberIds, DateTime? start}) => _guard(
    () => _db.rpc<int>(
      'assign_diet',
      params: {'p_template_id': templateId, 'p_member_ids': memberIds, 'p_start': dietDate(start)},
    ),
  );

  @override
  Future<void> endDiet(String dietId) => _guard(() => _db.rpc<void>('end_diet', params: {'p_diet_id': dietId}));

  @override
  Future<List<MemberDiet>> diets(String memberId) => _guard(() async {
    final rows = await _db
        .from('member_diets')
        .select('*, template:template_id($_full)')
        .eq('member_id', memberId)
        .neq('status', 'dropped')
        .order('start_date', ascending: false)
        .order('assigned_at', ascending: false)
        .limit(20);
    return rows.map(MemberDiet.fromJson).toList();
  });

  @override
  Future<DietLogs> logs(String memberId, {required DateTime since}) => _guard(() async {
    final from = dietDate(since)!;
    final results = await Future.wait([
      _db.from('meal_logs').select().eq('member_id', memberId).gte('day', from).order('day').limit(1000),
      _db.from('water_logs').select('day, glasses').eq('member_id', memberId).gte('day', from).order('day'),
      _db.from('supplement_logs').select('day, name').eq('member_id', memberId).gte('day', from).order('day'),
    ]);
    return DietLogs(
      meals: results[0].map(MealLog.fromJson).toList(),
      water: results[1].map(WaterLog.fromJson).toList(),
      supplements: results[2].map(SupplementLog.fromJson).toList(),
    );
  });

  @override
  Future<MealLog?> logMeal({required DateTime day, required String slot, String? status, int? alt}) => _guard(() async {
    final res = await _db.rpc<dynamic>(
      'log_meal',
      params: {'p_day': dietDate(day), 'p_slot': slot, 'p_status': status, 'p_alt': alt},
    );
    return res is Map<String, dynamic> ? MealLog.fromJson(res) : null;
  });

  @override
  Future<void> setWater(DateTime day, int glasses) =>
      _guard(() => _db.rpc<int>('set_water', params: {'p_day': dietDate(day), 'p_glasses': glasses}));

  @override
  Future<void> setSupplement(DateTime day, String name, {required bool taken}) =>
      _guard(() => _db.rpc<void>('set_supplement', params: {'p_day': dietDate(day), 'p_name': name, 'p_taken': taken}));

  @override
  Future<DietFlags> flags(String memberId) => _guard(() async {
    final results = await Future.wait([
      _db.from('members').select('id, name, diet_pref').eq('id', memberId).maybeSingle(),
      _db
          .from('member_health')
          .select('conditions, medications, parq, food_allergies, foods_to_avoid')
          .eq('member_id', memberId)
          .maybeSingle(),
    ]);
    final m = results[0], h = results[1];
    if (m == null) throw const NotFoundFailure();
    String? text(Object? v) {
      final s = (v as String?)?.trim();
      return s == null || s.isEmpty ? null : s;
    }

    final conditions = [text(h?['conditions']), text(h?['medications'])].whereType<String>().join('; ');
    final parq = (h?['parq'] as Map<String, dynamic>?) ?? const {};
    return DietFlags(
      memberId: memberId,
      name: m['name'] as String? ?? '',
      dietPref: m['diet_pref'] as String?,
      allergies: ((h?['food_allergies'] as List<dynamic>?) ?? const []).cast<String>(),
      avoid: ((h?['foods_to_avoid'] as List<dynamic>?) ?? const []).cast<String>(),
      conditions: conditions.isEmpty ? null : conditions,
      hasConditions: conditions.isNotEmpty || parq.values.any((v) => v == true),
    );
  });

  @override
  Future<List<DietFlags>> flagsFor(List<String> memberIds) => _guard(() async {
    if (memberIds.isEmpty) return const [];
    final rows = await _db.rpc<List<dynamic>>('diet_member_flags', params: {'p_member_ids': memberIds});
    return rows.cast<Map<String, dynamic>>().map(DietFlags.fromJson).toList();
  });

  @override
  Future<void> setPreferences(
    String memberId, {
    String? dietPref,
    List<String> allergies = const [],
    List<String> avoid = const [],
  }) => _guard(
    () => _db.rpc<void>(
      'set_diet_preferences',
      params: {'p_member_id': memberId, 'p_diet_pref': dietPref, 'p_allergies': allergies, 'p_avoid': avoid},
    ),
  );

  @override
  Future<List<DietComment>> comments(String memberId) => _guard(() async {
    final rows = await _db
        .from('diet_comments')
        .select('id, author_name, body, created_at')
        .eq('member_id', memberId)
        .order('created_at', ascending: false)
        .limit(30);
    return rows.map(DietComment.fromJson).toList();
  });

  @override
  Future<void> comment(String memberId, String body) =>
      _guard(() => _db.rpc<String>('comment_diet', params: {'p_member_id': memberId, 'p_body': body}));

  @override
  Future<Paged<DietRow>> overview({String? trainerId, String search = '', int offset = 0}) => _guard(() async {
    final rows = await _db.rpc<List<dynamic>>(
      'diet_overview',
      params: {'p_trainer_id': trainerId, 'p_search': search.trim(), 'p_offset': offset, 'p_limit': kPageSize},
    );
    final items = rows.cast<Map<String, dynamic>>().map(DietRow.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });
}

@Riverpod(keepAlive: true)
DietRepository dietRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  final prefs = ref.watch(sharedPreferencesProvider);
  return SupabaseDietRepository(
    client,
    kIsWeb ? PrefsCatalogueStore(prefs, 'food_catalogue_v1') : FileCatalogueStore('food_catalogue_v1.json'),
  );
}

/// Meal, water and supplement marks waiting to upload. Marking is a
/// personal, non-financial log like a workout, so it may wait offline (the
/// spec's offline exception). Each entry replaces an older one with the same
/// key (the last tap wins); re-sending is safe because the RPCs upsert.
class DietOutbox {
  DietOutbox(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'diet_outbox_v1';

  static String mealKey(DateTime day, String slot) => 'meal|${dietDate(day)}|$slot';
  static String waterKey(DateTime day) => 'water|${dietDate(day)}';
  static String supplementKey(DateTime day, String name) => 'supp|${dietDate(day)}|$name';

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

  Future<void> put(Map<String, dynamic> op) async {
    final items = pending()..removeWhere((p) => p['key'] == op['key']);
    await _write([...items, op]);
  }

  Future<void> remove(String key) async => _write(pending()..removeWhere((p) => p['key'] == key));

  static Map<String, dynamic> meal(DateTime day, String slot, String? status, int? alt) => {
    'key': mealKey(day, slot),
    'kind': 'meal',
    'day': dietDate(day),
    'slot': slot,
    'status': status,
    'alt': alt,
  };

  static Map<String, dynamic> water(DateTime day, int glasses) => {
    'key': waterKey(day),
    'kind': 'water',
    'day': dietDate(day),
    'glasses': glasses,
  };

  static Map<String, dynamic> supplement(DateTime day, String name, {required bool taken}) => {
    'key': supplementKey(day, name),
    'kind': 'supp',
    'day': dietDate(day),
    'name': name,
    'taken': taken,
  };

  /// Uploads what it can, oldest first; returns the saved meal logs by key.
  /// Stops at the first network failure (still offline) and drops marks the
  /// server refuses for good (too old, plan changed) so they can't block.
  Future<Map<String, MealLog?>> flush(DietRepository repo) async {
    final out = <String, MealLog?>{};
    for (final op in pending()) {
      final key = op['key'] as String;
      final day = DateTime.parse(op['day'] as String);
      final d = DateTime.utc(day.year, day.month, day.day);
      try {
        switch (op['kind']) {
          case 'meal':
            out[key] = await repo.logMeal(
              day: d,
              slot: op['slot'] as String,
              status: op['status'] as String?,
              alt: op['alt'] as int?,
            );
          case 'water':
            await repo.setWater(d, op['glasses'] as int);
          case 'supp':
            await repo.setSupplement(d, op['name'] as String, taken: op['taken'] as bool);
        }
        await remove(key);
      } on NetworkFailure {
        break;
      } on RuleFailure {
        await remove(key);
      } on NotFoundFailure {
        await remove(key);
      } on NotAllowedFailure {
        await remove(key);
      }
    }
    return out;
  }
}

@Riverpod(keepAlive: true)
DietOutbox dietOutbox(Ref ref) => DietOutbox(ref.watch(sharedPreferencesProvider));

/// The member's plans and recent logs, saved on the phone so the Diet tab
/// opens offline.
class MyDietCache {
  MyDietCache(this._prefs);

  final SharedPreferences _prefs;
  String _k(String what, String memberId) => 'my_diet_${what}_$memberId';

  Future<void> saveDiets(String memberId, List<MemberDiet> diets) =>
      _prefs.setString(_k('plans', memberId), jsonEncode([for (final d in diets) d.toJson()]));

  List<MemberDiet>? diets(String memberId) {
    final raw = _prefs.getString(_k('plans', memberId));
    if (raw == null) return null;
    try {
      return [for (final j in (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>()) MemberDiet.fromJson(j)];
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLogs(String memberId, DietLogs logs) =>
      _prefs.setString(_k('logs', memberId), jsonEncode(logs.toJson()));

  DietLogs? logs(String memberId) {
    final raw = _prefs.getString(_k('logs', memberId));
    if (raw == null) return null;
    try {
      return DietLogs.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
MyDietCache myDietCache(Ref ref) => MyDietCache(ref.watch(sharedPreferencesProvider));
