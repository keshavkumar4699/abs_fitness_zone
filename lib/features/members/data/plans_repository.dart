import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../domain/models.dart';

part 'plans_repository.g.dart';

/// Membership plans and add-ons catalogue (1.4, 1.5). Owner writes.
abstract interface class PlansRepository {
  Future<List<Plan>> plans({bool includeArchived = false});
  Future<Map<String, int>> activeCountsByPlan();
  Future<void> savePlan(Plan plan, {bool isNew = false});
  Future<void> setPlanArchived(String id, {required bool archived});
  Future<List<Addon>> addons({bool includeArchived = false});
  Future<void> saveAddon(Addon addon, {bool isNew = false});
  Future<void> setAddonArchived(String id, {required bool archived});
}

class SupabasePlansRepository implements PlansRepository {
  SupabasePlansRepository(this._db);

  final SupabaseClient _db;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PostgrestException catch (e) {
      if (e.code == '42501') throw const NotAllowedFailure();
      if (e.code == '23514' || e.code == '22023') throw RuleFailure(e.message);
      throw ServerFailure(e.message);
    } catch (e) {
      if (e is AppFailure) rethrow;
      final t = e.toString();
      if (t.contains('SocketException') || t.contains('ClientException') || e is TimeoutException) {
        throw const NetworkFailure();
      }
      throw ServerFailure(t);
    }
  }

  @override
  Future<List<Plan>> plans({bool includeArchived = false}) => _guard(() async {
    var q = _db.from('plans').select();
    if (!includeArchived) q = q.eq('is_archived', false);
    final rows = await q.order('is_archived').order('price_paise');
    return rows.map(Plan.fromJson).toList();
  });

  @override
  Future<Map<String, int>> activeCountsByPlan() => _guard(() async {
    final rows = await _db.from('memberships').select('plan_id').inFilter('status', ['active', 'expiring', 'frozen']);
    final out = <String, int>{};
    for (final r in rows) {
      final id = r['plan_id'] as String;
      out[id] = (out[id] ?? 0) + 1;
    }
    return out;
  });

  Map<String, dynamic> _planJson(Plan p, bool isNew) {
    final j = p.toJson();
    if (isNew) j.remove('id');
    return j;
  }

  @override
  Future<void> savePlan(Plan plan, {bool isNew = false}) => _guard(() async {
    if (isNew) {
      await _db.from('plans').insert(_planJson(plan, true));
    } else {
      final rows = await _db.from('plans').update(_planJson(plan, false)).eq('id', plan.id).select('id');
      if (rows.isEmpty) throw const NotAllowedFailure();
    }
  });

  @override
  Future<void> setPlanArchived(String id, {required bool archived}) => _guard(() async {
    final rows = await _db.from('plans').update({'is_archived': archived}).eq('id', id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<List<Addon>> addons({bool includeArchived = false}) => _guard(() async {
    var q = _db.from('addons').select();
    if (!includeArchived) q = q.eq('is_archived', false);
    final rows = await q.order('is_archived').order('name');
    return rows.map(Addon.fromJson).toList();
  });

  @override
  Future<void> saveAddon(Addon addon, {bool isNew = false}) => _guard(() async {
    final j = addon.toJson();
    if (isNew) {
      j.remove('id');
      await _db.from('addons').insert(j);
    } else {
      final rows = await _db.from('addons').update(j).eq('id', addon.id).select('id');
      if (rows.isEmpty) throw const NotAllowedFailure();
    }
  });

  @override
  Future<void> setAddonArchived(String id, {required bool archived}) => _guard(() async {
    final rows = await _db.from('addons').update({'is_archived': archived}).eq('id', id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });
}

@Riverpod(keepAlive: true)
PlansRepository plansRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabasePlansRepository(client);
}
