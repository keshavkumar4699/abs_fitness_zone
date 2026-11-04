// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dietRepository)
final dietRepositoryProvider = DietRepositoryProvider._();

final class DietRepositoryProvider extends $FunctionalProvider<DietRepository, DietRepository, DietRepository>
    with $Provider<DietRepository> {
  DietRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dietRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietRepositoryHash();

  @$internal
  @override
  $ProviderElement<DietRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DietRepository create(Ref ref) {
    return dietRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DietRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DietRepository>(value));
  }
}

String _$dietRepositoryHash() => r'5ece0d21c84e4f7269705ab099c9b00a17707ccb';

@ProviderFor(dietOutbox)
final dietOutboxProvider = DietOutboxProvider._();

final class DietOutboxProvider extends $FunctionalProvider<DietOutbox, DietOutbox, DietOutbox>
    with $Provider<DietOutbox> {
  DietOutboxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dietOutboxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietOutboxHash();

  @$internal
  @override
  $ProviderElement<DietOutbox> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DietOutbox create(Ref ref) {
    return dietOutbox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DietOutbox value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DietOutbox>(value));
  }
}

String _$dietOutboxHash() => r'cd74ab1f5e254f534435a84f3d1630926aa66563';

@ProviderFor(myDietCache)
final myDietCacheProvider = MyDietCacheProvider._();

final class MyDietCacheProvider extends $FunctionalProvider<MyDietCache, MyDietCache, MyDietCache>
    with $Provider<MyDietCache> {
  MyDietCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myDietCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myDietCacheHash();

  @$internal
  @override
  $ProviderElement<MyDietCache> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MyDietCache create(Ref ref) {
    return myDietCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyDietCache value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MyDietCache>(value));
  }
}

String _$myDietCacheHash() => r'12519a8a42efb51da654a35ceda9cd5571800089';
