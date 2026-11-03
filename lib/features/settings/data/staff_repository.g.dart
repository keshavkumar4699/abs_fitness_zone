// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(staffRepository)
final staffRepositoryProvider = StaffRepositoryProvider._();

final class StaffRepositoryProvider extends $FunctionalProvider<StaffRepository, StaffRepository, StaffRepository>
    with $Provider<StaffRepository> {
  StaffRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffRepositoryHash();

  @$internal
  @override
  $ProviderElement<StaffRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  StaffRepository create(Ref ref) {
    return staffRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<StaffRepository>(value));
  }
}

String _$staffRepositoryHash() => r'6ba4a0bdb060c644b6a7d4881698ab60bd3b1a4d';
