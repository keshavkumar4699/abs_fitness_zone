import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null
      ? const UnconfiguredAuthRepository()
      : SupabaseAuthRepository(client, ref.watch(sharedPreferencesProvider));
}

/// The signed-in user; null when signed out.
@Riverpod(keepAlive: true)
Stream<AppUser?> currentUser(Ref ref) => ref.watch(authRepositoryProvider).watchUser();

/// Why the last Google sign-in was refused (not registered, switched off…).
@Riverpod(keepAlive: true)
Stream<AppFailure?> signInError(Ref ref) => ref.watch(authRepositoryProvider).watchSignInError();
