// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whatsapp_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(whatsAppSettings)
final whatsAppSettingsProvider = WhatsAppSettingsProvider._();

final class WhatsAppSettingsProvider
    extends $FunctionalProvider<AsyncValue<WhatsAppSettings>, WhatsAppSettings, FutureOr<WhatsAppSettings>>
    with $FutureModifier<WhatsAppSettings>, $FutureProvider<WhatsAppSettings> {
  WhatsAppSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'whatsAppSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$whatsAppSettingsHash();

  @$internal
  @override
  $FutureProviderElement<WhatsAppSettings> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<WhatsAppSettings> create(Ref ref) {
    return whatsAppSettings(ref);
  }
}

String _$whatsAppSettingsHash() => r'12654daf61059b6cfbd185fb09fad16691c65a3d';

/// Today's free-mode queue (8.9). Sent and skipped rows stay on screen,
/// ticked, until the next refresh.

@ProviderFor(SendQueue)
final sendQueueProvider = SendQueueProvider._();

/// Today's free-mode queue (8.9). Sent and skipped rows stay on screen,
/// ticked, until the next refresh.
final class SendQueueProvider extends $AsyncNotifierProvider<SendQueue, Paged<QueuedMessage>> {
  /// Today's free-mode queue (8.9). Sent and skipped rows stay on screen,
  /// ticked, until the next refresh.
  SendQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendQueueHash();

  @$internal
  @override
  SendQueue create() => SendQueue();
}

String _$sendQueueHash() => r'510addff779722e9b9c9fb278d2ef86d89ce9088';

/// Today's free-mode queue (8.9). Sent and skipped rows stay on screen,
/// ticked, until the next refresh.

