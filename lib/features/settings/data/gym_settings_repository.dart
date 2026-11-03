import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';

part 'gym_settings_repository.g.dart';

/// Gym profile and rules from the owner-only `settings` table.
class GymSettings {
  const GymSettings(this.values);

  final Map<String, Object?> values;

  String text(String key) => (values[key] as String?) ?? '';
  int number(String key, int fallback) => (values[key] as num?)?.toInt() ?? fallback;

  String get gymName => text('gym_name');
  String get upiId => text('upi_id');
  int get expiringWindowDays => number('expiring_window_days', 7);
  int get absentDays => number('absent_days', 7);
  String get lapsedRenewFrom => values['lapsed_renew_from'] as String? ?? 'today';
}

abstract interface class GymSettingsRepository {
  Future<GymSettings> load();
  Future<void> save(Map<String, Object?> changes);
}

class SupabaseGymSettingsRepository implements GymSettingsRepository {
  SupabaseGymSettingsRepository(this._db);

  final SupabaseClient _db;

  /// Keys the app edits (the check-in secret is never sent to the app).
  static const editable = [
    'gym_name',
    'gym_phone',
    'gym_address',
    'upi_id',
    'gstin',
    'expiring_window_days',
    'absent_days',
    'lapsed_renew_from',
  ];

  @override
  Future<GymSettings> load() async {
    try {
      final rows = await _db.from('settings').select('key, value').inFilter('key', editable);
      return GymSettings({for (final r in rows) r['key'] as String: r['value']});
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      if (e is TimeoutException || e.toString().contains('SocketException')) throw const NetworkFailure();
      rethrow;
    }
  }

  @override
  Future<void> save(Map<String, Object?> changes) async {
    try {
      final rows = [
        for (final e in changes.entries)
          if (editable.contains(e.key)) {'key': e.key, 'value': e.value},
      ];
      final saved = await _db.from('settings').upsert(rows).select('key');
      if (saved.length != rows.length) throw const NotAllowedFailure();
    } on PostgrestException catch (e) {
      if (e.code == '42501') throw const NotAllowedFailure();
      throw ServerFailure(e.message);
    }
  }
}

@Riverpod(keepAlive: true)
GymSettingsRepository gymSettingsRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabaseGymSettingsRepository(client);
}

@riverpod
Future<GymSettings> gymSettings(Ref ref) => ref.watch(gymSettingsRepositoryProvider).load();

/// Gym name / phone / address / UPI ID / hours that every signed-in user may
/// read (through the `public_gym_profile` RPC). Falls back to the brand name.
@riverpod
Future<Map<String, dynamic>> publicGymProfile(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const {'gym_name': 'ABS Fitness Zone'};
  try {
    final res = await client.rpc<Map<String, dynamic>>('public_gym_profile');
    return {'gym_name': 'ABS Fitness Zone', ...res}..removeWhere((k, v) => v == null);
  } catch (_) {
    return const {'gym_name': 'ABS Fitness Zone'};
  }
}
