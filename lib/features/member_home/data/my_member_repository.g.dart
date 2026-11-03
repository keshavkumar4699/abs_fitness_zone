// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_member_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in member's own record (RLS limits the read to their row).

@ProviderFor(myMember)
final myMemberProvider = MyMemberProvider._();

/// The signed-in member's own record (RLS limits the read to their row).

final class MyMemberProvider
    extends
        $FunctionalProvider<
          AsyncValue<MyMember?>,
          MyMember?,
          FutureOr<MyMember?>
        >
    with $FutureModifier<MyMember?>, $FutureProvider<MyMember?> {
  /// The signed-in member's own record (RLS limits the read to their row).
  MyMemberProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myMemberProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myMemberHash();

  @$internal
  @override
  $FutureProviderElement<MyMember?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MyMember?> create(Ref ref) {
    return myMember(ref);
  }
}

String _$myMemberHash() => r'ae281566a4f93bbdbb947dc3d9785ceef31411e1';
