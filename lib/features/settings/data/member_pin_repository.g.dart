// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_pin_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memberPinRepository)
final memberPinRepositoryProvider = MemberPinRepositoryProvider._();

final class MemberPinRepositoryProvider
    extends
        $FunctionalProvider<
          MemberPinRepository,
          MemberPinRepository,
          MemberPinRepository
        >
    with $Provider<MemberPinRepository> {
  MemberPinRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberPinRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberPinRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemberPinRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemberPinRepository create(Ref ref) {
    return memberPinRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemberPinRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemberPinRepository>(value),
    );
  }
}

String _$memberPinRepositoryHash() =>
    r'fe3e9f776bf55d692eae021554fd9e61e37e399c';
