import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../domain/whatsapp_models.dart';

part 'whatsapp_repository.g.dart';

/// WhatsApp (F8): the send queue, the message log, templates, festivals,
/// broadcasts and settings. Writes go through RPCs that check the caller's
/// role; templates, festivals and settings are owner-only tables.
abstract interface class WhatsAppRepository {
  Future<WhatsAppSettings> settings();
  Future<void> saveSettings(WhatsAppSettings s);

  /// Free-mode messages still to send, up to the end of [day] (IST).
  Future<Paged<QueuedMessage>> queue({required DateTime day, int offset = 0});

  /// Every message, newest first; for one member when [memberId] is set.
  Future<Paged<QueuedMessage>> log({String? memberId, Set<MessageStatus> statuses = const {}, int offset = 0});

  Future<QueueSummary> summary({required DateTime day});

  /// Marks a free-mode message sent or skipped, or back to queued (undo).
  Future<void> mark(String id, MessageStatus status);

  /// Builds today's reminders now (the 07:30 job does it every morning).
  Future<Map<String, int>> buildToday();

  /// API mode: send what is due now instead of waiting for the next run.
  Future<void> sendNow();

  /// Records a message staff sent by hand from a wa.me link. When a queued
  /// message for the same purpose is waiting (its key starts with
  /// [replaces]), that one is ticked as sent instead, so the member never
  /// gets it twice.
  Future<void> logManual({required String memberId, required String body, String? replaces});

  Future<void> setOptOut({required String memberId, required bool optOut});

  Future<List<MessageTemplate>> templates();
  Future<void> saveTemplate(MessageTemplate t);

  Future<List<Festival>> festivals();
  Future<void> saveFestival(Festival f);
  Future<void> deleteFestival(String id);

  Future<SegmentCount> segmentCount(Segment s);
  Future<BroadcastResult> broadcast({
    required String title,
    required String body,
    required MessageCategory category,
    required Segment segment,
    DateTime? scheduledFor,
  });
  Future<Paged<Broadcast>> broadcasts({int offset = 0});

  Future<WhatsAppCost> costThisMonth();
}

Never _rethrow(Object e) {
  if (e is AppFailure) throw e;
  if (e is PostgrestException) {
    switch (e.code) {
      case '42501':
        throw const NotAllowedFailure();
      case 'P0002':
        throw const NotFoundFailure();
      case '22023' || '23514' || '23505':
        throw RuleFailure(e.message);
    }
    throw ServerFailure(e.message);
  }
  if (e is FunctionException) throw ServerFailure('${e.status}');
  final t = e.toString();
  if (t.contains('SocketException') || t.contains('ClientException') || e is TimeoutException) {
    throw const NetworkFailure();
  }
  throw ServerFailure(t);
}

Future<T> _guard<T>(Future<T> Function() run) async {
  try {
    return await run();
  } catch (e) {
    _rethrow(e);
  }
}

/// The end of an IST day as an instant.
DateTime endOfIstDay(DateTime day) => DateTime.utc(day.year, day.month, day.day + 1).subtract(IstDates.offset);

class SupabaseWhatsAppRepository implements WhatsAppRepository {
  SupabaseWhatsAppRepository(this._db);

  final SupabaseClient _db;

  static const _row = '*, member:member_id(name, phone, photo_url)';

