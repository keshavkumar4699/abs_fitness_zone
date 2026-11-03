// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gymSettingsRepository)
final gymSettingsRepositoryProvider = GymSettingsRepositoryProvider._();

final class GymSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          GymSettingsRepository,
          GymSettingsRepository,
          GymSettingsRepository
        >
    with $Provider<GymSettingsRepository> {
  GymSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<GymSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GymSettingsRepository create(Ref ref) {
    return gymSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymSettingsRepository>(value),
    );
  }
}

String _$gymSettingsRepositoryHash() =>
    r'73b991d84decfe08c1142d7631afd54110fabb98';

@ProviderFor(gymSettings)
final gymSettingsProvider = GymSettingsProvider._();

final class GymSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<GymSettings>,
          GymSettings,
          FutureOr<GymSettings>
        >
    with $FutureModifier<GymSettings>, $FutureProvider<GymSettings> {
  GymSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymSettingsHash();

  @$internal
  @override
  $FutureProviderElement<GymSettings> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GymSettings> create(Ref ref) {
    return gymSettings(ref);
  }
}

String _$gymSettingsHash() => r'39f076603140d0d3a6f812b9051bcd6090b0c96b';

/// Gym name / phone / address / UPI ID / hours that every signed-in user may
/// read (through the `public_gym_profile` RPC). Falls back to the brand name.

@ProviderFor(publicGymProfile)
final publicGymProfileProvider = PublicGymProfileProvider._();

/// Gym name / phone / address / UPI ID / hours that every signed-in user may
/// read (through the `public_gym_profile` RPC). Falls back to the brand name.

final class PublicGymProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Gym name / phone / address / UPI ID / hours that every signed-in user may
  /// read (through the `public_gym_profile` RPC). Falls back to the brand name.
  PublicGymProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicGymProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicGymProfileHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return publicGymProfile(ref);
  }
}

String _$publicGymProfileHash() => r'5c896f4ee8c500a2cc46c65cbab0dd6d701616da';
