import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/dates.dart';
import 'env.dart';

/// Overridden in main() with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

final envProvider = Provider<Env>((ref) => const Env.fromDefines());

/// Null when the build has no backend configured.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  return ref.watch(envProvider).isConfigured ? Supabase.instance.client : null;
});

/// Riverpod 3 retries failed providers automatically by default. The spec
/// wants failures shown as "message + Try again", so automatic retry is off
/// and screens retry explicitly.
Duration? noAutoRetry(int retryCount, Object error) => null;

/// Current time, injectable so tests (and screenshots) are deterministic.
final clockProvider = Provider<DateTime Function()>((ref) => IstDates.clock);
