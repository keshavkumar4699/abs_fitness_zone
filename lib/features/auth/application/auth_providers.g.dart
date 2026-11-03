// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'929e03d39375a9819544b38870674f98f476fb76';

/// The signed-in user; null when signed out.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// The signed-in user; null when signed out.

final class CurrentUserProvider
    extends
        $FunctionalProvider<AsyncValue<AppUser?>, AppUser?, Stream<AppUser?>>
    with $FutureModifier<AppUser?>, $StreamProvider<AppUser?> {
  /// The signed-in user; null when signed out.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $StreamProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppUser?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'96047df0b13bf2e98121677d225fb59b376ad7f3';

/// Why the last Google sign-in was refused (not registered, switched off…).

@ProviderFor(signInError)
final signInErrorProvider = SignInErrorProvider._();

/// Why the last Google sign-in was refused (not registered, switched off…).

final class SignInErrorProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppFailure?>,
          AppFailure?,
          Stream<AppFailure?>
        >
    with $FutureModifier<AppFailure?>, $StreamProvider<AppFailure?> {
  /// Why the last Google sign-in was refused (not registered, switched off…).
  SignInErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInErrorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInErrorHash();

  @$internal
  @override
  $StreamProviderElement<AppFailure?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AppFailure?> create(Ref ref) {
    return signInError(ref);
  }
}

String _$signInErrorHash() => r'40e1da1ee884c272fb78304eccdc73e5149a043a';
