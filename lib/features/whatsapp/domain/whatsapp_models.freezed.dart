// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'whatsapp_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueuedMessage {

 String get id;@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'template_key') String get templateKey; String get language; MessageCategory get category; String get body; MessageChannel get channel;@JsonKey(name: 'scheduled_for') DateTime get scheduledFor; MessageStatus get status; String get source; String? get error;@JsonKey(name: 'sent_at') DateTime? get sentAt;@JsonKey(name: 'delivered_at') DateTime? get deliveredAt;@JsonKey(name: 'read_at') DateTime? get readAt;@JsonKey(name: 'free_window') bool get freeWindow;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'name', readValue: _member) String get memberName;@JsonKey(name: 'phone', readValue: _member) String get memberPhone;@JsonKey(name: 'photo_url', readValue: _member) String? get memberPhoto;
/// Create a copy of QueuedMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueuedMessageCopyWith<QueuedMessage> get copyWith => _$QueuedMessageCopyWithImpl<QueuedMessage>(this as QueuedMessage, _$identity);

  /// Serializes this QueuedMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QueuedMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueuedMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.templateKey, _this.templateKey) || other.templateKey == _this.templateKey)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.scheduledFor, _this.scheduledFor) || other.scheduledFor == _this.scheduledFor)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt)&&(identical(other.deliveredAt, _this.deliveredAt) || other.deliveredAt == _this.deliveredAt)&&(identical(other.readAt, _this.readAt) || other.readAt == _this.readAt)&&(identical(other.freeWindow, _this.freeWindow) || other.freeWindow == _this.freeWindow)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.memberPhone, _this.memberPhone) || other.memberPhone == _this.memberPhone)&&(identical(other.memberPhoto, _this.memberPhoto) || other.memberPhoto == _this.memberPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QueuedMessage;
  return Object.hashAll([runtimeType,_this.id,_this.memberId,_this.templateKey,_this.language,_this.category,_this.body,_this.channel,_this.scheduledFor,_this.status,_this.source,_this.error,_this.sentAt,_this.deliveredAt,_this.readAt,_this.freeWindow,_this.createdAt,_this.memberName,_this.memberPhone,_this.memberPhoto]);
}

@override
String toString() {
  final _this = this as QueuedMessage;
  return 'QueuedMessage(id: ${_this.id}, memberId: ${_this.memberId}, templateKey: ${_this.templateKey}, language: ${_this.language}, category: ${_this.category}, body: ${_this.body}, channel: ${_this.channel}, scheduledFor: ${_this.scheduledFor}, status: ${_this.status}, source: ${_this.source}, error: ${_this.error}, sentAt: ${_this.sentAt}, deliveredAt: ${_this.deliveredAt}, readAt: ${_this.readAt}, freeWindow: ${_this.freeWindow}, createdAt: ${_this.createdAt}, memberName: ${_this.memberName}, memberPhone: ${_this.memberPhone}, memberPhoto: ${_this.memberPhoto})';
}


}

