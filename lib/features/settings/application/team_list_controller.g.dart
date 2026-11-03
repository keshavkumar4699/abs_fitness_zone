// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paged, searchable staff roster.

@ProviderFor(TeamList)
final teamListProvider = TeamListFamily._();

/// Paged, searchable staff roster.
final class TeamListProvider
    extends $AsyncNotifierProvider<TeamList, Paged<StaffMember>> {
  /// Paged, searchable staff roster.
  TeamListProvider._({
    required TeamListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'teamListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$teamListHash();

  @override
  String toString() {
    return r'teamListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TeamList create() => TeamList();

  @override
  bool operator ==(Object other) {
    return other is TeamListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teamListHash() => r'8cec2e75a293f43aea3d9ff48e6bd8ad2467f9b0';

/// Paged, searchable staff roster.

final class TeamListFamily extends $Family
    with
        $ClassFamilyOverride<
          TeamList,
          AsyncValue<Paged<StaffMember>>,
          Paged<StaffMember>,
          FutureOr<Paged<StaffMember>>,
          String
        > {
  TeamListFamily._()
    : super(
        retry: null,
        name: r'teamListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paged, searchable staff roster.

  TeamListProvider call(String query) =>
      TeamListProvider._(argument: query, from: this);

  @override
  String toString() => r'teamListProvider';
}

/// Paged, searchable staff roster.

abstract class _$TeamList extends $AsyncNotifier<Paged<StaffMember>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<Paged<StaffMember>> build(String query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Paged<StaffMember>>, Paged<StaffMember>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<StaffMember>>, Paged<StaffMember>>,
              AsyncValue<Paged<StaffMember>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
