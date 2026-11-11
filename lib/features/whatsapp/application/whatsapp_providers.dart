import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/paging.dart';
import '../../../core/services/contact_links.dart';
import '../../../core/utils/dates.dart';
import '../data/whatsapp_repository.dart';
import '../domain/whatsapp_models.dart';

part 'whatsapp_providers.g.dart';

@riverpod
Future<WhatsAppSettings> whatsAppSettings(Ref ref) => ref.watch(whatsAppRepositoryProvider).settings();

/// Today's free-mode queue (8.9). Sent and skipped rows stay on screen,
/// ticked, until the next refresh.
@riverpod
class SendQueue extends _$SendQueue {
  DateTime get _day => IstDates.today(now: ref.read(clockProvider)());

  Future<Paged<QueuedMessage>> _page(int offset) =>
      ref.read(whatsAppRepositoryProvider).queue(day: _day, offset: offset);

  @override
  Future<Paged<QueuedMessage>> build() {
    ref.watch(whatsAppRepositoryProvider);
    return _page(0);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      // Rows ticked here have left the server's list, so they don't count.
      final open = current.items.where((m) => m.status == MessageStatus.queued).length;
      final next = await _page(open);
      final known = {for (final m in current.items) m.id};
      state = AsyncData(
        Paged([...current.items, ...next.items.where((m) => !known.contains(m.id))], hasMore: next.hasMore),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  void _set(String id, MessageStatus status) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(items: [for (final m in current.items) m.id == id ? m.copyWith(status: status) : m]),
    );
  }

  /// Ticks the row at once and rolls it back if the server refuses (spec:
  /// optimistic UI with rollback).
  Future<void> mark(QueuedMessage m, MessageStatus status) async {
    _set(m.id, status);
    try {
      await ref.read(whatsAppRepositoryProvider).mark(m.id, status);
      ref.invalidate(queueSummaryProvider);
    } catch (_) {
      _set(m.id, m.status);
      rethrow;
    }
  }
}

/// Which log rows to show.
enum LogFilter {
  all({}),
  queued({MessageStatus.queued, MessageStatus.sending}),
  sent({MessageStatus.sent, MessageStatus.delivered, MessageStatus.read}),

  /// Could not be sent (moved from the API, a refused number): any status.
  problems({}, errorsOnly: true),
  skipped({MessageStatus.skipped, MessageStatus.cancelled});

  const LogFilter(this.statuses, {this.errorsOnly = false});

  final Set<MessageStatus> statuses;
  final bool errorsOnly;
}

/// The message log (8.13), gym-wide or for one member.
@riverpod
class MessageLog extends _$MessageLog {
  Future<Paged<QueuedMessage>> _page(int offset) => ref
      .read(whatsAppRepositoryProvider)
      .log(memberId: memberId, statuses: filter.statuses, errorsOnly: filter.errorsOnly, offset: offset);

  @override
  Future<Paged<QueuedMessage>> build(String? memberId, LogFilter filter) {
    ref.watch(whatsAppRepositoryProvider);
    return _page(0);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await _page(current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

@riverpod
Future<QueueSummary> queueSummary(Ref ref) =>
    ref.watch(whatsAppRepositoryProvider).summary(day: IstDates.today(now: ref.watch(clockProvider)()));

@riverpod
Future<List<MessageTemplate>> messageTemplates(Ref ref) => ref.watch(whatsAppRepositoryProvider).templates();

@riverpod
Future<List<Festival>> festivals(Ref ref) => ref.watch(whatsAppRepositoryProvider).festivals();

@riverpod
Future<SegmentCount> segmentCount(Ref ref, Segment segment) =>
    ref.watch(whatsAppRepositoryProvider).segmentCount(segment);

@riverpod
Future<WhatsAppCost> whatsAppCost(Ref ref) => ref.watch(whatsAppRepositoryProvider).costThisMonth();

@riverpod
class BroadcastList extends _$BroadcastList {
  @override
  Future<Paged<Broadcast>> build() => ref.watch(whatsAppRepositoryProvider).broadcasts();

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref.read(whatsAppRepositoryProvider).broadcasts(offset: current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

/// Opens WhatsApp with a pre-filled message (tests replace it).
typedef WhatsAppLauncher = Future<bool> Function(String phone, String text);

final whatsAppLauncherProvider = Provider<WhatsAppLauncher>(
  (ref) =>
      (phone, text) => ContactLinks.openWhatsApp(phone, text: text),
);

extension WhatsAppRefresh on WidgetRef {
  void refreshWhatsApp() {
    invalidate(sendQueueProvider);
    invalidate(messageLogProvider);
    invalidate(queueSummaryProvider);
    invalidate(broadcastListProvider);
    invalidate(whatsAppCostProvider);
  }

  /// Opens WhatsApp with [text] for [phone] and, when it opened, records the
  /// message in the member's log (8.13). Logging never blocks or fails the
  /// send: the message is already on its way.
  ///
  /// [replaces] names the queued message this one stands in for (a key
  /// prefix such as `payment_received` or `dues_reminder`).
  Future<bool> sendWhatsApp({
    required String? memberId,
    required String phone,
    required String text,
    String? replaces,
  }) async {
    final launch = read(whatsAppLauncherProvider);
    final log = read(manualLogProvider);
    final opened = await launch(phone, text);
    if (opened && memberId != null && text.trim().isNotEmpty) log.record(memberId, text, replaces: replaces);
    return opened;
  }
}

/// Writes hand-sent messages to the log in the background. Lives as long as
/// the app, so a screen closing mid-write doesn't matter.
class ManualLog {
  ManualLog(this._ref);

  final Ref _ref;

  void record(String memberId, String body, {String? replaces}) {
    unawaited(
      Future(() async {
        try {
          await _ref.read(whatsAppRepositoryProvider).logManual(memberId: memberId, body: body, replaces: replaces);
          _ref
            ..invalidate(messageLogProvider)
            ..invalidate(sendQueueProvider)
            ..invalidate(queueSummaryProvider);
        } catch (_) {
          // Offline or not allowed: the message itself was still sent.
        }
      }),
    );
  }
}

@Riverpod(keepAlive: true)
ManualLog manualLog(Ref ref) => ManualLog(ref);