/// @nodoc
abstract mixin class $QueuedMessageCopyWith<$Res>  {
  factory $QueuedMessageCopyWith(QueuedMessage value, $Res Function(QueuedMessage) _then) = _$QueuedMessageCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'template_key') String templateKey, String language, MessageCategory category, String body, MessageChannel channel,@JsonKey(name: 'scheduled_for') DateTime scheduledFor, MessageStatus status, String source, String? error,@JsonKey(name: 'sent_at') DateTime? sentAt,@JsonKey(name: 'delivered_at') DateTime? deliveredAt,@JsonKey(name: 'read_at') DateTime? readAt,@JsonKey(name: 'free_window') bool freeWindow,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'name', readValue: _member) String memberName,@JsonKey(name: 'phone', readValue: _member) String memberPhone,@JsonKey(name: 'photo_url', readValue: _member) String? memberPhoto
});




}
/// @nodoc
class _$QueuedMessageCopyWithImpl<$Res>
    implements $QueuedMessageCopyWith<$Res> {
  _$QueuedMessageCopyWithImpl(this._self, this._then);

  final QueuedMessage _self;
  final $Res Function(QueuedMessage) _then;

/// Create a copy of QueuedMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? templateKey = null,Object? language = null,Object? category = null,Object? body = null,Object? channel = null,Object? scheduledFor = null,Object? status = null,Object? source = null,Object? error = freezed,Object? sentAt = freezed,Object? deliveredAt = freezed,Object? readAt = freezed,Object? freeWindow = null,Object? createdAt = null,Object? memberName = null,Object? memberPhone = null,Object? memberPhoto = freezed,}) {
  return _then(QueuedMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,templateKey: null == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MessageCategory,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as MessageChannel,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,freeWindow: null == freeWindow ? _self.freeWindow : freeWindow // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberPhone: null == memberPhone ? _self.memberPhone : memberPhone // ignore: cast_nullable_to_non_nullable
as String,memberPhoto: freezed == memberPhoto ? _self.memberPhoto : memberPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueuedMessage].
extension QueuedMessagePatterns on QueuedMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueuedMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueuedMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueuedMessage value)  $default,){
final _that = this;
switch (_that) {
case _QueuedMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueuedMessage value)?  $default,){
final _that = this;
switch (_that) {
case _QueuedMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_key')  String templateKey,  String language,  MessageCategory category,  String body,  MessageChannel channel, @JsonKey(name: 'scheduled_for')  DateTime scheduledFor,  MessageStatus status,  String source,  String? error, @JsonKey(name: 'sent_at')  DateTime? sentAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt, @JsonKey(name: 'read_at')  DateTime? readAt, @JsonKey(name: 'free_window')  bool freeWindow, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'name', readValue: _member)  String memberName, @JsonKey(name: 'phone', readValue: _member)  String memberPhone, @JsonKey(name: 'photo_url', readValue: _member)  String? memberPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueuedMessage() when $default != null:
return $default(_that.id,_that.memberId,_that.templateKey,_that.language,_that.category,_that.body,_that.channel,_that.scheduledFor,_that.status,_that.source,_that.error,_that.sentAt,_that.deliveredAt,_that.readAt,_that.freeWindow,_that.createdAt,_that.memberName,_that.memberPhone,_that.memberPhoto);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_key')  String templateKey,  String language,  MessageCategory category,  String body,  MessageChannel channel, @JsonKey(name: 'scheduled_for')  DateTime scheduledFor,  MessageStatus status,  String source,  String? error, @JsonKey(name: 'sent_at')  DateTime? sentAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt, @JsonKey(name: 'read_at')  DateTime? readAt, @JsonKey(name: 'free_window')  bool freeWindow, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'name', readValue: _member)  String memberName, @JsonKey(name: 'phone', readValue: _member)  String memberPhone, @JsonKey(name: 'photo_url', readValue: _member)  String? memberPhoto)  $default,) {final _that = this;
switch (_that) {
case _QueuedMessage():
return $default(_that.id,_that.memberId,_that.templateKey,_that.language,_that.category,_that.body,_that.channel,_that.scheduledFor,_that.status,_that.source,_that.error,_that.sentAt,_that.deliveredAt,_that.readAt,_that.freeWindow,_that.createdAt,_that.memberName,_that.memberPhone,_that.memberPhoto);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_key')  String templateKey,  String language,  MessageCategory category,  String body,  MessageChannel channel, @JsonKey(name: 'scheduled_for')  DateTime scheduledFor,  MessageStatus status,  String source,  String? error, @JsonKey(name: 'sent_at')  DateTime? sentAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt, @JsonKey(name: 'read_at')  DateTime? readAt, @JsonKey(name: 'free_window')  bool freeWindow, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'name', readValue: _member)  String memberName, @JsonKey(name: 'phone', readValue: _member)  String memberPhone, @JsonKey(name: 'photo_url', readValue: _member)  String? memberPhoto)?  $default,) {final _that = this;
switch (_that) {
case _QueuedMessage() when $default != null:
return $default(_that.id,_that.memberId,_that.templateKey,_that.language,_that.category,_that.body,_that.channel,_that.scheduledFor,_that.status,_that.source,_that.error,_that.sentAt,_that.deliveredAt,_that.readAt,_that.freeWindow,_that.createdAt,_that.memberName,_that.memberPhone,_that.memberPhoto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueuedMessage extends QueuedMessage {
  const _QueuedMessage({required this.id, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'template_key') required this.templateKey, this.language = 'en', this.category = MessageCategory.utility, required this.body, this.channel = MessageChannel.link, @JsonKey(name: 'scheduled_for') required this.scheduledFor, this.status = MessageStatus.queued, this.source = 'auto', this.error, @JsonKey(name: 'sent_at') this.sentAt, @JsonKey(name: 'delivered_at') this.deliveredAt, @JsonKey(name: 'read_at') this.readAt, @JsonKey(name: 'free_window') this.freeWindow = false, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'name', readValue: _member) this.memberName = '', @JsonKey(name: 'phone', readValue: _member) this.memberPhone = '', @JsonKey(name: 'photo_url', readValue: _member) this.memberPhoto}): super._();
  factory _QueuedMessage.fromJson(Map<String, dynamic> json) => _$QueuedMessageFromJson(json);

@override final  String id;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'template_key') final  String templateKey;
@override@JsonKey() final  String language;
@override@JsonKey() final  MessageCategory category;
@override final  String body;
@override@JsonKey() final  MessageChannel channel;
@override@JsonKey(name: 'scheduled_for') final  DateTime scheduledFor;
@override@JsonKey() final  MessageStatus status;
@override@JsonKey() final  String source;
@override final  String? error;
@override@JsonKey(name: 'sent_at') final  DateTime? sentAt;
@override@JsonKey(name: 'delivered_at') final  DateTime? deliveredAt;
@override@JsonKey(name: 'read_at') final  DateTime? readAt;
@override@JsonKey(name: 'free_window') final  bool freeWindow;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'name', readValue: _member) final  String memberName;
@override@JsonKey(name: 'phone', readValue: _member) final  String memberPhone;
@override@JsonKey(name: 'photo_url', readValue: _member) final  String? memberPhoto;

/// Create a copy of QueuedMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueuedMessageCopyWith<_QueuedMessage> get copyWith => __$QueuedMessageCopyWithImpl<_QueuedMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueuedMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueuedMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.language, language) || other.language == language)&&(identical(other.category, category) || other.category == category)&&(identical(other.body, body) || other.body == body)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.error, error) || other.error == error)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.freeWindow, freeWindow) || other.freeWindow == freeWindow)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.memberPhone, memberPhone) || other.memberPhone == memberPhone)&&(identical(other.memberPhoto, memberPhoto) || other.memberPhoto == memberPhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,memberId,templateKey,language,category,body,channel,scheduledFor,status,source,error,sentAt,deliveredAt,readAt,freeWindow,createdAt,memberName,memberPhone,memberPhoto]);
}

@override
String toString() {
    return 'QueuedMessage(id: $id, memberId: $memberId, templateKey: $templateKey, language: $language, category: $category, body: $body, channel: $channel, scheduledFor: $scheduledFor, status: $status, source: $source, error: $error, sentAt: $sentAt, deliveredAt: $deliveredAt, readAt: $readAt, freeWindow: $freeWindow, createdAt: $createdAt, memberName: $memberName, memberPhone: $memberPhone, memberPhoto: $memberPhoto)';
}


}

