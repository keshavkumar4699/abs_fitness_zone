import 'package:freezed_annotation/freezed_annotation.dart';

part 'whatsapp_models.freezed.dart';
part 'whatsapp_models.g.dart';

DateTime? _date(Object? v) {
  if (v == null || v == '') return null;
  final d = DateTime.parse(v as String);
  return DateTime.utc(d.year, d.month, d.day);
}

DateTime _dateRequired(Object? v) => _date(v)!;

String _dateOut(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Object? _member(Map<dynamic, dynamic> json, String key) => (json['member'] as Map?)?[key] ?? json[key];

/// Free mode sends with a wa.me link from the gym's phone; API mode sends
/// through the Meta Cloud API (8.10). Settings switch between them.
enum WhatsAppMode {
  @JsonValue('link')
  link,
  @JsonValue('api')
  api;

  String get wire => name;
}

enum MessageChannel {
  @JsonValue('link')
  link,
  @JsonValue('api')
  api,
}

/// Meta's two price categories (8.1): utility = reminders and receipts,
/// marketing = wishes and offers.
enum MessageCategory {
  @JsonValue('utility')
  utility,
  @JsonValue('marketing')
  marketing;

  String get wire => name;
}

enum MessageStatus {
  @JsonValue('queued')
  queued,
  @JsonValue('sending')
  sending,
  @JsonValue('sent')
  sent,
  @JsonValue('delivered')
  delivered,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed,
  @JsonValue('skipped')
  skipped,
  @JsonValue('cancelled')
  cancelled;

  bool get isDone => this == sent || this == delivered || this == read;
  bool get isOpen => this == queued || this == sending;
}

/// One row of the queue and the log (8.9, 8.13).
@freezed
abstract class QueuedMessage with _$QueuedMessage {
  const QueuedMessage._();

  const factory QueuedMessage({
    required String id,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'template_key') required String templateKey,
    @Default('en') String language,
    @Default(MessageCategory.utility) MessageCategory category,
    required String body,
    @Default(MessageChannel.link) MessageChannel channel,
    @JsonKey(name: 'scheduled_for') required DateTime scheduledFor,
    @Default(MessageStatus.queued) MessageStatus status,
    @Default('auto') String source,
    String? error,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'free_window') @Default(false) bool freeWindow,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'name', readValue: _member) @Default('') String memberName,
    @JsonKey(name: 'phone', readValue: _member) @Default('') String memberPhone,
    @JsonKey(name: 'photo_url', readValue: _member) String? memberPhoto,
  }) = _QueuedMessage;

  factory QueuedMessage.fromJson(Map<String, dynamic> json) => _$QueuedMessageFromJson(json);

  /// Broadcasts carry a generated key; they read as one kind in the UI.
  String get kind => templateKey.startsWith('broadcast_') ? 'broadcast' : templateKey;
}

@freezed
abstract class MessageTemplate with _$MessageTemplate {
  const factory MessageTemplate({
    @Default('') String id,
    required String key,
    @Default('en') String language,
    @Default(MessageCategory.utility) MessageCategory category,
    required String title,
    required String body,
    @JsonKey(name: 'meta_template_name') String? metaTemplateName,
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
  }) = _MessageTemplate;

  factory MessageTemplate.fromJson(Map<String, dynamic> json) => _$MessageTemplateFromJson(json);
}

/// Who a broadcast or festival goes to (8.8). Mirrors `_segment_members`.
class Segment {
  const Segment(this.kind, {this.trainerId, this.batch, this.memberIds = const []});

  static const all = Segment('all');
  static const kinds = ['all', 'active', 'expiring', 'expired', 'dues', 'trainer', 'batch'];

  final String kind;
  final String? trainerId;
  final String? batch;
  final List<String> memberIds;

  factory Segment.fromJson(Object? json) {
    final m = json is Map ? json : const {};
    return Segment(
      m['kind'] as String? ?? 'all',
      trainerId: m['trainer_id'] as String?,
      batch: m['batch'] as String?,
      memberIds: [...((m['member_ids'] as List?) ?? const []).cast<String>()],
    );
  }

  Map<String, dynamic> toJson() => {
    'kind': kind,
    if (kind == 'trainer' && trainerId != null) 'trainer_id': trainerId,
    if (kind == 'batch' && batch != null) 'batch': batch,
    if (kind == 'members') 'member_ids': memberIds,
  };

  /// Ready to count or send (a trainer or batch segment needs its pick).
  bool get isComplete => switch (kind) {
    'trainer' => trainerId != null,
    'batch' => batch != null,
    'members' => memberIds.isNotEmpty,
    _ => true,
  };

  @override
  bool operator ==(Object other) =>
      other is Segment &&
      other.kind == kind &&
      other.trainerId == trainerId &&
      other.batch == batch &&
      other.memberIds.join(',') == memberIds.join(',');

  @override
  int get hashCode => Object.hash(kind, trainerId, batch, memberIds.join(','));
}

Map<String, dynamic> _segmentOut(Segment s) => s.toJson();

@freezed
abstract class Festival with _$Festival {
  const factory Festival({
    @Default('') String id,
    required String name,
    @JsonKey(name: 'local_name') String? localName,
    @JsonKey(fromJson: _dateRequired, toJson: _dateOut) required DateTime day,
    String? message,
    @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) @Default(Segment.all) Segment segment,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
  }) = _Festival;

  factory Festival.fromJson(Map<String, dynamic> json) => _$FestivalFromJson(json);
}