abstract class _$SendQueue extends $AsyncNotifier<Paged<QueuedMessage>> {
  FutureOr<Paged<QueuedMessage>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<QueuedMessage>>, Paged<QueuedMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<QueuedMessage>>, Paged<QueuedMessage>>,
              AsyncValue<Paged<QueuedMessage>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The message log (8.13), gym-wide or for one member.

@ProviderFor(MessageLog)
final messageLogProvider = MessageLogFamily._();

/// The message log (8.13), gym-wide or for one member.
final class MessageLogProvider extends $AsyncNotifierProvider<MessageLog, Paged<QueuedMessage>> {
  /// The message log (8.13), gym-wide or for one member.
  MessageLogProvider._({required MessageLogFamily super.from, required (String?, LogFilter) super.argument})
    : super(
        retry: null,
        name: r'messageLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageLogHash();

  @override
  String toString() {
    return r'messageLogProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MessageLog create() => MessageLog();

  @override
  bool operator ==(Object other) {
    return other is MessageLogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageLogHash() => r'74934eb732e4f7a04ba5ec7bc66fb42459372146';

/// The message log (8.13), gym-wide or for one member.

final class MessageLogFamily extends $Family
    with
        $ClassFamilyOverride<
          MessageLog,
          AsyncValue<Paged<QueuedMessage>>,
          Paged<QueuedMessage>,
          FutureOr<Paged<QueuedMessage>>,
          (String?, LogFilter)
        > {
  MessageLogFamily._()
    : super(
        retry: null,
        name: r'messageLogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The message log (8.13), gym-wide or for one member.

  MessageLogProvider call(String? memberId, LogFilter filter) =>
      MessageLogProvider._(argument: (memberId, filter), from: this);

  @override
  String toString() => r'messageLogProvider';
}

/// The message log (8.13), gym-wide or for one member.

abstract class _$MessageLog extends $AsyncNotifier<Paged<QueuedMessage>> {
  late final _$args = ref.$arg as (String?, LogFilter);
  String? get memberId => _$args.$1;
  LogFilter get filter => _$args.$2;

  FutureOr<Paged<QueuedMessage>> build(String? memberId, LogFilter filter);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<QueuedMessage>>, Paged<QueuedMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<QueuedMessage>>, Paged<QueuedMessage>>,
              AsyncValue<Paged<QueuedMessage>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

@ProviderFor(queueSummary)
final queueSummaryProvider = QueueSummaryProvider._();

final class QueueSummaryProvider
    extends $FunctionalProvider<AsyncValue<QueueSummary>, QueueSummary, FutureOr<QueueSummary>>
    with $FutureModifier<QueueSummary>, $FutureProvider<QueueSummary> {
  QueueSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueSummaryHash();

  @$internal
  @override
  $FutureProviderElement<QueueSummary> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<QueueSummary> create(Ref ref) {
    return queueSummary(ref);
  }
}

String _$queueSummaryHash() => r'bed027356404d4a2edeb5f88a1b4834ffefd3e38';

@ProviderFor(messageTemplates)
final messageTemplatesProvider = MessageTemplatesProvider._();

final class MessageTemplatesProvider
    extends
        $FunctionalProvider<AsyncValue<List<MessageTemplate>>, List<MessageTemplate>, FutureOr<List<MessageTemplate>>>
    with $FutureModifier<List<MessageTemplate>>, $FutureProvider<List<MessageTemplate>> {
  MessageTemplatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messageTemplatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageTemplatesHash();

  @$internal
  @override
  $FutureProviderElement<List<MessageTemplate>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<MessageTemplate>> create(Ref ref) {
    return messageTemplates(ref);
  }
}

String _$messageTemplatesHash() => r'1d23e963bd0750a6947e98e10697db784f12b6c0';

@ProviderFor(festivals)
final festivalsProvider = FestivalsProvider._();

final class FestivalsProvider
    extends $FunctionalProvider<AsyncValue<List<Festival>>, List<Festival>, FutureOr<List<Festival>>>
    with $FutureModifier<List<Festival>>, $FutureProvider<List<Festival>> {
  FestivalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'festivalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$festivalsHash();

  @$internal
  @override
  $FutureProviderElement<List<Festival>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Festival>> create(Ref ref) {
    return festivals(ref);
  }
}

String _$festivalsHash() => r'69715d707a2606adeb5b7c9e5dca896c641ffcfa';

@ProviderFor(segmentCount)
final segmentCountProvider = SegmentCountFamily._();

final class SegmentCountProvider
    extends $FunctionalProvider<AsyncValue<SegmentCount>, SegmentCount, FutureOr<SegmentCount>>
    with $FutureModifier<SegmentCount>, $FutureProvider<SegmentCount> {
  SegmentCountProvider._({required SegmentCountFamily super.from, required Segment super.argument})
    : super(
        retry: null,
        name: r'segmentCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$segmentCountHash();

  @override
  String toString() {
    return r'segmentCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SegmentCount> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<SegmentCount> create(Ref ref) {
    final argument = this.argument as Segment;
    return segmentCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SegmentCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$segmentCountHash() => r'07892ef619f2923130d93cacd84dce23620ee53a';

final class SegmentCountFamily extends $Family with $FunctionalFamilyOverride<FutureOr<SegmentCount>, Segment> {
  SegmentCountFamily._()
    : super(
        retry: null,
        name: r'segmentCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SegmentCountProvider call(Segment segment) => SegmentCountProvider._(argument: segment, from: this);

  @override
  String toString() => r'segmentCountProvider';
}

@ProviderFor(whatsAppCost)
final whatsAppCostProvider = WhatsAppCostProvider._();

final class WhatsAppCostProvider
    extends $FunctionalProvider<AsyncValue<WhatsAppCost>, WhatsAppCost, FutureOr<WhatsAppCost>>
    with $FutureModifier<WhatsAppCost>, $FutureProvider<WhatsAppCost> {
  WhatsAppCostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'whatsAppCostProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$whatsAppCostHash();

  @$internal
  @override
  $FutureProviderElement<WhatsAppCost> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<WhatsAppCost> create(Ref ref) {
    return whatsAppCost(ref);
  }
}

String _$whatsAppCostHash() => r'bfa348d0e03b023b20ae65467dce1c0fb5d451cb';

@ProviderFor(BroadcastList)
final broadcastListProvider = BroadcastListProvider._();

final class BroadcastListProvider extends $AsyncNotifierProvider<BroadcastList, Paged<Broadcast>> {
  BroadcastListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'broadcastListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$broadcastListHash();

  @$internal
  @override
  BroadcastList create() => BroadcastList();
}

String _$broadcastListHash() => r'3074dc3dc2a42fadf7d3723bcda94d52ebb3c1c2';

abstract class _$BroadcastList extends $AsyncNotifier<Paged<Broadcast>> {
  FutureOr<Paged<Broadcast>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<Broadcast>>, Paged<Broadcast>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<Broadcast>>, Paged<Broadcast>>,
              AsyncValue<Paged<Broadcast>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(manualLog)
final manualLogProvider = ManualLogProvider._();

final class ManualLogProvider extends $FunctionalProvider<ManualLog, ManualLog, ManualLog> with $Provider<ManualLog> {
  ManualLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manualLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manualLogHash();

  @$internal
  @override
  $ProviderElement<ManualLog> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ManualLog create(Ref ref) {
    return manualLog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManualLog value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ManualLog>(value));
  }
}

String _$manualLogHash() => r'cf3cf0854f4f4db157581c737e5897e69340d682';