/// @nodoc
abstract mixin class _$QueuedMessageCopyWith<$Res> implements $QueuedMessageCopyWith<$Res> {
  factory _$QueuedMessageCopyWith(_QueuedMessage value, $Res Function(_QueuedMessage) _then) = __$QueuedMessageCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'template_key') String templateKey, String language, MessageCategory category, String body, MessageChannel channel,@JsonKey(name: 'scheduled_for') DateTime scheduledFor, MessageStatus status, String source, String? error,@JsonKey(name: 'sent_at') DateTime? sentAt,@JsonKey(name: 'delivered_at') DateTime? deliveredAt,@JsonKey(name: 'read_at') DateTime? readAt,@JsonKey(name: 'free_window') bool freeWindow,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'name', readValue: _member) String memberName,@JsonKey(name: 'phone', readValue: _member) String memberPhone,@JsonKey(name: 'photo_url', readValue: _member) String? memberPhoto
});




}
/// @nodoc
class __$QueuedMessageCopyWithImpl<$Res>
    implements _$QueuedMessageCopyWith<$Res> {
  __$QueuedMessageCopyWithImpl(this._self, this._then);

  final _QueuedMessage _self;
  final $Res Function(_QueuedMessage) _then;

/// Create a copy of QueuedMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? templateKey = null,Object? language = null,Object? category = null,Object? body = null,Object? channel = null,Object? scheduledFor = null,Object? status = null,Object? source = null,Object? error = freezed,Object? sentAt = freezed,Object? deliveredAt = freezed,Object? readAt = freezed,Object? freeWindow = null,Object? createdAt = null,Object? memberName = null,Object? memberPhone = null,Object? memberPhoto = freezed,}) {
  return _then(_QueuedMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,templateKey: null == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MessageCategory,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as MessageChannel,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,freeWindow: null == freeWindow ? _self.freeWindow : freeWindow // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberPhone: null == memberPhone ? _self.memberPhone : memberPhone // ignore: cast_nullable_to_non_nullable
as String,memberPhoto: freezed == memberPhoto ? _self.memberPhoto : memberPhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MessageTemplate {

 String get id; String get key; String get language; MessageCategory get category; String get title; String get body;@JsonKey(name: 'meta_template_name') String? get metaTemplateName;@JsonKey(name: 'is_system') bool get isSystem;@JsonKey(name: 'is_enabled') bool get isEnabled;
/// Create a copy of MessageTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageTemplateCopyWith<MessageTemplate> get copyWith => _$MessageTemplateCopyWithImpl<MessageTemplate>(this as MessageTemplate, _$identity);

  /// Serializes this MessageTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageTemplate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.metaTemplateName, _this.metaTemplateName) || other.metaTemplateName == _this.metaTemplateName)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&(identical(other.isEnabled, _this.isEnabled) || other.isEnabled == _this.isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageTemplate;
  return Object.hash(runtimeType,_this.id,_this.key,_this.language,_this.category,_this.title,_this.body,_this.metaTemplateName,_this.isSystem,_this.isEnabled);
}

@override
String toString() {
  final _this = this as MessageTemplate;
  return 'MessageTemplate(id: ${_this.id}, key: ${_this.key}, language: ${_this.language}, category: ${_this.category}, title: ${_this.title}, body: ${_this.body}, metaTemplateName: ${_this.metaTemplateName}, isSystem: ${_this.isSystem}, isEnabled: ${_this.isEnabled})';
}


}

/// @nodoc
abstract mixin class $MessageTemplateCopyWith<$Res>  {
  factory $MessageTemplateCopyWith(MessageTemplate value, $Res Function(MessageTemplate) _then) = _$MessageTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String key, String language, MessageCategory category, String title, String body,@JsonKey(name: 'meta_template_name') String? metaTemplateName,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(name: 'is_enabled') bool isEnabled
});




}
/// @nodoc
class _$MessageTemplateCopyWithImpl<$Res>
    implements $MessageTemplateCopyWith<$Res> {
  _$MessageTemplateCopyWithImpl(this._self, this._then);

  final MessageTemplate _self;
  final $Res Function(MessageTemplate) _then;

/// Create a copy of MessageTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? language = null,Object? category = null,Object? title = null,Object? body = null,Object? metaTemplateName = freezed,Object? isSystem = null,Object? isEnabled = null,}) {
  return _then(MessageTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MessageCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,metaTemplateName: freezed == metaTemplateName ? _self.metaTemplateName : metaTemplateName // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageTemplate].
extension MessageTemplatePatterns on MessageTemplate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageTemplate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageTemplate value)  $default,){
final _that = this;
switch (_that) {
case _MessageTemplate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _MessageTemplate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String language,  MessageCategory category,  String title,  String body, @JsonKey(name: 'meta_template_name')  String? metaTemplateName, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_enabled')  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageTemplate() when $default != null:
return $default(_that.id,_that.key,_that.language,_that.category,_that.title,_that.body,_that.metaTemplateName,_that.isSystem,_that.isEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String language,  MessageCategory category,  String title,  String body, @JsonKey(name: 'meta_template_name')  String? metaTemplateName, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_enabled')  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _MessageTemplate():
return $default(_that.id,_that.key,_that.language,_that.category,_that.title,_that.body,_that.metaTemplateName,_that.isSystem,_that.isEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String language,  MessageCategory category,  String title,  String body, @JsonKey(name: 'meta_template_name')  String? metaTemplateName, @JsonKey(name: 'is_system')  bool isSystem, @JsonKey(name: 'is_enabled')  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _MessageTemplate() when $default != null:
return $default(_that.id,_that.key,_that.language,_that.category,_that.title,_that.body,_that.metaTemplateName,_that.isSystem,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageTemplate implements MessageTemplate {
  const _MessageTemplate({this.id = '', required this.key, this.language = 'en', this.category = MessageCategory.utility, required this.title, required this.body, @JsonKey(name: 'meta_template_name') this.metaTemplateName, @JsonKey(name: 'is_system') this.isSystem = false, @JsonKey(name: 'is_enabled') this.isEnabled = true});
  factory _MessageTemplate.fromJson(Map<String, dynamic> json) => _$MessageTemplateFromJson(json);

@override@JsonKey() final  String id;
@override final  String key;
@override@JsonKey() final  String language;
@override@JsonKey() final  MessageCategory category;
@override final  String title;
@override final  String body;
@override@JsonKey(name: 'meta_template_name') final  String? metaTemplateName;
@override@JsonKey(name: 'is_system') final  bool isSystem;
@override@JsonKey(name: 'is_enabled') final  bool isEnabled;

/// Create a copy of MessageTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageTemplateCopyWith<_MessageTemplate> get copyWith => __$MessageTemplateCopyWithImpl<_MessageTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.language, language) || other.language == language)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.metaTemplateName, metaTemplateName) || other.metaTemplateName == metaTemplateName)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,key,language,category,title,body,metaTemplateName,isSystem,isEnabled);
}

@override
String toString() {
    return 'MessageTemplate(id: $id, key: $key, language: $language, category: $category, title: $title, body: $body, metaTemplateName: $metaTemplateName, isSystem: $isSystem, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$MessageTemplateCopyWith<$Res> implements $MessageTemplateCopyWith<$Res> {
  factory _$MessageTemplateCopyWith(_MessageTemplate value, $Res Function(_MessageTemplate) _then) = __$MessageTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String language, MessageCategory category, String title, String body,@JsonKey(name: 'meta_template_name') String? metaTemplateName,@JsonKey(name: 'is_system') bool isSystem,@JsonKey(name: 'is_enabled') bool isEnabled
});




}
/// @nodoc
class __$MessageTemplateCopyWithImpl<$Res>
    implements _$MessageTemplateCopyWith<$Res> {
  __$MessageTemplateCopyWithImpl(this._self, this._then);

  final _MessageTemplate _self;
  final $Res Function(_MessageTemplate) _then;

/// Create a copy of MessageTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? language = null,Object? category = null,Object? title = null,Object? body = null,Object? metaTemplateName = freezed,Object? isSystem = null,Object? isEnabled = null,}) {
  return _then(_MessageTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MessageCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,metaTemplateName: freezed == metaTemplateName ? _self.metaTemplateName : metaTemplateName // ignore: cast_nullable_to_non_nullable
as String?,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Festival {

 String get id; String get name;@JsonKey(name: 'local_name') String? get localName;@JsonKey(fromJson: _dateRequired, toJson: _dateOut) DateTime get day; String? get message;@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) Segment get segment;@JsonKey(name: 'is_enabled') bool get isEnabled;
/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalCopyWith<Festival> get copyWith => _$FestivalCopyWithImpl<Festival>(this as Festival, _$identity);

  /// Serializes this Festival to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Festival;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Festival&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.localName, _this.localName) || other.localName == _this.localName)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.segment, _this.segment) || other.segment == _this.segment)&&(identical(other.isEnabled, _this.isEnabled) || other.isEnabled == _this.isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Festival;
  return Object.hash(runtimeType,_this.id,_this.name,_this.localName,_this.day,_this.message,_this.segment,_this.isEnabled);
}

@override
String toString() {
  final _this = this as Festival;
  return 'Festival(id: ${_this.id}, name: ${_this.name}, localName: ${_this.localName}, day: ${_this.day}, message: ${_this.message}, segment: ${_this.segment}, isEnabled: ${_this.isEnabled})';
}


}

/// @nodoc
abstract mixin class $FestivalCopyWith<$Res>  {
  factory $FestivalCopyWith(Festival value, $Res Function(Festival) _then) = _$FestivalCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'local_name') String? localName,@JsonKey(fromJson: _dateRequired, toJson: _dateOut) DateTime day, String? message,@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) Segment segment,@JsonKey(name: 'is_enabled') bool isEnabled
});




}
/// @nodoc
class _$FestivalCopyWithImpl<$Res>
    implements $FestivalCopyWith<$Res> {
  _$FestivalCopyWithImpl(this._self, this._then);

  final Festival _self;
  final $Res Function(Festival) _then;

/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? localName = freezed,Object? day = null,Object? message = freezed,Object? segment = null,Object? isEnabled = null,}) {
  return _then(Festival(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,localName: freezed == localName ? _self.localName : localName // ignore: cast_nullable_to_non_nullable
as String?,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as Segment,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Festival].
extension FestivalPatterns on Festival {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Festival value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Festival() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Festival value)  $default,){
final _that = this;
switch (_that) {
case _Festival():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Festival value)?  $default,){
final _that = this;
switch (_that) {
case _Festival() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'local_name')  String? localName, @JsonKey(fromJson: _dateRequired, toJson: _dateOut)  DateTime day,  String? message, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut)  Segment segment, @JsonKey(name: 'is_enabled')  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Festival() when $default != null:
return $default(_that.id,_that.name,_that.localName,_that.day,_that.message,_that.segment,_that.isEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'local_name')  String? localName, @JsonKey(fromJson: _dateRequired, toJson: _dateOut)  DateTime day,  String? message, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut)  Segment segment, @JsonKey(name: 'is_enabled')  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _Festival():
return $default(_that.id,_that.name,_that.localName,_that.day,_that.message,_that.segment,_that.isEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'local_name')  String? localName, @JsonKey(fromJson: _dateRequired, toJson: _dateOut)  DateTime day,  String? message, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut)  Segment segment, @JsonKey(name: 'is_enabled')  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _Festival() when $default != null:
return $default(_that.id,_that.name,_that.localName,_that.day,_that.message,_that.segment,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Festival implements Festival {
  const _Festival({this.id = '', required this.name, @JsonKey(name: 'local_name') this.localName, @JsonKey(fromJson: _dateRequired, toJson: _dateOut) required this.day, this.message, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) this.segment = Segment.all, @JsonKey(name: 'is_enabled') this.isEnabled = true});
  factory _Festival.fromJson(Map<String, dynamic> json) => _$FestivalFromJson(json);

@override@JsonKey() final  String id;
@override final  String name;
@override@JsonKey(name: 'local_name') final  String? localName;
@override@JsonKey(fromJson: _dateRequired, toJson: _dateOut) final  DateTime day;
@override final  String? message;
@override@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) final  Segment segment;
@override@JsonKey(name: 'is_enabled') final  bool isEnabled;

