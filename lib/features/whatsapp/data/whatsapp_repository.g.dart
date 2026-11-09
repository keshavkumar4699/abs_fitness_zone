// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whatsapp_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(whatsAppRepository)
final whatsAppRepositoryProvider = WhatsAppRepositoryProvider._();

final class WhatsAppRepositoryProvider
    extends $FunctionalProvider<WhatsAppRepository, WhatsAppRepository, WhatsAppRepository>
    with $Provider<WhatsAppRepository> {
  WhatsAppRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'whatsAppRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$whatsAppRepositoryHash();

  @$internal
  @override
  $ProviderElement<WhatsAppRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  WhatsAppRepository create(Ref ref) {
    return whatsAppRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WhatsAppRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<WhatsAppRepository>(value));
  }
}

String _$whatsAppRepositoryHash() => r'f024cf6fd805f014649587ace0c9be1fa9883ec5';
