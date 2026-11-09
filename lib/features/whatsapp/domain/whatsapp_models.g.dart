// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whatsapp_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QueuedMessage _$QueuedMessageFromJson(Map<String, dynamic> json) => _QueuedMessage(
  id: json['id'] as String,
  memberId: json['member_id'] as String,
  templateKey: json['template_key'] as String,
  language: json['language'] as String? ?? 'en',
  category: $enumDecodeNullable(_$MessageCategoryEnumMap, json['category']) ?? MessageCategory.utility,
  body: json['body'] as String,
  channel: $enumDecodeNullable(_$MessageChannelEnumMap, json['channel']) ?? MessageChannel.link,
  scheduledFor: DateTime.parse(json['scheduled_for'] as String),
  status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ?? MessageStatus.queued,
  source: json['source'] as String? ?? 'auto',
  error: json['error'] as String?,
  sentAt: json['sent_at'] == null ? null : DateTime.parse(json['sent_at'] as String),
  deliveredAt: json['delivered_at'] == null ? null : DateTime.parse(json['delivered_at'] as String),
  readAt: json['read_at'] == null ? null : DateTime.parse(json['read_at'] as String),
  freeWindow: json['free_window'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
  memberName: _member(json, 'name') as String? ?? '',
  memberPhone: _member(json, 'phone') as String? ?? '',
  memberPhoto: _member(json, 'photo_url') as String?,
);

Map<String, dynamic> _$QueuedMessageToJson(_QueuedMessage instance) => <String, dynamic>{
  'id': instance.id,
  'member_id': instance.memberId,
  'template_key': instance.templateKey,
  'language': instance.language,
  'category': _$MessageCategoryEnumMap[instance.category]!,
  'body': instance.body,
  'channel': _$MessageChannelEnumMap[instance.channel]!,
  'scheduled_for': instance.scheduledFor.toIso8601String(),
  'status': _$MessageStatusEnumMap[instance.status]!,
  'source': instance.source,
  'error': instance.error,
  'sent_at': instance.sentAt?.toIso8601String(),
  'delivered_at': instance.deliveredAt?.toIso8601String(),
  'read_at': instance.readAt?.toIso8601String(),
  'free_window': instance.freeWindow,
  'created_at': instance.createdAt.toIso8601String(),
  'name': instance.memberName,
  'phone': instance.memberPhone,
  'photo_url': instance.memberPhoto,
};

const _$MessageCategoryEnumMap = {MessageCategory.utility: 'utility', MessageCategory.marketing: 'marketing'};

const _$MessageChannelEnumMap = {MessageChannel.link: 'link', MessageChannel.api: 'api'};

const _$MessageStatusEnumMap = {
  MessageStatus.queued: 'queued',
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
  MessageStatus.skipped: 'skipped',
  MessageStatus.cancelled: 'cancelled',
};

_MessageTemplate _$MessageTemplateFromJson(Map<String, dynamic> json) => _MessageTemplate(
  id: json['id'] as String? ?? '',
  key: json['key'] as String,
  language: json['language'] as String? ?? 'en',
  category: $enumDecodeNullable(_$MessageCategoryEnumMap, json['category']) ?? MessageCategory.utility,
  title: json['title'] as String,
  body: json['body'] as String,
  metaTemplateName: json['meta_template_name'] as String?,
  isSystem: json['is_system'] as bool? ?? false,
  isEnabled: json['is_enabled'] as bool? ?? true,
);

Map<String, dynamic> _$MessageTemplateToJson(_MessageTemplate instance) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'language': instance.language,
  'category': _$MessageCategoryEnumMap[instance.category]!,
  'title': instance.title,
  'body': instance.body,
  'meta_template_name': instance.metaTemplateName,
  'is_system': instance.isSystem,
  'is_enabled': instance.isEnabled,
};

_Festival _$FestivalFromJson(Map<String, dynamic> json) => _Festival(
  id: json['id'] as String? ?? '',
  name: json['name'] as String,
  localName: json['local_name'] as String?,
  day: _dateRequired(json['day']),
  message: json['message'] as String?,
  segment: json['segment'] == null ? Segment.all : Segment.fromJson(json['segment']),
  isEnabled: json['is_enabled'] as bool? ?? true,
);

Map<String, dynamic> _$FestivalToJson(_Festival instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'local_name': instance.localName,
  'day': _dateOut(instance.day),
  'message': instance.message,
  'segment': _segmentOut(instance.segment),
  'is_enabled': instance.isEnabled,
};

_Broadcast _$BroadcastFromJson(Map<String, dynamic> json) => _Broadcast(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  category: $enumDecodeNullable(_$MessageCategoryEnumMap, json['category']) ?? MessageCategory.marketing,
  segment: json['segment'] == null ? Segment.all : Segment.fromJson(json['segment']),
  scheduledFor: DateTime.parse(json['scheduled_for'] as String),
  queued: (json['queued'] as num?)?.toInt() ?? 0,
  skipped: (json['skipped'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BroadcastToJson(_Broadcast instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'category': _$MessageCategoryEnumMap[instance.category]!,
  'segment': _segmentOut(instance.segment),
  'scheduled_for': instance.scheduledFor.toIso8601String(),
  'queued': instance.queued,
  'skipped': instance.skipped,
  'created_at': instance.createdAt.toIso8601String(),
};