@freezed
abstract class Broadcast with _$Broadcast {
  const factory Broadcast({
    required String id,
    required String title,
    required String body,
    @Default(MessageCategory.marketing) MessageCategory category,
    @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) @Default(Segment.all) Segment segment,
    @JsonKey(name: 'scheduled_for') required DateTime scheduledFor,
    @Default(0) int queued,
    @Default(0) int skipped,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Broadcast;

  factory Broadcast.fromJson(Map<String, dynamic> json) => _$BroadcastFromJson(json);
}

/// The automations that can be switched off one by one (8.2–8.7).
const kAutomations = ['expiry', 'dues', 'birthday', 'festival', 'payment', 'membership', 'plan'];

/// WhatsApp settings from `whatsapp_settings()` (owner edits them).
class WhatsAppSettings {
  const WhatsAppSettings({
    this.mode = WhatsAppMode.link,
    this.expiryDays = const [7, 3, 0, -3],
    this.dueDays = const [3, 0, -3],
    this.automations = const {},
    this.utilityPer100Paise = 1450,
    this.marketingPer100Paise = 7850,
    this.marketingCapPaise = 20000,
  });

  final WhatsAppMode mode;
  final List<int> expiryDays;
  final List<int> dueDays;
  final Map<String, bool> automations;
  final int utilityPer100Paise;
  final int marketingPer100Paise;
  final int marketingCapPaise;

  bool automation(String key) => automations[key] ?? true;

  factory WhatsAppSettings.fromJson(Map<String, dynamic> j) {
    List<int> ints(Object? v, List<int> fallback) => v is List ? [for (final x in v) (x as num).toInt()] : fallback;
    final prices = (j['prices'] as Map?) ?? const {};
    return WhatsAppSettings(
      mode: j['mode'] == 'api' ? WhatsAppMode.api : WhatsAppMode.link,
      expiryDays: ints(j['expiry_days'], const [7, 3, 0, -3]),
      dueDays: ints(j['due_days'], const [3, 0, -3]),
      automations: {
        for (final e in ((j['automations'] as Map?) ?? const {}).entries)
          if (e.value is bool) e.key as String: e.value as bool,
      },
      utilityPer100Paise: (prices['utility_per_100_paise'] as num?)?.toInt() ?? 1450,
      marketingPer100Paise: (prices['marketing_per_100_paise'] as num?)?.toInt() ?? 7850,
      marketingCapPaise: (j['marketing_cap_paise'] as num?)?.toInt() ?? 0,
    );
  }

  WhatsAppSettings copyWith({
    WhatsAppMode? mode,
    List<int>? expiryDays,
    Map<String, bool>? automations,
    int? utilityPer100Paise,
    int? marketingPer100Paise,
    int? marketingCapPaise,
  }) => WhatsAppSettings(
    mode: mode ?? this.mode,
    expiryDays: expiryDays ?? this.expiryDays,
    dueDays: dueDays,
    automations: automations ?? this.automations,
    utilityPer100Paise: utilityPer100Paise ?? this.utilityPer100Paise,
    marketingPer100Paise: marketingPer100Paise ?? this.marketingPer100Paise,
    marketingCapPaise: marketingCapPaise ?? this.marketingCapPaise,
  );

  /// Rows for the `settings` table.
  Map<String, Object?> toSettings() => {
    'whatsapp_mode': mode.wire,
    'expiry_reminder_days': ([...expiryDays]..sort((a, b) => b.compareTo(a))),
    'whatsapp_automations': {for (final k in kAutomations) k: automation(k)},
    'whatsapp_prices': {'utility_per_100_paise': utilityPer100Paise, 'marketing_per_100_paise': marketingPer100Paise},
    'whatsapp_marketing_cap_paise': marketingCapPaise,
  };
}

/// This month's API sends and estimated spend (8.14).
class WhatsAppCost {
  const WhatsAppCost({
    this.utilitySent = 0,
    this.marketingSent = 0,
    this.freeWindowSent = 0,
    this.linkSent = 0,
    this.utilityPaise = 0,
    this.marketingPaise = 0,
    this.capPaise = 0,
    this.marketingPaused = false,
  });

  final int utilitySent;
  final int marketingSent;
  final int freeWindowSent;
  final int linkSent;
  final int utilityPaise;
  final int marketingPaise;
  final int capPaise;
  final bool marketingPaused;

  int get totalPaise => utilityPaise + marketingPaise;

  factory WhatsAppCost.fromJson(Map<String, dynamic> j) {
    int n(String k) => (j[k] as num?)?.toInt() ?? 0;
    return WhatsAppCost(
      utilitySent: n('utility_sent'),
      marketingSent: n('marketing_sent'),
      freeWindowSent: n('free_window_sent'),
      linkSent: n('link_sent'),
      utilityPaise: n('utility_paise'),
      marketingPaise: n('marketing_paise'),
      capPaise: n('cap_paise'),
      marketingPaused: j['marketing_paused'] == true,
    );
  }
}

/// Today's queue at a glance (staff home card).
class QueueSummary {
  const QueueSummary({this.toSend = 0, this.sentToday = 0, this.failed = 0});

  final int toSend;
  final int sentToday;
  final int failed;
}

/// How many members a segment reaches (opted-out and no-consent are left out).
class SegmentCount {
  const SegmentCount({this.total = 0, this.reachable = 0});

  final int total;
  final int reachable;
}

/// What `create_broadcast` did.
class BroadcastResult {
  const BroadcastResult({required this.queued, required this.skipped});

  final int queued;
  final int skipped;
}