/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalCopyWith<_Festival> get copyWith => __$FestivalCopyWithImpl<_Festival>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FestivalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Festival&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.localName, localName) || other.localName == localName)&&(identical(other.day, day) || other.day == day)&&(identical(other.message, message) || other.message == message)&&(identical(other.segment, segment) || other.segment == segment)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,localName,day,message,segment,isEnabled);
}

@override
String toString() {
    return 'Festival(id: $id, name: $name, localName: $localName, day: $day, message: $message, segment: $segment, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$FestivalCopyWith<$Res> implements $FestivalCopyWith<$Res> {
  factory _$FestivalCopyWith(_Festival value, $Res Function(_Festival) _then) = __$FestivalCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'local_name') String? localName,@JsonKey(fromJson: _dateRequired, toJson: _dateOut) DateTime day, String? message,@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) Segment segment,@JsonKey(name: 'is_enabled') bool isEnabled
});




}
/// @nodoc
class __$FestivalCopyWithImpl<$Res>
    implements _$FestivalCopyWith<$Res> {
  __$FestivalCopyWithImpl(this._self, this._then);

  final _Festival _self;
  final $Res Function(_Festival) _then;

/// Create a copy of Festival
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? localName = freezed,Object? day = null,Object? message = freezed,Object? segment = null,Object? isEnabled = null,}) {
  return _then(_Festival(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,localName: freezed == localName ? _self.localName : localName // ignore: cast_nullable_to_non_nullable
as String?,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as Segment,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Broadcast {

 String get id; String get title; String get body; MessageCategory get category;@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) Segment get segment;@JsonKey(name: 'scheduled_for') DateTime get scheduledFor; int get queued; int get skipped;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of Broadcast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BroadcastCopyWith<Broadcast> get copyWith => _$BroadcastCopyWithImpl<Broadcast>(this as Broadcast, _$identity);

  /// Serializes this Broadcast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Broadcast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Broadcast&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.segment, _this.segment) || other.segment == _this.segment)&&(identical(other.scheduledFor, _this.scheduledFor) || other.scheduledFor == _this.scheduledFor)&&(identical(other.queued, _this.queued) || other.queued == _this.queued)&&(identical(other.skipped, _this.skipped) || other.skipped == _this.skipped)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Broadcast;
  return Object.hash(runtimeType,_this.id,_this.title,_this.body,_this.category,_this.segment,_this.scheduledFor,_this.queued,_this.skipped,_this.createdAt);
}

@override
String toString() {
  final _this = this as Broadcast;
  return 'Broadcast(id: ${_this.id}, title: ${_this.title}, body: ${_this.body}, category: ${_this.category}, segment: ${_this.segment}, scheduledFor: ${_this.scheduledFor}, queued: ${_this.queued}, skipped: ${_this.skipped}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $BroadcastCopyWith<$Res>  {
  factory $BroadcastCopyWith(Broadcast value, $Res Function(Broadcast) _then) = _$BroadcastCopyWithImpl;
@useResult
$Res call({
 String id, String title, String body, MessageCategory category,@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) Segment segment,@JsonKey(name: 'scheduled_for') DateTime scheduledFor, int queued, int skipped,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$BroadcastCopyWithImpl<$Res>
    implements $BroadcastCopyWith<$Res> {
  _$BroadcastCopyWithImpl(this._self, this._then);

  final Broadcast _self;
  final $Res Function(Broadcast) _then;

/// Create a copy of Broadcast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? category = null,Object? segment = null,Object? scheduledFor = null,Object? queued = null,Object? skipped = null,Object? createdAt = null,}) {
  return _then(Broadcast(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MessageCategory,segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as Segment,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,queued: null == queued ? _self.queued : queued // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Broadcast].
extension BroadcastPatterns on Broadcast {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Broadcast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Broadcast() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Broadcast value)  $default,){
final _that = this;
switch (_that) {
case _Broadcast():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Broadcast value)?  $default,){
final _that = this;
switch (_that) {
case _Broadcast() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String body,  MessageCategory category, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut)  Segment segment, @JsonKey(name: 'scheduled_for')  DateTime scheduledFor,  int queued,  int skipped, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Broadcast() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.category,_that.segment,_that.scheduledFor,_that.queued,_that.skipped,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String body,  MessageCategory category, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut)  Segment segment, @JsonKey(name: 'scheduled_for')  DateTime scheduledFor,  int queued,  int skipped, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Broadcast():
return $default(_that.id,_that.title,_that.body,_that.category,_that.segment,_that.scheduledFor,_that.queued,_that.skipped,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String body,  MessageCategory category, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut)  Segment segment, @JsonKey(name: 'scheduled_for')  DateTime scheduledFor,  int queued,  int skipped, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Broadcast() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.category,_that.segment,_that.scheduledFor,_that.queued,_that.skipped,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Broadcast implements Broadcast {
  const _Broadcast({required this.id, required this.title, required this.body, this.category = MessageCategory.marketing, @JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) this.segment = Segment.all, @JsonKey(name: 'scheduled_for') required this.scheduledFor, this.queued = 0, this.skipped = 0, @JsonKey(name: 'created_at') required this.createdAt});
  factory _Broadcast.fromJson(Map<String, dynamic> json) => _$BroadcastFromJson(json);

@override final  String id;
@override final  String title;
@override final  String body;
@override@JsonKey() final  MessageCategory category;
@override@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) final  Segment segment;
@override@JsonKey(name: 'scheduled_for') final  DateTime scheduledFor;
@override@JsonKey() final  int queued;
@override@JsonKey() final  int skipped;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of Broadcast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BroadcastCopyWith<_Broadcast> get copyWith => __$BroadcastCopyWithImpl<_Broadcast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BroadcastToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Broadcast&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.category, category) || other.category == category)&&(identical(other.segment, segment) || other.segment == segment)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.queued, queued) || other.queued == queued)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,body,category,segment,scheduledFor,queued,skipped,createdAt);
}

@override
String toString() {
    return 'Broadcast(id: $id, title: $title, body: $body, category: $category, segment: $segment, scheduledFor: $scheduledFor, queued: $queued, skipped: $skipped, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BroadcastCopyWith<$Res> implements $BroadcastCopyWith<$Res> {
  factory _$BroadcastCopyWith(_Broadcast value, $Res Function(_Broadcast) _then) = __$BroadcastCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String body, MessageCategory category,@JsonKey(fromJson: Segment.fromJson, toJson: _segmentOut) Segment segment,@JsonKey(name: 'scheduled_for') DateTime scheduledFor, int queued, int skipped,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$BroadcastCopyWithImpl<$Res>
    implements _$BroadcastCopyWith<$Res> {
  __$BroadcastCopyWithImpl(this._self, this._then);

  final _Broadcast _self;
  final $Res Function(_Broadcast) _then;

/// Create a copy of Broadcast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? category = null,Object? segment = null,Object? scheduledFor = null,Object? queued = null,Object? skipped = null,Object? createdAt = null,}) {
  return _then(_Broadcast(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MessageCategory,segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as Segment,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,queued: null == queued ? _self.queued : queued // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