  @override
  Future<WhatsAppSettings> settings() => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>?>('whatsapp_settings');
    if (res == null) throw const NotAllowedFailure();
    return WhatsAppSettings.fromJson(res);
  });

  @override
  Future<void> saveSettings(WhatsAppSettings s) => _guard(() async {
    final rows = [
      for (final e in s.toSettings().entries) {'key': e.key, 'value': e.value},
    ];
    final saved = await _db.from('settings').upsert(rows).select('key');
    if (saved.length != rows.length) throw const NotAllowedFailure();
  });

  @override
  Future<Paged<QueuedMessage>> queue({required DateTime day, int offset = 0}) => _guard(() async {
    final rows = await _db
        .from('message_queue')
        .select(_row)
        .eq('channel', 'link')
        .eq('status', 'queued')
        .lte('scheduled_for', endOfIstDay(day).toIso8601String())
        .order('scheduled_for')
        .order('created_at')
        .range(offset, offset + kPageSize - 1);
    final items = rows.map(QueuedMessage.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<Paged<QueuedMessage>> log({String? memberId, Set<MessageStatus> statuses = const {}, int offset = 0}) =>
      _guard(() async {
        var q = _db.from('message_queue').select(_row);
        if (memberId != null) q = q.eq('member_id', memberId);
        if (statuses.isNotEmpty) q = q.inFilter('status', [for (final s in statuses) s.name]);
        final rows = await q.order('created_at', ascending: false).order('id').range(offset, offset + kPageSize - 1);
        final items = rows.map(QueuedMessage.fromJson).toList();
        return Paged(items, hasMore: items.length == kPageSize);
      });

  @override
  Future<QueueSummary> summary({required DateTime day}) => _guard(() async {
    final end = endOfIstDay(day).toIso8601String();
    final start = DateTime.utc(day.year, day.month, day.day).subtract(IstDates.offset).toIso8601String();
    final toSend = await _db
        .from('message_queue')
        .select('id')
        .eq('channel', 'link')
        .eq('status', 'queued')
        .lte('scheduled_for', end)
        .count(CountOption.exact);
    final sent = await _db
        .from('message_queue')
        .select('id')
        .inFilter('status', ['sent', 'delivered', 'read'])
        .gte('sent_at', start)
        .lte('sent_at', end)
        .count(CountOption.exact);
    final failed = await _db
        .from('message_queue')
        .select('id')
        .eq('status', 'failed')
        .gte('updated_at', start)
        .count(CountOption.exact);
    return QueueSummary(toSend: toSend.count, sentToday: sent.count, failed: failed.count);
  });

  @override
  Future<void> mark(String id, MessageStatus status) =>
      _guard(() => _db.rpc<void>('mark_message', params: {'p_id': id, 'p_status': status.name}));

  @override
  Future<Map<String, int>> buildToday() => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('build_message_queue');
    return {
      for (final e in res.entries)
        if (e.value is num) e.key: (e.value as num).toInt(),
    };
  });

  @override
  Future<void> sendNow() => _guard(() async {
    await _db.functions.invoke('whatsapp-send', body: const {'limit': 50});
  });

  @override
  Future<void> logManual({required String memberId, required String body, String? replaces}) => _guard(() async {
    if (replaces != null) {
      final waiting = await _db
          .from('message_queue')
          .select('id')
          .eq('member_id', memberId)
          .eq('channel', 'link')
          .eq('status', 'queued')
          .like('template_key', '$replaces%')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (waiting != null) {
        await _db.rpc<void>('mark_message', params: {'p_id': waiting['id'], 'p_status': 'sent'});
        return;
      }
    }
    await _db.rpc<String>('log_manual_message', params: {'p_member_id': memberId, 'p_body': body});
  });

  @override
  Future<void> setOptOut({required String memberId, required bool optOut}) =>
      _guard(() => _db.rpc<void>('set_whatsapp_opt_out', params: {'p_opt_out': optOut, 'p_member_id': memberId}));

  @override
  Future<List<MessageTemplate>> templates() => _guard(() async {
    // A fixed, small set (12 messages × 2 languages): loaded whole.
    final rows = await _db.from('message_templates').select().order('is_system', ascending: false).order('key');
    return rows.map(MessageTemplate.fromJson).toList();
  });

  @override
  Future<void> saveTemplate(MessageTemplate t) => _guard(() async {
    final row = {
      'title': t.title.trim(),
      'body': t.body.trim(),
      'meta_template_name': (t.metaTemplateName?.trim().isEmpty ?? true) ? null : t.metaTemplateName!.trim(),
      'is_enabled': t.isEnabled,
    };
    if (t.id.isEmpty) {
      await _db.from('message_templates').insert({
        ...row,
        'key': t.key,
        'language': t.language,
        'category': t.category.wire,
      });
      return;
    }
    final rows = await _db.from('message_templates').update(row).eq('id', t.id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<List<Festival>> festivals() => _guard(() async {
    // One year of festivals (about a dozen): loaded whole, upcoming first.
    final from = IstDates.today().subtract(const Duration(days: 30));
    final rows = await _db
        .from('festivals')
        .select()
        .gte('day', from.toIso8601String().substring(0, 10))
        .order('day')
        .limit(200);
    return rows.map(Festival.fromJson).toList();
  });

  @override
  Future<void> saveFestival(Festival f) => _guard(() async {
    final row = f.toJson()
      ..remove('id')
      ..['message'] = (f.message?.trim().isEmpty ?? true) ? null : f.message!.trim()
      ..['local_name'] = (f.localName?.trim().isEmpty ?? true) ? null : f.localName!.trim()
      ..['name'] = f.name.trim();
    if (f.id.isEmpty) {
      await _db.from('festivals').insert(row);
      return;
    }
    final rows = await _db.from('festivals').update(row).eq('id', f.id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<void> deleteFestival(String id) => _guard(() async {
    final rows = await _db.from('festivals').delete().eq('id', id).select('id');
    if (rows.isEmpty) throw const NotAllowedFailure();
  });

  @override
  Future<SegmentCount> segmentCount(Segment s) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('segment_count', params: {'p_segment': s.toJson()});
    return SegmentCount(total: (res['total'] as num).toInt(), reachable: (res['reachable'] as num).toInt());
  });

  @override
  Future<BroadcastResult> broadcast({
    required String title,
    required String body,
    required MessageCategory category,
    required Segment segment,
    DateTime? scheduledFor,
  }) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>(
      'create_broadcast',
      params: {
        'p_title': title.trim(),
        'p_body': body.trim(),
        'p_category': category.wire,
        'p_segment': segment.toJson(),
        'p_scheduled': scheduledFor?.toUtc().toIso8601String(),
      },
    );
    return BroadcastResult(queued: (res['queued'] as num).toInt(), skipped: (res['skipped'] as num).toInt());
  });

  @override
  Future<Paged<Broadcast>> broadcasts({int offset = 0}) => _guard(() async {
    final rows = await _db
        .from('broadcasts')
        .select()
        .order('created_at', ascending: false)
        .range(offset, offset + kPageSize - 1);
    final items = rows.map(Broadcast.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<WhatsAppCost> costThisMonth() => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('whatsapp_cost_month');
    return WhatsAppCost.fromJson(res);
  });
}

@Riverpod(keepAlive: true)
WhatsAppRepository whatsAppRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabaseWhatsAppRepository(client);
}
