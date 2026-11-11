// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Member {

 String get id;@JsonKey(name: 'member_code') String get memberCode; String get name; String get phone;@JsonKey(name: 'alt_phone') String? get altPhone; String? get email; String? get gender;@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get dob; String? get address;@JsonKey(name: 'emergency_name') String? get emergencyName;@JsonKey(name: 'emergency_relation') String? get emergencyRelation;@JsonKey(name: 'emergency_phone') String? get emergencyPhone;@JsonKey(name: 'blood_group') String? get bloodGroup;@JsonKey(name: 'photo_url') String? get photoPath; String? get goal; String? get level;@JsonKey(name: 'diet_pref') String? get dietPref; String get language;@JsonKey(name: 'trainer_id') String? get trainerId; String? get batch; String? get source;@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus get status;@JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut) DateTime? get joinedOn; String? get notes;@JsonKey(name: 'plan_name') String? get planName;@JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut) DateTime? get membershipStart;@JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut) DateTime? get membershipEnd;@JsonKey(name: 'current_membership_id') String? get currentMembershipId;@JsonKey(name: 'whatsapp_opt_out') bool get whatsappOptOut;@JsonKey(name: 'archived_at') DateTime? get archivedAt;@JsonKey(name: 'dues_paise') int get duesPaise;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Member;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberCode, _this.memberCode) || other.memberCode == _this.memberCode)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.altPhone, _this.altPhone) || other.altPhone == _this.altPhone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.dob, _this.dob) || other.dob == _this.dob)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.emergencyName, _this.emergencyName) || other.emergencyName == _this.emergencyName)&&(identical(other.emergencyRelation, _this.emergencyRelation) || other.emergencyRelation == _this.emergencyRelation)&&(identical(other.emergencyPhone, _this.emergencyPhone) || other.emergencyPhone == _this.emergencyPhone)&&(identical(other.bloodGroup, _this.bloodGroup) || other.bloodGroup == _this.bloodGroup)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.dietPref, _this.dietPref) || other.dietPref == _this.dietPref)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.trainerId, _this.trainerId) || other.trainerId == _this.trainerId)&&(identical(other.batch, _this.batch) || other.batch == _this.batch)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.joinedOn, _this.joinedOn) || other.joinedOn == _this.joinedOn)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.planName, _this.planName) || other.planName == _this.planName)&&(identical(other.membershipStart, _this.membershipStart) || other.membershipStart == _this.membershipStart)&&(identical(other.membershipEnd, _this.membershipEnd) || other.membershipEnd == _this.membershipEnd)&&(identical(other.currentMembershipId, _this.currentMembershipId) || other.currentMembershipId == _this.currentMembershipId)&&(identical(other.whatsappOptOut, _this.whatsappOptOut) || other.whatsappOptOut == _this.whatsappOptOut)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt)&&(identical(other.duesPaise, _this.duesPaise) || other.duesPaise == _this.duesPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Member;
  return Object.hashAll([runtimeType,_this.id,_this.memberCode,_this.name,_this.phone,_this.altPhone,_this.email,_this.gender,_this.dob,_this.address,_this.emergencyName,_this.emergencyRelation,_this.emergencyPhone,_this.bloodGroup,_this.photoPath,_this.goal,_this.level,_this.dietPref,_this.language,_this.trainerId,_this.batch,_this.source,_this.status,_this.joinedOn,_this.notes,_this.planName,_this.membershipStart,_this.membershipEnd,_this.currentMembershipId,_this.whatsappOptOut,_this.archivedAt,_this.duesPaise]);
}

@override
String toString() {
  final _this = this as Member;
  return 'Member(id: ${_this.id}, memberCode: ${_this.memberCode}, name: ${_this.name}, phone: ${_this.phone}, altPhone: ${_this.altPhone}, email: ${_this.email}, gender: ${_this.gender}, dob: ${_this.dob}, address: ${_this.address}, emergencyName: ${_this.emergencyName}, emergencyRelation: ${_this.emergencyRelation}, emergencyPhone: ${_this.emergencyPhone}, bloodGroup: ${_this.bloodGroup}, photoPath: ${_this.photoPath}, goal: ${_this.goal}, level: ${_this.level}, dietPref: ${_this.dietPref}, language: ${_this.language}, trainerId: ${_this.trainerId}, batch: ${_this.batch}, source: ${_this.source}, status: ${_this.status}, joinedOn: ${_this.joinedOn}, notes: ${_this.notes}, planName: ${_this.planName}, membershipStart: ${_this.membershipStart}, membershipEnd: ${_this.membershipEnd}, currentMembershipId: ${_this.currentMembershipId}, whatsappOptOut: ${_this.whatsappOptOut}, archivedAt: ${_this.archivedAt}, duesPaise: ${_this.duesPaise})';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'member_code') String memberCode, String name, String phone,@JsonKey(name: 'alt_phone') String? altPhone, String? email, String? gender,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? dob, String? address,@JsonKey(name: 'emergency_name') String? emergencyName,@JsonKey(name: 'emergency_relation') String? emergencyRelation,@JsonKey(name: 'emergency_phone') String? emergencyPhone,@JsonKey(name: 'blood_group') String? bloodGroup,@JsonKey(name: 'photo_url') String? photoPath, String? goal, String? level,@JsonKey(name: 'diet_pref') String? dietPref, String language,@JsonKey(name: 'trainer_id') String? trainerId, String? batch, String? source,@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus status,@JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut) DateTime? joinedOn, String? notes,@JsonKey(name: 'plan_name') String? planName,@JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut) DateTime? membershipStart,@JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut) DateTime? membershipEnd,@JsonKey(name: 'current_membership_id') String? currentMembershipId,@JsonKey(name: 'whatsapp_opt_out') bool whatsappOptOut,@JsonKey(name: 'archived_at') DateTime? archivedAt,@JsonKey(name: 'dues_paise') int duesPaise
});




}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberCode = null,Object? name = null,Object? phone = null,Object? altPhone = freezed,Object? email = freezed,Object? gender = freezed,Object? dob = freezed,Object? address = freezed,Object? emergencyName = freezed,Object? emergencyRelation = freezed,Object? emergencyPhone = freezed,Object? bloodGroup = freezed,Object? photoPath = freezed,Object? goal = freezed,Object? level = freezed,Object? dietPref = freezed,Object? language = null,Object? trainerId = freezed,Object? batch = freezed,Object? source = freezed,Object? status = null,Object? joinedOn = freezed,Object? notes = freezed,Object? planName = freezed,Object? membershipStart = freezed,Object? membershipEnd = freezed,Object? currentMembershipId = freezed,Object? whatsappOptOut = null,Object? archivedAt = freezed,Object? duesPaise = null,}) {
  return _then(Member(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,altPhone: freezed == altPhone ? _self.altPhone : altPhone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,emergencyName: freezed == emergencyName ? _self.emergencyName : emergencyName // ignore: cast_nullable_to_non_nullable
as String?,emergencyRelation: freezed == emergencyRelation ? _self.emergencyRelation : emergencyRelation // ignore: cast_nullable_to_non_nullable
as String?,emergencyPhone: freezed == emergencyPhone ? _self.emergencyPhone : emergencyPhone // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,dietPref: freezed == dietPref ? _self.dietPref : dietPref // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,joinedOn: freezed == joinedOn ? _self.joinedOn : joinedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,membershipStart: freezed == membershipStart ? _self.membershipStart : membershipStart // ignore: cast_nullable_to_non_nullable
as DateTime?,membershipEnd: freezed == membershipEnd ? _self.membershipEnd : membershipEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,currentMembershipId: freezed == currentMembershipId ? _self.currentMembershipId : currentMembershipId // ignore: cast_nullable_to_non_nullable
as String?,whatsappOptOut: null == whatsappOptOut ? _self.whatsappOptOut : whatsappOptOut // ignore: cast_nullable_to_non_nullable
as bool,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duesPaise: null == duesPaise ? _self.duesPaise : duesPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_code')  String memberCode,  String name,  String phone, @JsonKey(name: 'alt_phone')  String? altPhone,  String? email,  String? gender, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? dob,  String? address, @JsonKey(name: 'emergency_name')  String? emergencyName, @JsonKey(name: 'emergency_relation')  String? emergencyRelation, @JsonKey(name: 'emergency_phone')  String? emergencyPhone, @JsonKey(name: 'blood_group')  String? bloodGroup, @JsonKey(name: 'photo_url')  String? photoPath,  String? goal,  String? level, @JsonKey(name: 'diet_pref')  String? dietPref,  String language, @JsonKey(name: 'trainer_id')  String? trainerId,  String? batch,  String? source, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut)  DateTime? joinedOn,  String? notes, @JsonKey(name: 'plan_name')  String? planName, @JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut)  DateTime? membershipStart, @JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut)  DateTime? membershipEnd, @JsonKey(name: 'current_membership_id')  String? currentMembershipId, @JsonKey(name: 'whatsapp_opt_out')  bool whatsappOptOut, @JsonKey(name: 'archived_at')  DateTime? archivedAt, @JsonKey(name: 'dues_paise')  int duesPaise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.memberCode,_that.name,_that.phone,_that.altPhone,_that.email,_that.gender,_that.dob,_that.address,_that.emergencyName,_that.emergencyRelation,_that.emergencyPhone,_that.bloodGroup,_that.photoPath,_that.goal,_that.level,_that.dietPref,_that.language,_that.trainerId,_that.batch,_that.source,_that.status,_that.joinedOn,_that.notes,_that.planName,_that.membershipStart,_that.membershipEnd,_that.currentMembershipId,_that.whatsappOptOut,_that.archivedAt,_that.duesPaise);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_code')  String memberCode,  String name,  String phone, @JsonKey(name: 'alt_phone')  String? altPhone,  String? email,  String? gender, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? dob,  String? address, @JsonKey(name: 'emergency_name')  String? emergencyName, @JsonKey(name: 'emergency_relation')  String? emergencyRelation, @JsonKey(name: 'emergency_phone')  String? emergencyPhone, @JsonKey(name: 'blood_group')  String? bloodGroup, @JsonKey(name: 'photo_url')  String? photoPath,  String? goal,  String? level, @JsonKey(name: 'diet_pref')  String? dietPref,  String language, @JsonKey(name: 'trainer_id')  String? trainerId,  String? batch,  String? source, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut)  DateTime? joinedOn,  String? notes, @JsonKey(name: 'plan_name')  String? planName, @JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut)  DateTime? membershipStart, @JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut)  DateTime? membershipEnd, @JsonKey(name: 'current_membership_id')  String? currentMembershipId, @JsonKey(name: 'whatsapp_opt_out')  bool whatsappOptOut, @JsonKey(name: 'archived_at')  DateTime? archivedAt, @JsonKey(name: 'dues_paise')  int duesPaise)  $default,) {final _that = this;
switch (_that) {
case _Member():
return $default(_that.id,_that.memberCode,_that.name,_that.phone,_that.altPhone,_that.email,_that.gender,_that.dob,_that.address,_that.emergencyName,_that.emergencyRelation,_that.emergencyPhone,_that.bloodGroup,_that.photoPath,_that.goal,_that.level,_that.dietPref,_that.language,_that.trainerId,_that.batch,_that.source,_that.status,_that.joinedOn,_that.notes,_that.planName,_that.membershipStart,_that.membershipEnd,_that.currentMembershipId,_that.whatsappOptOut,_that.archivedAt,_that.duesPaise);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'member_code')  String memberCode,  String name,  String phone, @JsonKey(name: 'alt_phone')  String? altPhone,  String? email,  String? gender, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? dob,  String? address, @JsonKey(name: 'emergency_name')  String? emergencyName, @JsonKey(name: 'emergency_relation')  String? emergencyRelation, @JsonKey(name: 'emergency_phone')  String? emergencyPhone, @JsonKey(name: 'blood_group')  String? bloodGroup, @JsonKey(name: 'photo_url')  String? photoPath,  String? goal,  String? level, @JsonKey(name: 'diet_pref')  String? dietPref,  String language, @JsonKey(name: 'trainer_id')  String? trainerId,  String? batch,  String? source, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut)  DateTime? joinedOn,  String? notes, @JsonKey(name: 'plan_name')  String? planName, @JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut)  DateTime? membershipStart, @JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut)  DateTime? membershipEnd, @JsonKey(name: 'current_membership_id')  String? currentMembershipId, @JsonKey(name: 'whatsapp_opt_out')  bool whatsappOptOut, @JsonKey(name: 'archived_at')  DateTime? archivedAt, @JsonKey(name: 'dues_paise')  int duesPaise)?  $default,) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.memberCode,_that.name,_that.phone,_that.altPhone,_that.email,_that.gender,_that.dob,_that.address,_that.emergencyName,_that.emergencyRelation,_that.emergencyPhone,_that.bloodGroup,_that.photoPath,_that.goal,_that.level,_that.dietPref,_that.language,_that.trainerId,_that.batch,_that.source,_that.status,_that.joinedOn,_that.notes,_that.planName,_that.membershipStart,_that.membershipEnd,_that.currentMembershipId,_that.whatsappOptOut,_that.archivedAt,_that.duesPaise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Member extends Member {
  const _Member({required this.id, @JsonKey(name: 'member_code') required this.memberCode, required this.name, required this.phone, @JsonKey(name: 'alt_phone') this.altPhone, this.email, this.gender, @JsonKey(fromJson: _date, toJson: _dateOut) this.dob, this.address, @JsonKey(name: 'emergency_name') this.emergencyName, @JsonKey(name: 'emergency_relation') this.emergencyRelation, @JsonKey(name: 'emergency_phone') this.emergencyPhone, @JsonKey(name: 'blood_group') this.bloodGroup, @JsonKey(name: 'photo_url') this.photoPath, this.goal, this.level, @JsonKey(name: 'diet_pref') this.dietPref, this.language = 'en', @JsonKey(name: 'trainer_id') this.trainerId, this.batch, this.source, @JsonKey(fromJson: _status, toJson: _statusOut) this.status = MemberStatus.inactive, @JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut) this.joinedOn, this.notes, @JsonKey(name: 'plan_name') this.planName, @JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut) this.membershipStart, @JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut) this.membershipEnd, @JsonKey(name: 'current_membership_id') this.currentMembershipId, @JsonKey(name: 'whatsapp_opt_out') this.whatsappOptOut = false, @JsonKey(name: 'archived_at') this.archivedAt, @JsonKey(name: 'dues_paise') this.duesPaise = 0}): super._();
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

@override final  String id;
@override@JsonKey(name: 'member_code') final  String memberCode;
@override final  String name;
@override final  String phone;
@override@JsonKey(name: 'alt_phone') final  String? altPhone;
@override final  String? email;
@override final  String? gender;
@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? dob;
@override final  String? address;
@override@JsonKey(name: 'emergency_name') final  String? emergencyName;
@override@JsonKey(name: 'emergency_relation') final  String? emergencyRelation;
@override@JsonKey(name: 'emergency_phone') final  String? emergencyPhone;
@override@JsonKey(name: 'blood_group') final  String? bloodGroup;
@override@JsonKey(name: 'photo_url') final  String? photoPath;
@override final  String? goal;
@override final  String? level;
@override@JsonKey(name: 'diet_pref') final  String? dietPref;
@override@JsonKey() final  String language;
@override@JsonKey(name: 'trainer_id') final  String? trainerId;
@override final  String? batch;
@override final  String? source;
@override@JsonKey(fromJson: _status, toJson: _statusOut) final  MemberStatus status;
@override@JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut) final  DateTime? joinedOn;
@override final  String? notes;
@override@JsonKey(name: 'plan_name') final  String? planName;
@override@JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut) final  DateTime? membershipStart;
@override@JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut) final  DateTime? membershipEnd;
@override@JsonKey(name: 'current_membership_id') final  String? currentMembershipId;
@override@JsonKey(name: 'whatsapp_opt_out') final  bool whatsappOptOut;
@override@JsonKey(name: 'archived_at') final  DateTime? archivedAt;
@override@JsonKey(name: 'dues_paise') final  int duesPaise;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.id, id) || other.id == id)&&(identical(other.memberCode, memberCode) || other.memberCode == memberCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.altPhone, altPhone) || other.altPhone == altPhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.address, address) || other.address == address)&&(identical(other.emergencyName, emergencyName) || other.emergencyName == emergencyName)&&(identical(other.emergencyRelation, emergencyRelation) || other.emergencyRelation == emergencyRelation)&&(identical(other.emergencyPhone, emergencyPhone) || other.emergencyPhone == emergencyPhone)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.level, level) || other.level == level)&&(identical(other.dietPref, dietPref) || other.dietPref == dietPref)&&(identical(other.language, language) || other.language == language)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedOn, joinedOn) || other.joinedOn == joinedOn)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.membershipStart, membershipStart) || other.membershipStart == membershipStart)&&(identical(other.membershipEnd, membershipEnd) || other.membershipEnd == membershipEnd)&&(identical(other.currentMembershipId, currentMembershipId) || other.currentMembershipId == currentMembershipId)&&(identical(other.whatsappOptOut, whatsappOptOut) || other.whatsappOptOut == whatsappOptOut)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.duesPaise, duesPaise) || other.duesPaise == duesPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,memberCode,name,phone,altPhone,email,gender,dob,address,emergencyName,emergencyRelation,emergencyPhone,bloodGroup,photoPath,goal,level,dietPref,language,trainerId,batch,source,status,joinedOn,notes,planName,membershipStart,membershipEnd,currentMembershipId,whatsappOptOut,archivedAt,duesPaise]);
}

@override
String toString() {
    return 'Member(id: $id, memberCode: $memberCode, name: $name, phone: $phone, altPhone: $altPhone, email: $email, gender: $gender, dob: $dob, address: $address, emergencyName: $emergencyName, emergencyRelation: $emergencyRelation, emergencyPhone: $emergencyPhone, bloodGroup: $bloodGroup, photoPath: $photoPath, goal: $goal, level: $level, dietPref: $dietPref, language: $language, trainerId: $trainerId, batch: $batch, source: $source, status: $status, joinedOn: $joinedOn, notes: $notes, planName: $planName, membershipStart: $membershipStart, membershipEnd: $membershipEnd, currentMembershipId: $currentMembershipId, whatsappOptOut: $whatsappOptOut, archivedAt: $archivedAt, duesPaise: $duesPaise)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'member_code') String memberCode, String name, String phone,@JsonKey(name: 'alt_phone') String? altPhone, String? email, String? gender,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? dob, String? address,@JsonKey(name: 'emergency_name') String? emergencyName,@JsonKey(name: 'emergency_relation') String? emergencyRelation,@JsonKey(name: 'emergency_phone') String? emergencyPhone,@JsonKey(name: 'blood_group') String? bloodGroup,@JsonKey(name: 'photo_url') String? photoPath, String? goal, String? level,@JsonKey(name: 'diet_pref') String? dietPref, String language,@JsonKey(name: 'trainer_id') String? trainerId, String? batch, String? source,@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus status,@JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut) DateTime? joinedOn, String? notes,@JsonKey(name: 'plan_name') String? planName,@JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut) DateTime? membershipStart,@JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut) DateTime? membershipEnd,@JsonKey(name: 'current_membership_id') String? currentMembershipId,@JsonKey(name: 'whatsapp_opt_out') bool whatsappOptOut,@JsonKey(name: 'archived_at') DateTime? archivedAt,@JsonKey(name: 'dues_paise') int duesPaise
});




}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberCode = null,Object? name = null,Object? phone = null,Object? altPhone = freezed,Object? email = freezed,Object? gender = freezed,Object? dob = freezed,Object? address = freezed,Object? emergencyName = freezed,Object? emergencyRelation = freezed,Object? emergencyPhone = freezed,Object? bloodGroup = freezed,Object? photoPath = freezed,Object? goal = freezed,Object? level = freezed,Object? dietPref = freezed,Object? language = null,Object? trainerId = freezed,Object? batch = freezed,Object? source = freezed,Object? status = null,Object? joinedOn = freezed,Object? notes = freezed,Object? planName = freezed,Object? membershipStart = freezed,Object? membershipEnd = freezed,Object? currentMembershipId = freezed,Object? whatsappOptOut = null,Object? archivedAt = freezed,Object? duesPaise = null,}) {
  return _then(_Member(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,altPhone: freezed == altPhone ? _self.altPhone : altPhone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,emergencyName: freezed == emergencyName ? _self.emergencyName : emergencyName // ignore: cast_nullable_to_non_nullable
as String?,emergencyRelation: freezed == emergencyRelation ? _self.emergencyRelation : emergencyRelation // ignore: cast_nullable_to_non_nullable
as String?,emergencyPhone: freezed == emergencyPhone ? _self.emergencyPhone : emergencyPhone // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,dietPref: freezed == dietPref ? _self.dietPref : dietPref // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,joinedOn: freezed == joinedOn ? _self.joinedOn : joinedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,membershipStart: freezed == membershipStart ? _self.membershipStart : membershipStart // ignore: cast_nullable_to_non_nullable
as DateTime?,membershipEnd: freezed == membershipEnd ? _self.membershipEnd : membershipEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,currentMembershipId: freezed == currentMembershipId ? _self.currentMembershipId : currentMembershipId // ignore: cast_nullable_to_non_nullable
as String?,whatsappOptOut: null == whatsappOptOut ? _self.whatsappOptOut : whatsappOptOut // ignore: cast_nullable_to_non_nullable
as bool,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duesPaise: null == duesPaise ? _self.duesPaise : duesPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Plan {

 String get id; String get name;@JsonKey(name: 'duration_value') int get durationValue;@JsonKey(name: 'duration_unit') String get durationUnit;@JsonKey(name: 'price_paise') int get pricePaise;@JsonKey(name: 'joining_fee_paise') int get joiningFeePaise;@JsonKey(name: 'gst_rate') num get gstRate;@JsonKey(name: 'includes_pt') bool get includesPt;@JsonKey(name: 'sessions_limit') int? get sessionsLimit;@JsonKey(name: 'freeze_days_allowed') int get freezeDaysAllowed; String get color; String? get description;@JsonKey(name: 'is_archived') bool get isArchived;
/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanCopyWith<Plan> get copyWith => _$PlanCopyWithImpl<Plan>(this as Plan, _$identity);

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Plan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plan&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.durationValue, _this.durationValue) || other.durationValue == _this.durationValue)&&(identical(other.durationUnit, _this.durationUnit) || other.durationUnit == _this.durationUnit)&&(identical(other.pricePaise, _this.pricePaise) || other.pricePaise == _this.pricePaise)&&(identical(other.joiningFeePaise, _this.joiningFeePaise) || other.joiningFeePaise == _this.joiningFeePaise)&&(identical(other.gstRate, _this.gstRate) || other.gstRate == _this.gstRate)&&(identical(other.includesPt, _this.includesPt) || other.includesPt == _this.includesPt)&&(identical(other.sessionsLimit, _this.sessionsLimit) || other.sessionsLimit == _this.sessionsLimit)&&(identical(other.freezeDaysAllowed, _this.freezeDaysAllowed) || other.freezeDaysAllowed == _this.freezeDaysAllowed)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Plan;
  return Object.hash(runtimeType,_this.id,_this.name,_this.durationValue,_this.durationUnit,_this.pricePaise,_this.joiningFeePaise,_this.gstRate,_this.includesPt,_this.sessionsLimit,_this.freezeDaysAllowed,_this.color,_this.description,_this.isArchived);
}

@override
String toString() {
  final _this = this as Plan;
  return 'Plan(id: ${_this.id}, name: ${_this.name}, durationValue: ${_this.durationValue}, durationUnit: ${_this.durationUnit}, pricePaise: ${_this.pricePaise}, joiningFeePaise: ${_this.joiningFeePaise}, gstRate: ${_this.gstRate}, includesPt: ${_this.includesPt}, sessionsLimit: ${_this.sessionsLimit}, freezeDaysAllowed: ${_this.freezeDaysAllowed}, color: ${_this.color}, description: ${_this.description}, isArchived: ${_this.isArchived})';
}


}

/// @nodoc
abstract mixin class $PlanCopyWith<$Res>  {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) _then) = _$PlanCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'duration_value') int durationValue,@JsonKey(name: 'duration_unit') String durationUnit,@JsonKey(name: 'price_paise') int pricePaise,@JsonKey(name: 'joining_fee_paise') int joiningFeePaise,@JsonKey(name: 'gst_rate') num gstRate,@JsonKey(name: 'includes_pt') bool includesPt,@JsonKey(name: 'sessions_limit') int? sessionsLimit,@JsonKey(name: 'freeze_days_allowed') int freezeDaysAllowed, String color, String? description,@JsonKey(name: 'is_archived') bool isArchived
});




}
/// @nodoc
class _$PlanCopyWithImpl<$Res>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._self, this._then);

  final Plan _self;
  final $Res Function(Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? durationValue = null,Object? durationUnit = null,Object? pricePaise = null,Object? joiningFeePaise = null,Object? gstRate = null,Object? includesPt = null,Object? sessionsLimit = freezed,Object? freezeDaysAllowed = null,Object? color = null,Object? description = freezed,Object? isArchived = null,}) {
  return _then(Plan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationValue: null == durationValue ? _self.durationValue : durationValue // ignore: cast_nullable_to_non_nullable
as int,durationUnit: null == durationUnit ? _self.durationUnit : durationUnit // ignore: cast_nullable_to_non_nullable
as String,pricePaise: null == pricePaise ? _self.pricePaise : pricePaise // ignore: cast_nullable_to_non_nullable
as int,joiningFeePaise: null == joiningFeePaise ? _self.joiningFeePaise : joiningFeePaise // ignore: cast_nullable_to_non_nullable
as int,gstRate: null == gstRate ? _self.gstRate : gstRate // ignore: cast_nullable_to_non_nullable
as num,includesPt: null == includesPt ? _self.includesPt : includesPt // ignore: cast_nullable_to_non_nullable
as bool,sessionsLimit: freezed == sessionsLimit ? _self.sessionsLimit : sessionsLimit // ignore: cast_nullable_to_non_nullable
as int?,freezeDaysAllowed: null == freezeDaysAllowed ? _self.freezeDaysAllowed : freezeDaysAllowed // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Plan].
extension PlanPatterns on Plan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Plan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Plan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Plan value)  $default,){
final _that = this;
switch (_that) {
case _Plan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Plan value)?  $default,){
final _that = this;
switch (_that) {
case _Plan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'duration_value')  int durationValue, @JsonKey(name: 'duration_unit')  String durationUnit, @JsonKey(name: 'price_paise')  int pricePaise, @JsonKey(name: 'joining_fee_paise')  int joiningFeePaise, @JsonKey(name: 'gst_rate')  num gstRate, @JsonKey(name: 'includes_pt')  bool includesPt, @JsonKey(name: 'sessions_limit')  int? sessionsLimit, @JsonKey(name: 'freeze_days_allowed')  int freezeDaysAllowed,  String color,  String? description, @JsonKey(name: 'is_archived')  bool isArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.id,_that.name,_that.durationValue,_that.durationUnit,_that.pricePaise,_that.joiningFeePaise,_that.gstRate,_that.includesPt,_that.sessionsLimit,_that.freezeDaysAllowed,_that.color,_that.description,_that.isArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'duration_value')  int durationValue, @JsonKey(name: 'duration_unit')  String durationUnit, @JsonKey(name: 'price_paise')  int pricePaise, @JsonKey(name: 'joining_fee_paise')  int joiningFeePaise, @JsonKey(name: 'gst_rate')  num gstRate, @JsonKey(name: 'includes_pt')  bool includesPt, @JsonKey(name: 'sessions_limit')  int? sessionsLimit, @JsonKey(name: 'freeze_days_allowed')  int freezeDaysAllowed,  String color,  String? description, @JsonKey(name: 'is_archived')  bool isArchived)  $default,) {final _that = this;
switch (_that) {
case _Plan():
return $default(_that.id,_that.name,_that.durationValue,_that.durationUnit,_that.pricePaise,_that.joiningFeePaise,_that.gstRate,_that.includesPt,_that.sessionsLimit,_that.freezeDaysAllowed,_that.color,_that.description,_that.isArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'duration_value')  int durationValue, @JsonKey(name: 'duration_unit')  String durationUnit, @JsonKey(name: 'price_paise')  int pricePaise, @JsonKey(name: 'joining_fee_paise')  int joiningFeePaise, @JsonKey(name: 'gst_rate')  num gstRate, @JsonKey(name: 'includes_pt')  bool includesPt, @JsonKey(name: 'sessions_limit')  int? sessionsLimit, @JsonKey(name: 'freeze_days_allowed')  int freezeDaysAllowed,  String color,  String? description, @JsonKey(name: 'is_archived')  bool isArchived)?  $default,) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.id,_that.name,_that.durationValue,_that.durationUnit,_that.pricePaise,_that.joiningFeePaise,_that.gstRate,_that.includesPt,_that.sessionsLimit,_that.freezeDaysAllowed,_that.color,_that.description,_that.isArchived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Plan extends Plan {
  const _Plan({required this.id, required this.name, @JsonKey(name: 'duration_value') required this.durationValue, @JsonKey(name: 'duration_unit') this.durationUnit = 'months', @JsonKey(name: 'price_paise') required this.pricePaise, @JsonKey(name: 'joining_fee_paise') this.joiningFeePaise = 0, @JsonKey(name: 'gst_rate') this.gstRate = 0, @JsonKey(name: 'includes_pt') this.includesPt = false, @JsonKey(name: 'sessions_limit') this.sessionsLimit, @JsonKey(name: 'freeze_days_allowed') this.freezeDaysAllowed = 0, this.color = 'lime', this.description, @JsonKey(name: 'is_archived') this.isArchived = false}): super._();
  factory _Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'duration_value') final  int durationValue;
@override@JsonKey(name: 'duration_unit') final  String durationUnit;
@override@JsonKey(name: 'price_paise') final  int pricePaise;
@override@JsonKey(name: 'joining_fee_paise') final  int joiningFeePaise;
@override@JsonKey(name: 'gst_rate') final  num gstRate;
@override@JsonKey(name: 'includes_pt') final  bool includesPt;
@override@JsonKey(name: 'sessions_limit') final  int? sessionsLimit;
@override@JsonKey(name: 'freeze_days_allowed') final  int freezeDaysAllowed;
@override@JsonKey() final  String color;
@override final  String? description;
@override@JsonKey(name: 'is_archived') final  bool isArchived;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanCopyWith<_Plan> get copyWith => __$PlanCopyWithImpl<_Plan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plan&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.durationValue, durationValue) || other.durationValue == durationValue)&&(identical(other.durationUnit, durationUnit) || other.durationUnit == durationUnit)&&(identical(other.pricePaise, pricePaise) || other.pricePaise == pricePaise)&&(identical(other.joiningFeePaise, joiningFeePaise) || other.joiningFeePaise == joiningFeePaise)&&(identical(other.gstRate, gstRate) || other.gstRate == gstRate)&&(identical(other.includesPt, includesPt) || other.includesPt == includesPt)&&(identical(other.sessionsLimit, sessionsLimit) || other.sessionsLimit == sessionsLimit)&&(identical(other.freezeDaysAllowed, freezeDaysAllowed) || other.freezeDaysAllowed == freezeDaysAllowed)&&(identical(other.color, color) || other.color == color)&&(identical(other.description, description) || other.description == description)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,durationValue,durationUnit,pricePaise,joiningFeePaise,gstRate,includesPt,sessionsLimit,freezeDaysAllowed,color,description,isArchived);
}

@override
String toString() {
    return 'Plan(id: $id, name: $name, durationValue: $durationValue, durationUnit: $durationUnit, pricePaise: $pricePaise, joiningFeePaise: $joiningFeePaise, gstRate: $gstRate, includesPt: $includesPt, sessionsLimit: $sessionsLimit, freezeDaysAllowed: $freezeDaysAllowed, color: $color, description: $description, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class _$PlanCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$PlanCopyWith(_Plan value, $Res Function(_Plan) _then) = __$PlanCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'duration_value') int durationValue,@JsonKey(name: 'duration_unit') String durationUnit,@JsonKey(name: 'price_paise') int pricePaise,@JsonKey(name: 'joining_fee_paise') int joiningFeePaise,@JsonKey(name: 'gst_rate') num gstRate,@JsonKey(name: 'includes_pt') bool includesPt,@JsonKey(name: 'sessions_limit') int? sessionsLimit,@JsonKey(name: 'freeze_days_allowed') int freezeDaysAllowed, String color, String? description,@JsonKey(name: 'is_archived') bool isArchived
});




}
/// @nodoc
class __$PlanCopyWithImpl<$Res>
    implements _$PlanCopyWith<$Res> {
  __$PlanCopyWithImpl(this._self, this._then);

  final _Plan _self;
  final $Res Function(_Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? durationValue = null,Object? durationUnit = null,Object? pricePaise = null,Object? joiningFeePaise = null,Object? gstRate = null,Object? includesPt = null,Object? sessionsLimit = freezed,Object? freezeDaysAllowed = null,Object? color = null,Object? description = freezed,Object? isArchived = null,}) {
  return _then(_Plan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationValue: null == durationValue ? _self.durationValue : durationValue // ignore: cast_nullable_to_non_nullable
as int,durationUnit: null == durationUnit ? _self.durationUnit : durationUnit // ignore: cast_nullable_to_non_nullable
as String,pricePaise: null == pricePaise ? _self.pricePaise : pricePaise // ignore: cast_nullable_to_non_nullable
as int,joiningFeePaise: null == joiningFeePaise ? _self.joiningFeePaise : joiningFeePaise // ignore: cast_nullable_to_non_nullable
as int,gstRate: null == gstRate ? _self.gstRate : gstRate // ignore: cast_nullable_to_non_nullable
as num,includesPt: null == includesPt ? _self.includesPt : includesPt // ignore: cast_nullable_to_non_nullable
as bool,sessionsLimit: freezed == sessionsLimit ? _self.sessionsLimit : sessionsLimit // ignore: cast_nullable_to_non_nullable
as int?,freezeDaysAllowed: null == freezeDaysAllowed ? _self.freezeDaysAllowed : freezeDaysAllowed // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Addon {

 String get id; String get name;@JsonKey(name: 'price_paise') int get pricePaise; String get kind;@JsonKey(name: 'is_archived') bool get isArchived;
/// Create a copy of Addon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddonCopyWith<Addon> get copyWith => _$AddonCopyWithImpl<Addon>(this as Addon, _$identity);

  /// Serializes this Addon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Addon;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Addon&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.pricePaise, _this.pricePaise) || other.pricePaise == _this.pricePaise)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Addon;
  return Object.hash(runtimeType,_this.id,_this.name,_this.pricePaise,_this.kind,_this.isArchived);
}

@override
String toString() {
  final _this = this as Addon;
  return 'Addon(id: ${_this.id}, name: ${_this.name}, pricePaise: ${_this.pricePaise}, kind: ${_this.kind}, isArchived: ${_this.isArchived})';
}


}

/// @nodoc
abstract mixin class $AddonCopyWith<$Res>  {
  factory $AddonCopyWith(Addon value, $Res Function(Addon) _then) = _$AddonCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'price_paise') int pricePaise, String kind,@JsonKey(name: 'is_archived') bool isArchived
});




}
/// @nodoc
class _$AddonCopyWithImpl<$Res>
    implements $AddonCopyWith<$Res> {
  _$AddonCopyWithImpl(this._self, this._then);

  final Addon _self;
  final $Res Function(Addon) _then;

/// Create a copy of Addon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pricePaise = null,Object? kind = null,Object? isArchived = null,}) {
  return _then(Addon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pricePaise: null == pricePaise ? _self.pricePaise : pricePaise // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Addon].
extension AddonPatterns on Addon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Addon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Addon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Addon value)  $default,){
final _that = this;
switch (_that) {
case _Addon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Addon value)?  $default,){
final _that = this;
switch (_that) {
case _Addon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'price_paise')  int pricePaise,  String kind, @JsonKey(name: 'is_archived')  bool isArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Addon() when $default != null:
return $default(_that.id,_that.name,_that.pricePaise,_that.kind,_that.isArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'price_paise')  int pricePaise,  String kind, @JsonKey(name: 'is_archived')  bool isArchived)  $default,) {final _that = this;
switch (_that) {
case _Addon():
return $default(_that.id,_that.name,_that.pricePaise,_that.kind,_that.isArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'price_paise')  int pricePaise,  String kind, @JsonKey(name: 'is_archived')  bool isArchived)?  $default,) {final _that = this;
switch (_that) {
case _Addon() when $default != null:
return $default(_that.id,_that.name,_that.pricePaise,_that.kind,_that.isArchived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Addon implements Addon {
  const _Addon({required this.id, required this.name, @JsonKey(name: 'price_paise') required this.pricePaise, this.kind = 'other', @JsonKey(name: 'is_archived') this.isArchived = false});
  factory _Addon.fromJson(Map<String, dynamic> json) => _$AddonFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'price_paise') final  int pricePaise;
@override@JsonKey() final  String kind;
@override@JsonKey(name: 'is_archived') final  bool isArchived;

/// Create a copy of Addon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddonCopyWith<_Addon> get copyWith => __$AddonCopyWithImpl<_Addon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Addon&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pricePaise, pricePaise) || other.pricePaise == pricePaise)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,pricePaise,kind,isArchived);
}

@override
String toString() {
    return 'Addon(id: $id, name: $name, pricePaise: $pricePaise, kind: $kind, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class _$AddonCopyWith<$Res> implements $AddonCopyWith<$Res> {
  factory _$AddonCopyWith(_Addon value, $Res Function(_Addon) _then) = __$AddonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'price_paise') int pricePaise, String kind,@JsonKey(name: 'is_archived') bool isArchived
});




}
/// @nodoc
class __$AddonCopyWithImpl<$Res>
    implements _$AddonCopyWith<$Res> {
  __$AddonCopyWithImpl(this._self, this._then);

  final _Addon _self;
  final $Res Function(_Addon) _then;

/// Create a copy of Addon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pricePaise = null,Object? kind = null,Object? isArchived = null,}) {
  return _then(_Addon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pricePaise: null == pricePaise ? _self.pricePaise : pricePaise // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MembershipFreeze {

 String get id;@JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut) DateTime? get fromDate;@JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut) DateTime? get toDate; String? get reason;
/// Create a copy of MembershipFreeze
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipFreezeCopyWith<MembershipFreeze> get copyWith => _$MembershipFreezeCopyWithImpl<MembershipFreeze>(this as MembershipFreeze, _$identity);

  /// Serializes this MembershipFreeze to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MembershipFreeze;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipFreeze&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fromDate, _this.fromDate) || other.fromDate == _this.fromDate)&&(identical(other.toDate, _this.toDate) || other.toDate == _this.toDate)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MembershipFreeze;
  return Object.hash(runtimeType,_this.id,_this.fromDate,_this.toDate,_this.reason);
}

@override
String toString() {
  final _this = this as MembershipFreeze;
  return 'MembershipFreeze(id: ${_this.id}, fromDate: ${_this.fromDate}, toDate: ${_this.toDate}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $MembershipFreezeCopyWith<$Res>  {
  factory $MembershipFreezeCopyWith(MembershipFreeze value, $Res Function(MembershipFreeze) _then) = _$MembershipFreezeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut) DateTime? fromDate,@JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut) DateTime? toDate, String? reason
});




}
/// @nodoc
class _$MembershipFreezeCopyWithImpl<$Res>
    implements $MembershipFreezeCopyWith<$Res> {
  _$MembershipFreezeCopyWithImpl(this._self, this._then);

  final MembershipFreeze _self;
  final $Res Function(MembershipFreeze) _then;

/// Create a copy of MembershipFreeze
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromDate = freezed,Object? toDate = freezed,Object? reason = freezed,}) {
  return _then(MembershipFreeze(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipFreeze].
extension MembershipFreezePatterns on MembershipFreeze {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipFreeze value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipFreeze() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipFreeze value)  $default,){
final _that = this;
switch (_that) {
case _MembershipFreeze():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipFreeze value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipFreeze() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut)  DateTime? fromDate, @JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut)  DateTime? toDate,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipFreeze() when $default != null:
return $default(_that.id,_that.fromDate,_that.toDate,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut)  DateTime? fromDate, @JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut)  DateTime? toDate,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _MembershipFreeze():
return $default(_that.id,_that.fromDate,_that.toDate,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut)  DateTime? fromDate, @JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut)  DateTime? toDate,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _MembershipFreeze() when $default != null:
return $default(_that.id,_that.fromDate,_that.toDate,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MembershipFreeze implements MembershipFreeze {
  const _MembershipFreeze({required this.id, @JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut) required this.fromDate, @JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut) required this.toDate, this.reason});
  factory _MembershipFreeze.fromJson(Map<String, dynamic> json) => _$MembershipFreezeFromJson(json);

@override final  String id;
@override@JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut) final  DateTime? fromDate;
@override@JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut) final  DateTime? toDate;
@override final  String? reason;

/// Create a copy of MembershipFreeze
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipFreezeCopyWith<_MembershipFreeze> get copyWith => __$MembershipFreezeCopyWithImpl<_MembershipFreeze>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipFreezeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipFreeze&&(identical(other.id, id) || other.id == id)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fromDate,toDate,reason);
}

@override
String toString() {
    return 'MembershipFreeze(id: $id, fromDate: $fromDate, toDate: $toDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$MembershipFreezeCopyWith<$Res> implements $MembershipFreezeCopyWith<$Res> {
  factory _$MembershipFreezeCopyWith(_MembershipFreeze value, $Res Function(_MembershipFreeze) _then) = __$MembershipFreezeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut) DateTime? fromDate,@JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut) DateTime? toDate, String? reason
});




}
/// @nodoc
class __$MembershipFreezeCopyWithImpl<$Res>
    implements _$MembershipFreezeCopyWith<$Res> {
  __$MembershipFreezeCopyWithImpl(this._self, this._then);

  final _MembershipFreeze _self;
  final $Res Function(_MembershipFreeze) _then;

/// Create a copy of MembershipFreeze
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromDate = freezed,Object? toDate = freezed,Object? reason = freezed,}) {
  return _then(_MembershipFreeze(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Membership {

 String get id;@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'plan_id') String get planId;@JsonKey(name: 'plan_name') String get planName;@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? get startDate;@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? get endDate;@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus get status;@JsonKey(name: 'price_paise') int get pricePaise;@JsonKey(name: 'joining_fee_paise') int get joiningFeePaise;@JsonKey(name: 'addons_paise') int get addonsPaise;@JsonKey(name: 'discount_paise') int get discountPaise;@JsonKey(name: 'discount_reason') String? get discountReason;@JsonKey(name: 'freeze_days_used') int get freezeDaysUsed; String get source;@JsonKey(name: 'cancelled_reason') String? get cancelledReason;@JsonKey(name: 'membership_freezes') List<MembershipFreeze> get freezes;
/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipCopyWith<Membership> get copyWith => _$MembershipCopyWithImpl<Membership>(this as Membership, _$identity);

  /// Serializes this Membership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Membership;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Membership&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.planId, _this.planId) || other.planId == _this.planId)&&(identical(other.planName, _this.planName) || other.planName == _this.planName)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.pricePaise, _this.pricePaise) || other.pricePaise == _this.pricePaise)&&(identical(other.joiningFeePaise, _this.joiningFeePaise) || other.joiningFeePaise == _this.joiningFeePaise)&&(identical(other.addonsPaise, _this.addonsPaise) || other.addonsPaise == _this.addonsPaise)&&(identical(other.discountPaise, _this.discountPaise) || other.discountPaise == _this.discountPaise)&&(identical(other.discountReason, _this.discountReason) || other.discountReason == _this.discountReason)&&(identical(other.freezeDaysUsed, _this.freezeDaysUsed) || other.freezeDaysUsed == _this.freezeDaysUsed)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.cancelledReason, _this.cancelledReason) || other.cancelledReason == _this.cancelledReason)&&const DeepCollectionEquality().equals(other.freezes, _this.freezes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Membership;
  return Object.hash(runtimeType,_this.id,_this.memberId,_this.planId,_this.planName,_this.startDate,_this.endDate,_this.status,_this.pricePaise,_this.joiningFeePaise,_this.addonsPaise,_this.discountPaise,_this.discountReason,_this.freezeDaysUsed,_this.source,_this.cancelledReason,const DeepCollectionEquality().hash(_this.freezes));
}

@override
String toString() {
  final _this = this as Membership;
  return 'Membership(id: ${_this.id}, memberId: ${_this.memberId}, planId: ${_this.planId}, planName: ${_this.planName}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, status: ${_this.status}, pricePaise: ${_this.pricePaise}, joiningFeePaise: ${_this.joiningFeePaise}, addonsPaise: ${_this.addonsPaise}, discountPaise: ${_this.discountPaise}, discountReason: ${_this.discountReason}, freezeDaysUsed: ${_this.freezeDaysUsed}, source: ${_this.source}, cancelledReason: ${_this.cancelledReason}, freezes: ${_this.freezes})';
}


}

/// @nodoc
abstract mixin class $MembershipCopyWith<$Res>  {
  factory $MembershipCopyWith(Membership value, $Res Function(Membership) _then) = _$MembershipCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'plan_id') String planId,@JsonKey(name: 'plan_name') String planName,@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? startDate,@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? endDate,@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus status,@JsonKey(name: 'price_paise') int pricePaise,@JsonKey(name: 'joining_fee_paise') int joiningFeePaise,@JsonKey(name: 'addons_paise') int addonsPaise,@JsonKey(name: 'discount_paise') int discountPaise,@JsonKey(name: 'discount_reason') String? discountReason,@JsonKey(name: 'freeze_days_used') int freezeDaysUsed, String source,@JsonKey(name: 'cancelled_reason') String? cancelledReason,@JsonKey(name: 'membership_freezes') List<MembershipFreeze> freezes
});




}
/// @nodoc
class _$MembershipCopyWithImpl<$Res>
    implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._self, this._then);

  final Membership _self;
  final $Res Function(Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? planId = null,Object? planName = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? pricePaise = null,Object? joiningFeePaise = null,Object? addonsPaise = null,Object? discountPaise = null,Object? discountReason = freezed,Object? freezeDaysUsed = null,Object? source = null,Object? cancelledReason = freezed,Object? freezes = null,}) {
  return _then(Membership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,planName: null == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,pricePaise: null == pricePaise ? _self.pricePaise : pricePaise // ignore: cast_nullable_to_non_nullable
as int,joiningFeePaise: null == joiningFeePaise ? _self.joiningFeePaise : joiningFeePaise // ignore: cast_nullable_to_non_nullable
as int,addonsPaise: null == addonsPaise ? _self.addonsPaise : addonsPaise // ignore: cast_nullable_to_non_nullable
as int,discountPaise: null == discountPaise ? _self.discountPaise : discountPaise // ignore: cast_nullable_to_non_nullable
as int,discountReason: freezed == discountReason ? _self.discountReason : discountReason // ignore: cast_nullable_to_non_nullable
as String?,freezeDaysUsed: null == freezeDaysUsed ? _self.freezeDaysUsed : freezeDaysUsed // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,cancelledReason: freezed == cancelledReason ? _self.cancelledReason : cancelledReason // ignore: cast_nullable_to_non_nullable
as String?,freezes: null == freezes ? _self.freezes : freezes // ignore: cast_nullable_to_non_nullable
as List<MembershipFreeze>,
  ));
}

}


/// Adds pattern-matching-related methods to [Membership].
extension MembershipPatterns on Membership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Membership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Membership value)  $default,){
final _that = this;
switch (_that) {
case _Membership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Membership value)?  $default,){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'plan_id')  String planId, @JsonKey(name: 'plan_name')  String planName, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'price_paise')  int pricePaise, @JsonKey(name: 'joining_fee_paise')  int joiningFeePaise, @JsonKey(name: 'addons_paise')  int addonsPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'discount_reason')  String? discountReason, @JsonKey(name: 'freeze_days_used')  int freezeDaysUsed,  String source, @JsonKey(name: 'cancelled_reason')  String? cancelledReason, @JsonKey(name: 'membership_freezes')  List<MembershipFreeze> freezes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.id,_that.memberId,_that.planId,_that.planName,_that.startDate,_that.endDate,_that.status,_that.pricePaise,_that.joiningFeePaise,_that.addonsPaise,_that.discountPaise,_that.discountReason,_that.freezeDaysUsed,_that.source,_that.cancelledReason,_that.freezes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'plan_id')  String planId, @JsonKey(name: 'plan_name')  String planName, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'price_paise')  int pricePaise, @JsonKey(name: 'joining_fee_paise')  int joiningFeePaise, @JsonKey(name: 'addons_paise')  int addonsPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'discount_reason')  String? discountReason, @JsonKey(name: 'freeze_days_used')  int freezeDaysUsed,  String source, @JsonKey(name: 'cancelled_reason')  String? cancelledReason, @JsonKey(name: 'membership_freezes')  List<MembershipFreeze> freezes)  $default,) {final _that = this;
switch (_that) {
case _Membership():
return $default(_that.id,_that.memberId,_that.planId,_that.planName,_that.startDate,_that.endDate,_that.status,_that.pricePaise,_that.joiningFeePaise,_that.addonsPaise,_that.discountPaise,_that.discountReason,_that.freezeDaysUsed,_that.source,_that.cancelledReason,_that.freezes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'plan_id')  String planId, @JsonKey(name: 'plan_name')  String planName, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'price_paise')  int pricePaise, @JsonKey(name: 'joining_fee_paise')  int joiningFeePaise, @JsonKey(name: 'addons_paise')  int addonsPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'discount_reason')  String? discountReason, @JsonKey(name: 'freeze_days_used')  int freezeDaysUsed,  String source, @JsonKey(name: 'cancelled_reason')  String? cancelledReason, @JsonKey(name: 'membership_freezes')  List<MembershipFreeze> freezes)?  $default,) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.id,_that.memberId,_that.planId,_that.planName,_that.startDate,_that.endDate,_that.status,_that.pricePaise,_that.joiningFeePaise,_that.addonsPaise,_that.discountPaise,_that.discountReason,_that.freezeDaysUsed,_that.source,_that.cancelledReason,_that.freezes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Membership extends Membership {
  const _Membership({required this.id, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'plan_id') required this.planId, @JsonKey(name: 'plan_name') required this.planName, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) required this.startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) required this.endDate, @JsonKey(fromJson: _status, toJson: _statusOut) this.status = MemberStatus.active, @JsonKey(name: 'price_paise') this.pricePaise = 0, @JsonKey(name: 'joining_fee_paise') this.joiningFeePaise = 0, @JsonKey(name: 'addons_paise') this.addonsPaise = 0, @JsonKey(name: 'discount_paise') this.discountPaise = 0, @JsonKey(name: 'discount_reason') this.discountReason, @JsonKey(name: 'freeze_days_used') this.freezeDaysUsed = 0, this.source = 'new', @JsonKey(name: 'cancelled_reason') this.cancelledReason, @JsonKey(name: 'membership_freezes')  List<MembershipFreeze> freezes = const []}): _freezes = freezes,super._();
  factory _Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

@override final  String id;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'plan_id') final  String planId;
@override@JsonKey(name: 'plan_name') final  String planName;
@override@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) final  DateTime? startDate;
@override@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) final  DateTime? endDate;
@override@JsonKey(fromJson: _status, toJson: _statusOut) final  MemberStatus status;
@override@JsonKey(name: 'price_paise') final  int pricePaise;
@override@JsonKey(name: 'joining_fee_paise') final  int joiningFeePaise;
@override@JsonKey(name: 'addons_paise') final  int addonsPaise;
@override@JsonKey(name: 'discount_paise') final  int discountPaise;
@override@JsonKey(name: 'discount_reason') final  String? discountReason;
@override@JsonKey(name: 'freeze_days_used') final  int freezeDaysUsed;
@override@JsonKey() final  String source;
@override@JsonKey(name: 'cancelled_reason') final  String? cancelledReason;
 final  List<MembershipFreeze> _freezes;
@override@JsonKey(name: 'membership_freezes') List<MembershipFreeze> get freezes {
  if (_freezes is EqualUnmodifiableListView) return _freezes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_freezes);
}


/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipCopyWith<_Membership> get copyWith => __$MembershipCopyWithImpl<_Membership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Membership&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.pricePaise, pricePaise) || other.pricePaise == pricePaise)&&(identical(other.joiningFeePaise, joiningFeePaise) || other.joiningFeePaise == joiningFeePaise)&&(identical(other.addonsPaise, addonsPaise) || other.addonsPaise == addonsPaise)&&(identical(other.discountPaise, discountPaise) || other.discountPaise == discountPaise)&&(identical(other.discountReason, discountReason) || other.discountReason == discountReason)&&(identical(other.freezeDaysUsed, freezeDaysUsed) || other.freezeDaysUsed == freezeDaysUsed)&&(identical(other.source, source) || other.source == source)&&(identical(other.cancelledReason, cancelledReason) || other.cancelledReason == cancelledReason)&&const DeepCollectionEquality().equals(other.freezes, _freezes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,memberId,planId,planName,startDate,endDate,status,pricePaise,joiningFeePaise,addonsPaise,discountPaise,discountReason,freezeDaysUsed,source,cancelledReason,const DeepCollectionEquality().hash(_freezes));
}

@override
String toString() {
    return 'Membership(id: $id, memberId: $memberId, planId: $planId, planName: $planName, startDate: $startDate, endDate: $endDate, status: $status, pricePaise: $pricePaise, joiningFeePaise: $joiningFeePaise, addonsPaise: $addonsPaise, discountPaise: $discountPaise, discountReason: $discountReason, freezeDaysUsed: $freezeDaysUsed, source: $source, cancelledReason: $cancelledReason, freezes: $freezes)';
}


}

/// @nodoc
abstract mixin class _$MembershipCopyWith<$Res> implements $MembershipCopyWith<$Res> {
  factory _$MembershipCopyWith(_Membership value, $Res Function(_Membership) _then) = __$MembershipCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'plan_id') String planId,@JsonKey(name: 'plan_name') String planName,@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? startDate,@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? endDate,@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus status,@JsonKey(name: 'price_paise') int pricePaise,@JsonKey(name: 'joining_fee_paise') int joiningFeePaise,@JsonKey(name: 'addons_paise') int addonsPaise,@JsonKey(name: 'discount_paise') int discountPaise,@JsonKey(name: 'discount_reason') String? discountReason,@JsonKey(name: 'freeze_days_used') int freezeDaysUsed, String source,@JsonKey(name: 'cancelled_reason') String? cancelledReason,@JsonKey(name: 'membership_freezes') List<MembershipFreeze> freezes
});




}
/// @nodoc
class __$MembershipCopyWithImpl<$Res>
    implements _$MembershipCopyWith<$Res> {
  __$MembershipCopyWithImpl(this._self, this._then);

  final _Membership _self;
  final $Res Function(_Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? planId = null,Object? planName = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? pricePaise = null,Object? joiningFeePaise = null,Object? addonsPaise = null,Object? discountPaise = null,Object? discountReason = freezed,Object? freezeDaysUsed = null,Object? source = null,Object? cancelledReason = freezed,Object? freezes = null,}) {
  return _then(_Membership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,planName: null == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,pricePaise: null == pricePaise ? _self.pricePaise : pricePaise // ignore: cast_nullable_to_non_nullable
as int,joiningFeePaise: null == joiningFeePaise ? _self.joiningFeePaise : joiningFeePaise // ignore: cast_nullable_to_non_nullable
as int,addonsPaise: null == addonsPaise ? _self.addonsPaise : addonsPaise // ignore: cast_nullable_to_non_nullable
as int,discountPaise: null == discountPaise ? _self.discountPaise : discountPaise // ignore: cast_nullable_to_non_nullable
as int,discountReason: freezed == discountReason ? _self.discountReason : discountReason // ignore: cast_nullable_to_non_nullable
as String?,freezeDaysUsed: null == freezeDaysUsed ? _self.freezeDaysUsed : freezeDaysUsed // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,cancelledReason: freezed == cancelledReason ? _self.cancelledReason : cancelledReason // ignore: cast_nullable_to_non_nullable
as String?,freezes: null == freezes ? _self._freezes : freezes // ignore: cast_nullable_to_non_nullable
as List<MembershipFreeze>,
  ));
}


}


/// @nodoc
mixin _$MemberHealth {

@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'height_cm') num? get heightCm;@JsonKey(name: 'weight_kg') num? get weightKg; String? get conditions; String? get injuries; String? get medications; Map<String, dynamic> get parq;@JsonKey(name: 'doctor_clearance') bool get doctorClearance;
/// Create a copy of MemberHealth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberHealthCopyWith<MemberHealth> get copyWith => _$MemberHealthCopyWithImpl<MemberHealth>(this as MemberHealth, _$identity);

  /// Serializes this MemberHealth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemberHealth;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberHealth&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.conditions, _this.conditions) || other.conditions == _this.conditions)&&(identical(other.injuries, _this.injuries) || other.injuries == _this.injuries)&&(identical(other.medications, _this.medications) || other.medications == _this.medications)&&const DeepCollectionEquality().equals(other.parq, _this.parq)&&(identical(other.doctorClearance, _this.doctorClearance) || other.doctorClearance == _this.doctorClearance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemberHealth;
  return Object.hash(runtimeType,_this.memberId,_this.heightCm,_this.weightKg,_this.conditions,_this.injuries,_this.medications,const DeepCollectionEquality().hash(_this.parq),_this.doctorClearance);
}

@override
String toString() {
  final _this = this as MemberHealth;
  return 'MemberHealth(memberId: ${_this.memberId}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg}, conditions: ${_this.conditions}, injuries: ${_this.injuries}, medications: ${_this.medications}, parq: ${_this.parq}, doctorClearance: ${_this.doctorClearance})';
}


}

/// @nodoc
abstract mixin class $MemberHealthCopyWith<$Res>  {
  factory $MemberHealthCopyWith(MemberHealth value, $Res Function(MemberHealth) _then) = _$MemberHealthCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'height_cm') num? heightCm,@JsonKey(name: 'weight_kg') num? weightKg, String? conditions, String? injuries, String? medications, Map<String, dynamic> parq,@JsonKey(name: 'doctor_clearance') bool doctorClearance
});




}
/// @nodoc
class _$MemberHealthCopyWithImpl<$Res>
    implements $MemberHealthCopyWith<$Res> {
  _$MemberHealthCopyWithImpl(this._self, this._then);

  final MemberHealth _self;
  final $Res Function(MemberHealth) _then;

/// Create a copy of MemberHealth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? heightCm = freezed,Object? weightKg = freezed,Object? conditions = freezed,Object? injuries = freezed,Object? medications = freezed,Object? parq = null,Object? doctorClearance = null,}) {
  return _then(MemberHealth(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as num?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as num?,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,injuries: freezed == injuries ? _self.injuries : injuries // ignore: cast_nullable_to_non_nullable
as String?,medications: freezed == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as String?,parq: null == parq ? _self.parq : parq // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,doctorClearance: null == doctorClearance ? _self.doctorClearance : doctorClearance // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberHealth].
extension MemberHealthPatterns on MemberHealth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberHealth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberHealth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberHealth value)  $default,){
final _that = this;
switch (_that) {
case _MemberHealth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberHealth value)?  $default,){
final _that = this;
switch (_that) {
case _MemberHealth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'height_cm')  num? heightCm, @JsonKey(name: 'weight_kg')  num? weightKg,  String? conditions,  String? injuries,  String? medications,  Map<String, dynamic> parq, @JsonKey(name: 'doctor_clearance')  bool doctorClearance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberHealth() when $default != null:
return $default(_that.memberId,_that.heightCm,_that.weightKg,_that.conditions,_that.injuries,_that.medications,_that.parq,_that.doctorClearance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'height_cm')  num? heightCm, @JsonKey(name: 'weight_kg')  num? weightKg,  String? conditions,  String? injuries,  String? medications,  Map<String, dynamic> parq, @JsonKey(name: 'doctor_clearance')  bool doctorClearance)  $default,) {final _that = this;
switch (_that) {
case _MemberHealth():
return $default(_that.memberId,_that.heightCm,_that.weightKg,_that.conditions,_that.injuries,_that.medications,_that.parq,_that.doctorClearance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'height_cm')  num? heightCm, @JsonKey(name: 'weight_kg')  num? weightKg,  String? conditions,  String? injuries,  String? medications,  Map<String, dynamic> parq, @JsonKey(name: 'doctor_clearance')  bool doctorClearance)?  $default,) {final _that = this;
switch (_that) {
case _MemberHealth() when $default != null:
return $default(_that.memberId,_that.heightCm,_that.weightKg,_that.conditions,_that.injuries,_that.medications,_that.parq,_that.doctorClearance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberHealth implements MemberHealth {
  const _MemberHealth({@JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'height_cm') this.heightCm, @JsonKey(name: 'weight_kg') this.weightKg, this.conditions, this.injuries, this.medications,  Map<String, dynamic> parq = const <String, dynamic>{}, @JsonKey(name: 'doctor_clearance') this.doctorClearance = false}): _parq = parq;
  factory _MemberHealth.fromJson(Map<String, dynamic> json) => _$MemberHealthFromJson(json);

@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'height_cm') final  num? heightCm;
@override@JsonKey(name: 'weight_kg') final  num? weightKg;
@override final  String? conditions;
@override final  String? injuries;
@override final  String? medications;
 final  Map<String, dynamic> _parq;
@override@JsonKey() Map<String, dynamic> get parq {
  if (_parq is EqualUnmodifiableMapView) return _parq;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parq);
}

@override@JsonKey(name: 'doctor_clearance') final  bool doctorClearance;

/// Create a copy of MemberHealth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberHealthCopyWith<_MemberHealth> get copyWith => __$MemberHealthCopyWithImpl<_MemberHealth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberHealthToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberHealth&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.injuries, injuries) || other.injuries == injuries)&&(identical(other.medications, medications) || other.medications == medications)&&const DeepCollectionEquality().equals(other.parq, _parq)&&(identical(other.doctorClearance, doctorClearance) || other.doctorClearance == doctorClearance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memberId,heightCm,weightKg,conditions,injuries,medications,const DeepCollectionEquality().hash(_parq),doctorClearance);
}

@override
String toString() {
    return 'MemberHealth(memberId: $memberId, heightCm: $heightCm, weightKg: $weightKg, conditions: $conditions, injuries: $injuries, medications: $medications, parq: $parq, doctorClearance: $doctorClearance)';
}


}

/// @nodoc
abstract mixin class _$MemberHealthCopyWith<$Res> implements $MemberHealthCopyWith<$Res> {
  factory _$MemberHealthCopyWith(_MemberHealth value, $Res Function(_MemberHealth) _then) = __$MemberHealthCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'height_cm') num? heightCm,@JsonKey(name: 'weight_kg') num? weightKg, String? conditions, String? injuries, String? medications, Map<String, dynamic> parq,@JsonKey(name: 'doctor_clearance') bool doctorClearance
});




}
/// @nodoc
class __$MemberHealthCopyWithImpl<$Res>
    implements _$MemberHealthCopyWith<$Res> {
  __$MemberHealthCopyWithImpl(this._self, this._then);

  final _MemberHealth _self;
  final $Res Function(_MemberHealth) _then;

/// Create a copy of MemberHealth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? heightCm = freezed,Object? weightKg = freezed,Object? conditions = freezed,Object? injuries = freezed,Object? medications = freezed,Object? parq = null,Object? doctorClearance = null,}) {
  return _then(_MemberHealth(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as num?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as num?,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,injuries: freezed == injuries ? _self.injuries : injuries // ignore: cast_nullable_to_non_nullable
as String?,medications: freezed == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as String?,parq: null == parq ? _self._parq : parq // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,doctorClearance: null == doctorClearance ? _self.doctorClearance : doctorClearance // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Measurement {

 String? get id;@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut) DateTime? get measuredOn;@JsonKey(name: 'weight_kg') num? get weightKg;@JsonKey(name: 'body_fat') num? get bodyFat; num? get chest; num? get waist; num? get hips; num? get arms; num? get thighs; String? get notes;
/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementCopyWith<Measurement> get copyWith => _$MeasurementCopyWithImpl<Measurement>(this as Measurement, _$identity);

  /// Serializes this Measurement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Measurement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Measurement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.measuredOn, _this.measuredOn) || other.measuredOn == _this.measuredOn)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.bodyFat, _this.bodyFat) || other.bodyFat == _this.bodyFat)&&(identical(other.chest, _this.chest) || other.chest == _this.chest)&&(identical(other.waist, _this.waist) || other.waist == _this.waist)&&(identical(other.hips, _this.hips) || other.hips == _this.hips)&&(identical(other.arms, _this.arms) || other.arms == _this.arms)&&(identical(other.thighs, _this.thighs) || other.thighs == _this.thighs)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Measurement;
  return Object.hash(runtimeType,_this.id,_this.memberId,_this.measuredOn,_this.weightKg,_this.bodyFat,_this.chest,_this.waist,_this.hips,_this.arms,_this.thighs,_this.notes);
}

@override
String toString() {
  final _this = this as Measurement;
  return 'Measurement(id: ${_this.id}, memberId: ${_this.memberId}, measuredOn: ${_this.measuredOn}, weightKg: ${_this.weightKg}, bodyFat: ${_this.bodyFat}, chest: ${_this.chest}, waist: ${_this.waist}, hips: ${_this.hips}, arms: ${_this.arms}, thighs: ${_this.thighs}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $MeasurementCopyWith<$Res>  {
  factory $MeasurementCopyWith(Measurement value, $Res Function(Measurement) _then) = _$MeasurementCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut) DateTime? measuredOn,@JsonKey(name: 'weight_kg') num? weightKg,@JsonKey(name: 'body_fat') num? bodyFat, num? chest, num? waist, num? hips, num? arms, num? thighs, String? notes
});




}
/// @nodoc
class _$MeasurementCopyWithImpl<$Res>
    implements $MeasurementCopyWith<$Res> {
  _$MeasurementCopyWithImpl(this._self, this._then);

  final Measurement _self;
  final $Res Function(Measurement) _then;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? memberId = null,Object? measuredOn = freezed,Object? weightKg = freezed,Object? bodyFat = freezed,Object? chest = freezed,Object? waist = freezed,Object? hips = freezed,Object? arms = freezed,Object? thighs = freezed,Object? notes = freezed,}) {
  return _then(Measurement(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,measuredOn: freezed == measuredOn ? _self.measuredOn : measuredOn // ignore: cast_nullable_to_non_nullable
as DateTime?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as num?,bodyFat: freezed == bodyFat ? _self.bodyFat : bodyFat // ignore: cast_nullable_to_non_nullable
as num?,chest: freezed == chest ? _self.chest : chest // ignore: cast_nullable_to_non_nullable
as num?,waist: freezed == waist ? _self.waist : waist // ignore: cast_nullable_to_non_nullable
as num?,hips: freezed == hips ? _self.hips : hips // ignore: cast_nullable_to_non_nullable
as num?,arms: freezed == arms ? _self.arms : arms // ignore: cast_nullable_to_non_nullable
as num?,thighs: freezed == thighs ? _self.thighs : thighs // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Measurement].
extension MeasurementPatterns on Measurement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Measurement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Measurement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Measurement value)  $default,){
final _that = this;
switch (_that) {
case _Measurement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Measurement value)?  $default,){
final _that = this;
switch (_that) {
case _Measurement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut)  DateTime? measuredOn, @JsonKey(name: 'weight_kg')  num? weightKg, @JsonKey(name: 'body_fat')  num? bodyFat,  num? chest,  num? waist,  num? hips,  num? arms,  num? thighs,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Measurement() when $default != null:
return $default(_that.id,_that.memberId,_that.measuredOn,_that.weightKg,_that.bodyFat,_that.chest,_that.waist,_that.hips,_that.arms,_that.thighs,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut)  DateTime? measuredOn, @JsonKey(name: 'weight_kg')  num? weightKg, @JsonKey(name: 'body_fat')  num? bodyFat,  num? chest,  num? waist,  num? hips,  num? arms,  num? thighs,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Measurement():
return $default(_that.id,_that.memberId,_that.measuredOn,_that.weightKg,_that.bodyFat,_that.chest,_that.waist,_that.hips,_that.arms,_that.thighs,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut)  DateTime? measuredOn, @JsonKey(name: 'weight_kg')  num? weightKg, @JsonKey(name: 'body_fat')  num? bodyFat,  num? chest,  num? waist,  num? hips,  num? arms,  num? thighs,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Measurement() when $default != null:
return $default(_that.id,_that.memberId,_that.measuredOn,_that.weightKg,_that.bodyFat,_that.chest,_that.waist,_that.hips,_that.arms,_that.thighs,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Measurement implements Measurement {
  const _Measurement({this.id, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut) required this.measuredOn, @JsonKey(name: 'weight_kg') this.weightKg, @JsonKey(name: 'body_fat') this.bodyFat, this.chest, this.waist, this.hips, this.arms, this.thighs, this.notes});
  factory _Measurement.fromJson(Map<String, dynamic> json) => _$MeasurementFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut) final  DateTime? measuredOn;
@override@JsonKey(name: 'weight_kg') final  num? weightKg;
@override@JsonKey(name: 'body_fat') final  num? bodyFat;
@override final  num? chest;
@override final  num? waist;
@override final  num? hips;
@override final  num? arms;
@override final  num? thighs;
@override final  String? notes;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementCopyWith<_Measurement> get copyWith => __$MeasurementCopyWithImpl<_Measurement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeasurementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Measurement&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.measuredOn, measuredOn) || other.measuredOn == measuredOn)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.bodyFat, bodyFat) || other.bodyFat == bodyFat)&&(identical(other.chest, chest) || other.chest == chest)&&(identical(other.waist, waist) || other.waist == waist)&&(identical(other.hips, hips) || other.hips == hips)&&(identical(other.arms, arms) || other.arms == arms)&&(identical(other.thighs, thighs) || other.thighs == thighs)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,memberId,measuredOn,weightKg,bodyFat,chest,waist,hips,arms,thighs,notes);
}

@override
String toString() {
    return 'Measurement(id: $id, memberId: $memberId, measuredOn: $measuredOn, weightKg: $weightKg, bodyFat: $bodyFat, chest: $chest, waist: $waist, hips: $hips, arms: $arms, thighs: $thighs, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$MeasurementCopyWith<$Res> implements $MeasurementCopyWith<$Res> {
  factory _$MeasurementCopyWith(_Measurement value, $Res Function(_Measurement) _then) = __$MeasurementCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut) DateTime? measuredOn,@JsonKey(name: 'weight_kg') num? weightKg,@JsonKey(name: 'body_fat') num? bodyFat, num? chest, num? waist, num? hips, num? arms, num? thighs, String? notes
});




}
/// @nodoc
class __$MeasurementCopyWithImpl<$Res>
    implements _$MeasurementCopyWith<$Res> {
  __$MeasurementCopyWithImpl(this._self, this._then);

  final _Measurement _self;
  final $Res Function(_Measurement) _then;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? memberId = null,Object? measuredOn = freezed,Object? weightKg = freezed,Object? bodyFat = freezed,Object? chest = freezed,Object? waist = freezed,Object? hips = freezed,Object? arms = freezed,Object? thighs = freezed,Object? notes = freezed,}) {
  return _then(_Measurement(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,measuredOn: freezed == measuredOn ? _self.measuredOn : measuredOn // ignore: cast_nullable_to_non_nullable
as DateTime?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as num?,bodyFat: freezed == bodyFat ? _self.bodyFat : bodyFat // ignore: cast_nullable_to_non_nullable
as num?,chest: freezed == chest ? _self.chest : chest // ignore: cast_nullable_to_non_nullable
as num?,waist: freezed == waist ? _self.waist : waist // ignore: cast_nullable_to_non_nullable
as num?,hips: freezed == hips ? _self.hips : hips // ignore: cast_nullable_to_non_nullable
as num?,arms: freezed == arms ? _self.arms : arms // ignore: cast_nullable_to_non_nullable
as num?,thighs: freezed == thighs ? _self.thighs : thighs // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Attendance {

 String get id;@JsonKey(name: 'member_id') String get memberId;@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day;@JsonKey(name: 'checked_in_at') DateTime get checkedInAt;@JsonKey(name: 'checked_out_at') DateTime? get checkedOutAt; String get method;@JsonKey(includeToJson: false) String? get memberName;
/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceCopyWith<Attendance> get copyWith => _$AttendanceCopyWithImpl<Attendance>(this as Attendance, _$identity);

  /// Serializes this Attendance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Attendance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attendance&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt)&&(identical(other.checkedOutAt, _this.checkedOutAt) || other.checkedOutAt == _this.checkedOutAt)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Attendance;
  return Object.hash(runtimeType,_this.id,_this.memberId,_this.day,_this.checkedInAt,_this.checkedOutAt,_this.method,_this.memberName);
}

@override
String toString() {
  final _this = this as Attendance;
  return 'Attendance(id: ${_this.id}, memberId: ${_this.memberId}, day: ${_this.day}, checkedInAt: ${_this.checkedInAt}, checkedOutAt: ${_this.checkedOutAt}, method: ${_this.method}, memberName: ${_this.memberName})';
}


}

/// @nodoc
abstract mixin class $AttendanceCopyWith<$Res>  {
  factory $AttendanceCopyWith(Attendance value, $Res Function(Attendance) _then) = _$AttendanceCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'checked_in_at') DateTime checkedInAt,@JsonKey(name: 'checked_out_at') DateTime? checkedOutAt, String method,@JsonKey(includeToJson: false) String? memberName
});




}
/// @nodoc
class _$AttendanceCopyWithImpl<$Res>
    implements $AttendanceCopyWith<$Res> {
  _$AttendanceCopyWithImpl(this._self, this._then);

  final Attendance _self;
  final $Res Function(Attendance) _then;

/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? day = freezed,Object? checkedInAt = null,Object? checkedOutAt = freezed,Object? method = null,Object? memberName = freezed,}) {
  return _then(Attendance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedInAt: null == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,checkedOutAt: freezed == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,memberName: freezed == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Attendance].
extension AttendancePatterns on Attendance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attendance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attendance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attendance value)  $default,){
final _that = this;
switch (_that) {
case _Attendance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attendance value)?  $default,){
final _that = this;
switch (_that) {
case _Attendance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'checked_in_at')  DateTime checkedInAt, @JsonKey(name: 'checked_out_at')  DateTime? checkedOutAt,  String method, @JsonKey(includeToJson: false)  String? memberName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attendance() when $default != null:
return $default(_that.id,_that.memberId,_that.day,_that.checkedInAt,_that.checkedOutAt,_that.method,_that.memberName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'checked_in_at')  DateTime checkedInAt, @JsonKey(name: 'checked_out_at')  DateTime? checkedOutAt,  String method, @JsonKey(includeToJson: false)  String? memberName)  $default,) {final _that = this;
switch (_that) {
case _Attendance():
return $default(_that.id,_that.memberId,_that.day,_that.checkedInAt,_that.checkedOutAt,_that.method,_that.memberName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'checked_in_at')  DateTime checkedInAt, @JsonKey(name: 'checked_out_at')  DateTime? checkedOutAt,  String method, @JsonKey(includeToJson: false)  String? memberName)?  $default,) {final _that = this;
switch (_that) {
case _Attendance() when $default != null:
return $default(_that.id,_that.memberId,_that.day,_that.checkedInAt,_that.checkedOutAt,_that.method,_that.memberName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attendance implements Attendance {
  const _Attendance({required this.id, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(fromJson: _date, toJson: _dateOut) required this.day, @JsonKey(name: 'checked_in_at') required this.checkedInAt, @JsonKey(name: 'checked_out_at') this.checkedOutAt, required this.method, @JsonKey(includeToJson: false) this.memberName});
  factory _Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);

@override final  String id;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override@JsonKey(name: 'checked_in_at') final  DateTime checkedInAt;
@override@JsonKey(name: 'checked_out_at') final  DateTime? checkedOutAt;
@override final  String method;
@override@JsonKey(includeToJson: false) final  String? memberName;

/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceCopyWith<_Attendance> get copyWith => __$AttendanceCopyWithImpl<_Attendance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attendance&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.day, day) || other.day == day)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.checkedOutAt, checkedOutAt) || other.checkedOutAt == checkedOutAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.memberName, memberName) || other.memberName == memberName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,memberId,day,checkedInAt,checkedOutAt,method,memberName);
}

@override
String toString() {
    return 'Attendance(id: $id, memberId: $memberId, day: $day, checkedInAt: $checkedInAt, checkedOutAt: $checkedOutAt, method: $method, memberName: $memberName)';
}


}

/// @nodoc
abstract mixin class _$AttendanceCopyWith<$Res> implements $AttendanceCopyWith<$Res> {
  factory _$AttendanceCopyWith(_Attendance value, $Res Function(_Attendance) _then) = __$AttendanceCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'checked_in_at') DateTime checkedInAt,@JsonKey(name: 'checked_out_at') DateTime? checkedOutAt, String method,@JsonKey(includeToJson: false) String? memberName
});




}
/// @nodoc
class __$AttendanceCopyWithImpl<$Res>
    implements _$AttendanceCopyWith<$Res> {
  __$AttendanceCopyWithImpl(this._self, this._then);

  final _Attendance _self;
  final $Res Function(_Attendance) _then;

/// Create a copy of Attendance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? day = freezed,Object? checkedInAt = null,Object? checkedOutAt = freezed,Object? method = null,Object? memberName = freezed,}) {
  return _then(_Attendance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedInAt: null == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,checkedOutAt: freezed == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,memberName: freezed == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MemberEvent {

 int get id; String get kind; String get title; Map<String, dynamic> get data; DateTime get at;
/// Create a copy of MemberEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberEventCopyWith<MemberEvent> get copyWith => _$MemberEventCopyWithImpl<MemberEvent>(this as MemberEvent, _$identity);

  /// Serializes this MemberEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemberEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.at, _this.at) || other.at == _this.at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemberEvent;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.title,const DeepCollectionEquality().hash(_this.data),_this.at);
}

@override
String toString() {
  final _this = this as MemberEvent;
  return 'MemberEvent(id: ${_this.id}, kind: ${_this.kind}, title: ${_this.title}, data: ${_this.data}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $MemberEventCopyWith<$Res>  {
  factory $MemberEventCopyWith(MemberEvent value, $Res Function(MemberEvent) _then) = _$MemberEventCopyWithImpl;
@useResult
$Res call({
 int id, String kind, String title, Map<String, dynamic> data, DateTime at
});




}
/// @nodoc
class _$MemberEventCopyWithImpl<$Res>
    implements $MemberEventCopyWith<$Res> {
  _$MemberEventCopyWithImpl(this._self, this._then);

  final MemberEvent _self;
  final $Res Function(MemberEvent) _then;

/// Create a copy of MemberEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? data = null,Object? at = null,}) {
  return _then(MemberEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberEvent].
extension MemberEventPatterns on MemberEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberEvent value)  $default,){
final _that = this;
switch (_that) {
case _MemberEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberEvent value)?  $default,){
final _that = this;
switch (_that) {
case _MemberEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String kind,  String title,  Map<String, dynamic> data,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberEvent() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.data,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String kind,  String title,  Map<String, dynamic> data,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _MemberEvent():
return $default(_that.id,_that.kind,_that.title,_that.data,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String kind,  String title,  Map<String, dynamic> data,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _MemberEvent() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.data,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberEvent implements MemberEvent {
  const _MemberEvent({required this.id, required this.kind, required this.title,  Map<String, dynamic> data = const <String, dynamic>{}, required this.at}): _data = data;
  factory _MemberEvent.fromJson(Map<String, dynamic> json) => _$MemberEventFromJson(json);

@override final  int id;
@override final  String kind;
@override final  String title;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override final  DateTime at;

/// Create a copy of MemberEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberEventCopyWith<_MemberEvent> get copyWith => __$MemberEventCopyWithImpl<_MemberEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,title,const DeepCollectionEquality().hash(_data),at);
}

@override
String toString() {
    return 'MemberEvent(id: $id, kind: $kind, title: $title, data: $data, at: $at)';
}


}

/// @nodoc
abstract mixin class _$MemberEventCopyWith<$Res> implements $MemberEventCopyWith<$Res> {
  factory _$MemberEventCopyWith(_MemberEvent value, $Res Function(_MemberEvent) _then) = __$MemberEventCopyWithImpl;
@override @useResult
$Res call({
 int id, String kind, String title, Map<String, dynamic> data, DateTime at
});




}
/// @nodoc
class __$MemberEventCopyWithImpl<$Res>
    implements _$MemberEventCopyWith<$Res> {
  __$MemberEventCopyWithImpl(this._self, this._then);

  final _MemberEvent _self;
  final $Res Function(_MemberEvent) _then;

/// Create a copy of MemberEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? data = null,Object? at = null,}) {
  return _then(_MemberEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CheckInResult {

@JsonKey(name: 'member_id') String get memberId; String get name;@JsonKey(name: 'member_code') String get memberCode;@JsonKey(name: 'photo_url') String? get photoPath;@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus get status;@JsonKey(name: 'plan_name') String? get planName;@JsonKey(name: 'days_left') int? get daysLeft; bool get already;@JsonKey(name: 'checked_out_at') DateTime? get checkedOutAt;@JsonKey(name: 'dues_paise') int get duesPaise;
/// Create a copy of CheckInResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckInResultCopyWith<CheckInResult> get copyWith => _$CheckInResultCopyWithImpl<CheckInResult>(this as CheckInResult, _$identity);

  /// Serializes this CheckInResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CheckInResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckInResult&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.memberCode, _this.memberCode) || other.memberCode == _this.memberCode)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.planName, _this.planName) || other.planName == _this.planName)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft)&&(identical(other.already, _this.already) || other.already == _this.already)&&(identical(other.checkedOutAt, _this.checkedOutAt) || other.checkedOutAt == _this.checkedOutAt)&&(identical(other.duesPaise, _this.duesPaise) || other.duesPaise == _this.duesPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CheckInResult;
  return Object.hash(runtimeType,_this.memberId,_this.name,_this.memberCode,_this.photoPath,_this.status,_this.planName,_this.daysLeft,_this.already,_this.checkedOutAt,_this.duesPaise);
}

@override
String toString() {
  final _this = this as CheckInResult;
  return 'CheckInResult(memberId: ${_this.memberId}, name: ${_this.name}, memberCode: ${_this.memberCode}, photoPath: ${_this.photoPath}, status: ${_this.status}, planName: ${_this.planName}, daysLeft: ${_this.daysLeft}, already: ${_this.already}, checkedOutAt: ${_this.checkedOutAt}, duesPaise: ${_this.duesPaise})';
}


}

/// @nodoc
abstract mixin class $CheckInResultCopyWith<$Res>  {
  factory $CheckInResultCopyWith(CheckInResult value, $Res Function(CheckInResult) _then) = _$CheckInResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus status,@JsonKey(name: 'plan_name') String? planName,@JsonKey(name: 'days_left') int? daysLeft, bool already,@JsonKey(name: 'checked_out_at') DateTime? checkedOutAt,@JsonKey(name: 'dues_paise') int duesPaise
});




}
/// @nodoc
class _$CheckInResultCopyWithImpl<$Res>
    implements $CheckInResultCopyWith<$Res> {
  _$CheckInResultCopyWithImpl(this._self, this._then);

  final CheckInResult _self;
  final $Res Function(CheckInResult) _then;

/// Create a copy of CheckInResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? name = null,Object? memberCode = null,Object? photoPath = freezed,Object? status = null,Object? planName = freezed,Object? daysLeft = freezed,Object? already = null,Object? checkedOutAt = freezed,Object? duesPaise = null,}) {
  return _then(CheckInResult(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,already: null == already ? _self.already : already // ignore: cast_nullable_to_non_nullable
as bool,checkedOutAt: freezed == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duesPaise: null == duesPaise ? _self.duesPaise : duesPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckInResult].
extension CheckInResultPatterns on CheckInResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckInResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckInResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckInResult value)  $default,){
final _that = this;
switch (_that) {
case _CheckInResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckInResult value)?  $default,){
final _that = this;
switch (_that) {
case _CheckInResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'plan_name')  String? planName, @JsonKey(name: 'days_left')  int? daysLeft,  bool already, @JsonKey(name: 'checked_out_at')  DateTime? checkedOutAt, @JsonKey(name: 'dues_paise')  int duesPaise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckInResult() when $default != null:
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.status,_that.planName,_that.daysLeft,_that.already,_that.checkedOutAt,_that.duesPaise);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'plan_name')  String? planName, @JsonKey(name: 'days_left')  int? daysLeft,  bool already, @JsonKey(name: 'checked_out_at')  DateTime? checkedOutAt, @JsonKey(name: 'dues_paise')  int duesPaise)  $default,) {final _that = this;
switch (_that) {
case _CheckInResult():
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.status,_that.planName,_that.daysLeft,_that.already,_that.checkedOutAt,_that.duesPaise);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(fromJson: _status, toJson: _statusOut)  MemberStatus status, @JsonKey(name: 'plan_name')  String? planName, @JsonKey(name: 'days_left')  int? daysLeft,  bool already, @JsonKey(name: 'checked_out_at')  DateTime? checkedOutAt, @JsonKey(name: 'dues_paise')  int duesPaise)?  $default,) {final _that = this;
switch (_that) {
case _CheckInResult() when $default != null:
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.status,_that.planName,_that.daysLeft,_that.already,_that.checkedOutAt,_that.duesPaise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckInResult extends CheckInResult {
  const _CheckInResult({@JsonKey(name: 'member_id') required this.memberId, required this.name, @JsonKey(name: 'member_code') required this.memberCode, @JsonKey(name: 'photo_url') this.photoPath, @JsonKey(fromJson: _status, toJson: _statusOut) required this.status, @JsonKey(name: 'plan_name') this.planName, @JsonKey(name: 'days_left') this.daysLeft, this.already = false, @JsonKey(name: 'checked_out_at') this.checkedOutAt, @JsonKey(name: 'dues_paise') this.duesPaise = 0}): super._();
  factory _CheckInResult.fromJson(Map<String, dynamic> json) => _$CheckInResultFromJson(json);

@override@JsonKey(name: 'member_id') final  String memberId;
@override final  String name;
@override@JsonKey(name: 'member_code') final  String memberCode;
@override@JsonKey(name: 'photo_url') final  String? photoPath;
@override@JsonKey(fromJson: _status, toJson: _statusOut) final  MemberStatus status;
@override@JsonKey(name: 'plan_name') final  String? planName;
@override@JsonKey(name: 'days_left') final  int? daysLeft;
@override@JsonKey() final  bool already;
@override@JsonKey(name: 'checked_out_at') final  DateTime? checkedOutAt;
@override@JsonKey(name: 'dues_paise') final  int duesPaise;

/// Create a copy of CheckInResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckInResultCopyWith<_CheckInResult> get copyWith => __$CheckInResultCopyWithImpl<_CheckInResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckInResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckInResult&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.name, name) || other.name == name)&&(identical(other.memberCode, memberCode) || other.memberCode == memberCode)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft)&&(identical(other.already, already) || other.already == already)&&(identical(other.checkedOutAt, checkedOutAt) || other.checkedOutAt == checkedOutAt)&&(identical(other.duesPaise, duesPaise) || other.duesPaise == duesPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memberId,name,memberCode,photoPath,status,planName,daysLeft,already,checkedOutAt,duesPaise);
}

@override
String toString() {
    return 'CheckInResult(memberId: $memberId, name: $name, memberCode: $memberCode, photoPath: $photoPath, status: $status, planName: $planName, daysLeft: $daysLeft, already: $already, checkedOutAt: $checkedOutAt, duesPaise: $duesPaise)';
}


}

/// @nodoc
abstract mixin class _$CheckInResultCopyWith<$Res> implements $CheckInResultCopyWith<$Res> {
  factory _$CheckInResultCopyWith(_CheckInResult value, $Res Function(_CheckInResult) _then) = __$CheckInResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(fromJson: _status, toJson: _statusOut) MemberStatus status,@JsonKey(name: 'plan_name') String? planName,@JsonKey(name: 'days_left') int? daysLeft, bool already,@JsonKey(name: 'checked_out_at') DateTime? checkedOutAt,@JsonKey(name: 'dues_paise') int duesPaise
});




}
/// @nodoc
class __$CheckInResultCopyWithImpl<$Res>
    implements _$CheckInResultCopyWith<$Res> {
  __$CheckInResultCopyWithImpl(this._self, this._then);

  final _CheckInResult _self;
  final $Res Function(_CheckInResult) _then;

/// Create a copy of CheckInResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? name = null,Object? memberCode = null,Object? photoPath = freezed,Object? status = null,Object? planName = freezed,Object? daysLeft = freezed,Object? already = null,Object? checkedOutAt = freezed,Object? duesPaise = null,}) {
  return _then(_CheckInResult(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,already: null == already ? _self.already : already // ignore: cast_nullable_to_non_nullable
as bool,checkedOutAt: freezed == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,duesPaise: null == duesPaise ? _self.duesPaise : duesPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardCounts {

 int get active; int get expiring; int get expired; int get frozen; int get total;@JsonKey(name: 'new_this_month') int get newThisMonth;@JsonKey(name: 'checkins_today') int get checkinsToday;
/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCountsCopyWith<DashboardCounts> get copyWith => _$DashboardCountsCopyWithImpl<DashboardCounts>(this as DashboardCounts, _$identity);

  /// Serializes this DashboardCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardCounts&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.expiring, _this.expiring) || other.expiring == _this.expiring)&&(identical(other.expired, _this.expired) || other.expired == _this.expired)&&(identical(other.frozen, _this.frozen) || other.frozen == _this.frozen)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.newThisMonth, _this.newThisMonth) || other.newThisMonth == _this.newThisMonth)&&(identical(other.checkinsToday, _this.checkinsToday) || other.checkinsToday == _this.checkinsToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardCounts;
  return Object.hash(runtimeType,_this.active,_this.expiring,_this.expired,_this.frozen,_this.total,_this.newThisMonth,_this.checkinsToday);
}

@override
String toString() {
  final _this = this as DashboardCounts;
  return 'DashboardCounts(active: ${_this.active}, expiring: ${_this.expiring}, expired: ${_this.expired}, frozen: ${_this.frozen}, total: ${_this.total}, newThisMonth: ${_this.newThisMonth}, checkinsToday: ${_this.checkinsToday})';
}


}

/// @nodoc
abstract mixin class $DashboardCountsCopyWith<$Res>  {
  factory $DashboardCountsCopyWith(DashboardCounts value, $Res Function(DashboardCounts) _then) = _$DashboardCountsCopyWithImpl;
@useResult
$Res call({
 int active, int expiring, int expired, int frozen, int total,@JsonKey(name: 'new_this_month') int newThisMonth,@JsonKey(name: 'checkins_today') int checkinsToday
});




}
/// @nodoc
class _$DashboardCountsCopyWithImpl<$Res>
    implements $DashboardCountsCopyWith<$Res> {
  _$DashboardCountsCopyWithImpl(this._self, this._then);

  final DashboardCounts _self;
  final $Res Function(DashboardCounts) _then;

/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? active = null,Object? expiring = null,Object? expired = null,Object? frozen = null,Object? total = null,Object? newThisMonth = null,Object? checkinsToday = null,}) {
  return _then(DashboardCounts(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,expiring: null == expiring ? _self.expiring : expiring // ignore: cast_nullable_to_non_nullable
as int,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as int,frozen: null == frozen ? _self.frozen : frozen // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,newThisMonth: null == newThisMonth ? _self.newThisMonth : newThisMonth // ignore: cast_nullable_to_non_nullable
as int,checkinsToday: null == checkinsToday ? _self.checkinsToday : checkinsToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardCounts].
extension DashboardCountsPatterns on DashboardCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardCounts value)  $default,){
final _that = this;
switch (_that) {
case _DashboardCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardCounts value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int active,  int expiring,  int expired,  int frozen,  int total, @JsonKey(name: 'new_this_month')  int newThisMonth, @JsonKey(name: 'checkins_today')  int checkinsToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
return $default(_that.active,_that.expiring,_that.expired,_that.frozen,_that.total,_that.newThisMonth,_that.checkinsToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int active,  int expiring,  int expired,  int frozen,  int total, @JsonKey(name: 'new_this_month')  int newThisMonth, @JsonKey(name: 'checkins_today')  int checkinsToday)  $default,) {final _that = this;
switch (_that) {
case _DashboardCounts():
return $default(_that.active,_that.expiring,_that.expired,_that.frozen,_that.total,_that.newThisMonth,_that.checkinsToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int active,  int expiring,  int expired,  int frozen,  int total, @JsonKey(name: 'new_this_month')  int newThisMonth, @JsonKey(name: 'checkins_today')  int checkinsToday)?  $default,) {final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
return $default(_that.active,_that.expiring,_that.expired,_that.frozen,_that.total,_that.newThisMonth,_that.checkinsToday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardCounts implements DashboardCounts {
  const _DashboardCounts({this.active = 0, this.expiring = 0, this.expired = 0, this.frozen = 0, this.total = 0, @JsonKey(name: 'new_this_month') this.newThisMonth = 0, @JsonKey(name: 'checkins_today') this.checkinsToday = 0});
  factory _DashboardCounts.fromJson(Map<String, dynamic> json) => _$DashboardCountsFromJson(json);

@override@JsonKey() final  int active;
@override@JsonKey() final  int expiring;
@override@JsonKey() final  int expired;
@override@JsonKey() final  int frozen;
@override@JsonKey() final  int total;
@override@JsonKey(name: 'new_this_month') final  int newThisMonth;
@override@JsonKey(name: 'checkins_today') final  int checkinsToday;

/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCountsCopyWith<_DashboardCounts> get copyWith => __$DashboardCountsCopyWithImpl<_DashboardCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardCounts&&(identical(other.active, active) || other.active == active)&&(identical(other.expiring, expiring) || other.expiring == expiring)&&(identical(other.expired, expired) || other.expired == expired)&&(identical(other.frozen, frozen) || other.frozen == frozen)&&(identical(other.total, total) || other.total == total)&&(identical(other.newThisMonth, newThisMonth) || other.newThisMonth == newThisMonth)&&(identical(other.checkinsToday, checkinsToday) || other.checkinsToday == checkinsToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,active,expiring,expired,frozen,total,newThisMonth,checkinsToday);
}

@override
String toString() {
    return 'DashboardCounts(active: $active, expiring: $expiring, expired: $expired, frozen: $frozen, total: $total, newThisMonth: $newThisMonth, checkinsToday: $checkinsToday)';
}


}

/// @nodoc
abstract mixin class _$DashboardCountsCopyWith<$Res> implements $DashboardCountsCopyWith<$Res> {
  factory _$DashboardCountsCopyWith(_DashboardCounts value, $Res Function(_DashboardCounts) _then) = __$DashboardCountsCopyWithImpl;
@override @useResult
$Res call({
 int active, int expiring, int expired, int frozen, int total,@JsonKey(name: 'new_this_month') int newThisMonth,@JsonKey(name: 'checkins_today') int checkinsToday
});




}
/// @nodoc
class __$DashboardCountsCopyWithImpl<$Res>
    implements _$DashboardCountsCopyWith<$Res> {
  __$DashboardCountsCopyWithImpl(this._self, this._then);

  final _DashboardCounts _self;
  final $Res Function(_DashboardCounts) _then;

/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? active = null,Object? expiring = null,Object? expired = null,Object? frozen = null,Object? total = null,Object? newThisMonth = null,Object? checkinsToday = null,}) {
  return _then(_DashboardCounts(
active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int,expiring: null == expiring ? _self.expiring : expiring // ignore: cast_nullable_to_non_nullable
as int,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as int,frozen: null == frozen ? _self.frozen : frozen // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,newThisMonth: null == newThisMonth ? _self.newThisMonth : newThisMonth // ignore: cast_nullable_to_non_nullable
as int,checkinsToday: null == checkinsToday ? _self.checkinsToday : checkinsToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NeedsAction {

@JsonKey(name: 'member_id') String get memberId; String get name; String get phone;@JsonKey(name: 'photo_url') String? get photoPath;@JsonKey(fromJson: _reason, toJson: _reasonOut) ActionReason get reason; String? get detail;
/// Create a copy of NeedsAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeedsActionCopyWith<NeedsAction> get copyWith => _$NeedsActionCopyWithImpl<NeedsAction>(this as NeedsAction, _$identity);

  /// Serializes this NeedsAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NeedsAction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeedsAction&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.detail, _this.detail) || other.detail == _this.detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NeedsAction;
  return Object.hash(runtimeType,_this.memberId,_this.name,_this.phone,_this.photoPath,_this.reason,_this.detail);
}

@override
String toString() {
  final _this = this as NeedsAction;
  return 'NeedsAction(memberId: ${_this.memberId}, name: ${_this.name}, phone: ${_this.phone}, photoPath: ${_this.photoPath}, reason: ${_this.reason}, detail: ${_this.detail})';
}


}

/// @nodoc
abstract mixin class $NeedsActionCopyWith<$Res>  {
  factory $NeedsActionCopyWith(NeedsAction value, $Res Function(NeedsAction) _then) = _$NeedsActionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name, String phone,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(fromJson: _reason, toJson: _reasonOut) ActionReason reason, String? detail
});




}
/// @nodoc
class _$NeedsActionCopyWithImpl<$Res>
    implements $NeedsActionCopyWith<$Res> {
  _$NeedsActionCopyWithImpl(this._self, this._then);

  final NeedsAction _self;
  final $Res Function(NeedsAction) _then;

/// Create a copy of NeedsAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? name = null,Object? phone = null,Object? photoPath = freezed,Object? reason = null,Object? detail = freezed,}) {
  return _then(NeedsAction(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ActionReason,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NeedsAction].
extension NeedsActionPatterns on NeedsAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NeedsAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NeedsAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NeedsAction value)  $default,){
final _that = this;
switch (_that) {
case _NeedsAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NeedsAction value)?  $default,){
final _that = this;
switch (_that) {
case _NeedsAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name,  String phone, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(fromJson: _reason, toJson: _reasonOut)  ActionReason reason,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NeedsAction() when $default != null:
return $default(_that.memberId,_that.name,_that.phone,_that.photoPath,_that.reason,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name,  String phone, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(fromJson: _reason, toJson: _reasonOut)  ActionReason reason,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _NeedsAction():
return $default(_that.memberId,_that.name,_that.phone,_that.photoPath,_that.reason,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_id')  String memberId,  String name,  String phone, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(fromJson: _reason, toJson: _reasonOut)  ActionReason reason,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _NeedsAction() when $default != null:
return $default(_that.memberId,_that.name,_that.phone,_that.photoPath,_that.reason,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NeedsAction implements NeedsAction {
  const _NeedsAction({@JsonKey(name: 'member_id') required this.memberId, required this.name, required this.phone, @JsonKey(name: 'photo_url') this.photoPath, @JsonKey(fromJson: _reason, toJson: _reasonOut) required this.reason, this.detail});
  factory _NeedsAction.fromJson(Map<String, dynamic> json) => _$NeedsActionFromJson(json);

@override@JsonKey(name: 'member_id') final  String memberId;
@override final  String name;
@override final  String phone;
@override@JsonKey(name: 'photo_url') final  String? photoPath;
@override@JsonKey(fromJson: _reason, toJson: _reasonOut) final  ActionReason reason;
@override final  String? detail;

/// Create a copy of NeedsAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeedsActionCopyWith<_NeedsAction> get copyWith => __$NeedsActionCopyWithImpl<_NeedsAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NeedsActionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeedsAction&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memberId,name,phone,photoPath,reason,detail);
}

@override
String toString() {
    return 'NeedsAction(memberId: $memberId, name: $name, phone: $phone, photoPath: $photoPath, reason: $reason, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$NeedsActionCopyWith<$Res> implements $NeedsActionCopyWith<$Res> {
  factory _$NeedsActionCopyWith(_NeedsAction value, $Res Function(_NeedsAction) _then) = __$NeedsActionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name, String phone,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(fromJson: _reason, toJson: _reasonOut) ActionReason reason, String? detail
});




}
/// @nodoc
class __$NeedsActionCopyWithImpl<$Res>
    implements _$NeedsActionCopyWith<$Res> {
  __$NeedsActionCopyWithImpl(this._self, this._then);

  final _NeedsAction _self;
  final $Res Function(_NeedsAction) _then;

/// Create a copy of NeedsAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? name = null,Object? phone = null,Object? photoPath = freezed,Object? reason = null,Object? detail = freezed,}) {
  return _then(_NeedsAction(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ActionReason,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MemberQuery {

 String get search; List<String> get statuses; String? get planName; String? get trainerId; String? get batch; String? get gender; bool get birthdayThisMonth;@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get joinedFrom;@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get joinedTo; MemberSort get sort; bool get includeArchived;
/// Create a copy of MemberQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberQueryCopyWith<MemberQuery> get copyWith => _$MemberQueryCopyWithImpl<MemberQuery>(this as MemberQuery, _$identity);

  /// Serializes this MemberQuery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemberQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberQuery&&(identical(other.search, _this.search) || other.search == _this.search)&&const DeepCollectionEquality().equals(other.statuses, _this.statuses)&&(identical(other.planName, _this.planName) || other.planName == _this.planName)&&(identical(other.trainerId, _this.trainerId) || other.trainerId == _this.trainerId)&&(identical(other.batch, _this.batch) || other.batch == _this.batch)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.birthdayThisMonth, _this.birthdayThisMonth) || other.birthdayThisMonth == _this.birthdayThisMonth)&&(identical(other.joinedFrom, _this.joinedFrom) || other.joinedFrom == _this.joinedFrom)&&(identical(other.joinedTo, _this.joinedTo) || other.joinedTo == _this.joinedTo)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.includeArchived, _this.includeArchived) || other.includeArchived == _this.includeArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemberQuery;
  return Object.hash(runtimeType,_this.search,const DeepCollectionEquality().hash(_this.statuses),_this.planName,_this.trainerId,_this.batch,_this.gender,_this.birthdayThisMonth,_this.joinedFrom,_this.joinedTo,_this.sort,_this.includeArchived);
}

@override
String toString() {
  final _this = this as MemberQuery;
  return 'MemberQuery(search: ${_this.search}, statuses: ${_this.statuses}, planName: ${_this.planName}, trainerId: ${_this.trainerId}, batch: ${_this.batch}, gender: ${_this.gender}, birthdayThisMonth: ${_this.birthdayThisMonth}, joinedFrom: ${_this.joinedFrom}, joinedTo: ${_this.joinedTo}, sort: ${_this.sort}, includeArchived: ${_this.includeArchived})';
}


}

/// @nodoc
abstract mixin class $MemberQueryCopyWith<$Res>  {
  factory $MemberQueryCopyWith(MemberQuery value, $Res Function(MemberQuery) _then) = _$MemberQueryCopyWithImpl;
@useResult
$Res call({
 String search, List<String> statuses, String? planName, String? trainerId, String? batch, String? gender, bool birthdayThisMonth,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? joinedFrom,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? joinedTo, MemberSort sort, bool includeArchived
});




}
/// @nodoc
class _$MemberQueryCopyWithImpl<$Res>
    implements $MemberQueryCopyWith<$Res> {
  _$MemberQueryCopyWithImpl(this._self, this._then);

  final MemberQuery _self;
  final $Res Function(MemberQuery) _then;

/// Create a copy of MemberQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? statuses = null,Object? planName = freezed,Object? trainerId = freezed,Object? batch = freezed,Object? gender = freezed,Object? birthdayThisMonth = null,Object? joinedFrom = freezed,Object? joinedTo = freezed,Object? sort = null,Object? includeArchived = null,}) {
  return _then(MemberQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthdayThisMonth: null == birthdayThisMonth ? _self.birthdayThisMonth : birthdayThisMonth // ignore: cast_nullable_to_non_nullable
as bool,joinedFrom: freezed == joinedFrom ? _self.joinedFrom : joinedFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,joinedTo: freezed == joinedTo ? _self.joinedTo : joinedTo // ignore: cast_nullable_to_non_nullable
as DateTime?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as MemberSort,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberQuery].
extension MemberQueryPatterns on MemberQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberQuery value)  $default,){
final _that = this;
switch (_that) {
case _MemberQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberQuery value)?  $default,){
final _that = this;
switch (_that) {
case _MemberQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  List<String> statuses,  String? planName,  String? trainerId,  String? batch,  String? gender,  bool birthdayThisMonth, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? joinedFrom, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? joinedTo,  MemberSort sort,  bool includeArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberQuery() when $default != null:
return $default(_that.search,_that.statuses,_that.planName,_that.trainerId,_that.batch,_that.gender,_that.birthdayThisMonth,_that.joinedFrom,_that.joinedTo,_that.sort,_that.includeArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  List<String> statuses,  String? planName,  String? trainerId,  String? batch,  String? gender,  bool birthdayThisMonth, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? joinedFrom, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? joinedTo,  MemberSort sort,  bool includeArchived)  $default,) {final _that = this;
switch (_that) {
case _MemberQuery():
return $default(_that.search,_that.statuses,_that.planName,_that.trainerId,_that.batch,_that.gender,_that.birthdayThisMonth,_that.joinedFrom,_that.joinedTo,_that.sort,_that.includeArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  List<String> statuses,  String? planName,  String? trainerId,  String? batch,  String? gender,  bool birthdayThisMonth, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? joinedFrom, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? joinedTo,  MemberSort sort,  bool includeArchived)?  $default,) {final _that = this;
switch (_that) {
case _MemberQuery() when $default != null:
return $default(_that.search,_that.statuses,_that.planName,_that.trainerId,_that.batch,_that.gender,_that.birthdayThisMonth,_that.joinedFrom,_that.joinedTo,_that.sort,_that.includeArchived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberQuery extends MemberQuery {
  const _MemberQuery({this.search = '',  List<String> statuses = const <String>[], this.planName, this.trainerId, this.batch, this.gender, this.birthdayThisMonth = false, @JsonKey(fromJson: _date, toJson: _dateOut) this.joinedFrom, @JsonKey(fromJson: _date, toJson: _dateOut) this.joinedTo, this.sort = MemberSort.name, this.includeArchived = false}): _statuses = statuses,super._();
  factory _MemberQuery.fromJson(Map<String, dynamic> json) => _$MemberQueryFromJson(json);

@override@JsonKey() final  String search;
 final  List<String> _statuses;
@override@JsonKey() List<String> get statuses {
  if (_statuses is EqualUnmodifiableListView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statuses);
}

@override final  String? planName;
@override final  String? trainerId;
@override final  String? batch;
@override final  String? gender;
@override@JsonKey() final  bool birthdayThisMonth;
@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? joinedFrom;
@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? joinedTo;
@override@JsonKey() final  MemberSort sort;
@override@JsonKey() final  bool includeArchived;

/// Create a copy of MemberQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberQueryCopyWith<_MemberQuery> get copyWith => __$MemberQueryCopyWithImpl<_MemberQuery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberQueryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberQuery&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other.statuses, _statuses)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.batch, batch) || other.batch == batch)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthdayThisMonth, birthdayThisMonth) || other.birthdayThisMonth == birthdayThisMonth)&&(identical(other.joinedFrom, joinedFrom) || other.joinedFrom == joinedFrom)&&(identical(other.joinedTo, joinedTo) || other.joinedTo == joinedTo)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.includeArchived, includeArchived) || other.includeArchived == includeArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,search,const DeepCollectionEquality().hash(_statuses),planName,trainerId,batch,gender,birthdayThisMonth,joinedFrom,joinedTo,sort,includeArchived);
}

@override
String toString() {
    return 'MemberQuery(search: $search, statuses: $statuses, planName: $planName, trainerId: $trainerId, batch: $batch, gender: $gender, birthdayThisMonth: $birthdayThisMonth, joinedFrom: $joinedFrom, joinedTo: $joinedTo, sort: $sort, includeArchived: $includeArchived)';
}


}

/// @nodoc
abstract mixin class _$MemberQueryCopyWith<$Res> implements $MemberQueryCopyWith<$Res> {
  factory _$MemberQueryCopyWith(_MemberQuery value, $Res Function(_MemberQuery) _then) = __$MemberQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, List<String> statuses, String? planName, String? trainerId, String? batch, String? gender, bool birthdayThisMonth,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? joinedFrom,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? joinedTo, MemberSort sort, bool includeArchived
});




}
/// @nodoc
class __$MemberQueryCopyWithImpl<$Res>
    implements _$MemberQueryCopyWith<$Res> {
  __$MemberQueryCopyWithImpl(this._self, this._then);

  final _MemberQuery _self;
  final $Res Function(_MemberQuery) _then;

/// Create a copy of MemberQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? statuses = null,Object? planName = freezed,Object? trainerId = freezed,Object? batch = freezed,Object? gender = freezed,Object? birthdayThisMonth = null,Object? joinedFrom = freezed,Object? joinedTo = freezed,Object? sort = null,Object? includeArchived = null,}) {
  return _then(_MemberQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,batch: freezed == batch ? _self.batch : batch // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthdayThisMonth: null == birthdayThisMonth ? _self.birthdayThisMonth : birthdayThisMonth // ignore: cast_nullable_to_non_nullable
as bool,joinedFrom: freezed == joinedFrom ? _self.joinedFrom : joinedFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,joinedTo: freezed == joinedTo ? _self.joinedTo : joinedTo // ignore: cast_nullable_to_non_nullable
as DateTime?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as MemberSort,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CheckOutResult {

@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'checked_in_at') DateTime get checkedInAt;@JsonKey(name: 'checked_out_at') DateTime get checkedOutAt; int get minutes;
/// Create a copy of CheckOutResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckOutResultCopyWith<CheckOutResult> get copyWith => _$CheckOutResultCopyWithImpl<CheckOutResult>(this as CheckOutResult, _$identity);

  /// Serializes this CheckOutResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CheckOutResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckOutResult&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt)&&(identical(other.checkedOutAt, _this.checkedOutAt) || other.checkedOutAt == _this.checkedOutAt)&&(identical(other.minutes, _this.minutes) || other.minutes == _this.minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CheckOutResult;
  return Object.hash(runtimeType,_this.memberId,_this.checkedInAt,_this.checkedOutAt,_this.minutes);
}

@override
String toString() {
  final _this = this as CheckOutResult;
  return 'CheckOutResult(memberId: ${_this.memberId}, checkedInAt: ${_this.checkedInAt}, checkedOutAt: ${_this.checkedOutAt}, minutes: ${_this.minutes})';
}


}

/// @nodoc
abstract mixin class $CheckOutResultCopyWith<$Res>  {
  factory $CheckOutResultCopyWith(CheckOutResult value, $Res Function(CheckOutResult) _then) = _$CheckOutResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'checked_in_at') DateTime checkedInAt,@JsonKey(name: 'checked_out_at') DateTime checkedOutAt, int minutes
});




}
/// @nodoc
class _$CheckOutResultCopyWithImpl<$Res>
    implements $CheckOutResultCopyWith<$Res> {
  _$CheckOutResultCopyWithImpl(this._self, this._then);

  final CheckOutResult _self;
  final $Res Function(CheckOutResult) _then;

/// Create a copy of CheckOutResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? checkedInAt = null,Object? checkedOutAt = null,Object? minutes = null,}) {
  return _then(CheckOutResult(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,checkedInAt: null == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,checkedOutAt: null == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckOutResult].
extension CheckOutResultPatterns on CheckOutResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckOutResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckOutResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckOutResult value)  $default,){
final _that = this;
switch (_that) {
case _CheckOutResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckOutResult value)?  $default,){
final _that = this;
switch (_that) {
case _CheckOutResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'checked_in_at')  DateTime checkedInAt, @JsonKey(name: 'checked_out_at')  DateTime checkedOutAt,  int minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckOutResult() when $default != null:
return $default(_that.memberId,_that.checkedInAt,_that.checkedOutAt,_that.minutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'checked_in_at')  DateTime checkedInAt, @JsonKey(name: 'checked_out_at')  DateTime checkedOutAt,  int minutes)  $default,) {final _that = this;
switch (_that) {
case _CheckOutResult():
return $default(_that.memberId,_that.checkedInAt,_that.checkedOutAt,_that.minutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'checked_in_at')  DateTime checkedInAt, @JsonKey(name: 'checked_out_at')  DateTime checkedOutAt,  int minutes)?  $default,) {final _that = this;
switch (_that) {
case _CheckOutResult() when $default != null:
return $default(_that.memberId,_that.checkedInAt,_that.checkedOutAt,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckOutResult implements CheckOutResult {
  const _CheckOutResult({@JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'checked_in_at') required this.checkedInAt, @JsonKey(name: 'checked_out_at') required this.checkedOutAt, this.minutes = 0});
  factory _CheckOutResult.fromJson(Map<String, dynamic> json) => _$CheckOutResultFromJson(json);

@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'checked_in_at') final  DateTime checkedInAt;
@override@JsonKey(name: 'checked_out_at') final  DateTime checkedOutAt;
@override@JsonKey() final  int minutes;

/// Create a copy of CheckOutResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckOutResultCopyWith<_CheckOutResult> get copyWith => __$CheckOutResultCopyWithImpl<_CheckOutResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckOutResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckOutResult&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.checkedOutAt, checkedOutAt) || other.checkedOutAt == checkedOutAt)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memberId,checkedInAt,checkedOutAt,minutes);
}

@override
String toString() {
    return 'CheckOutResult(memberId: $memberId, checkedInAt: $checkedInAt, checkedOutAt: $checkedOutAt, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$CheckOutResultCopyWith<$Res> implements $CheckOutResultCopyWith<$Res> {
  factory _$CheckOutResultCopyWith(_CheckOutResult value, $Res Function(_CheckOutResult) _then) = __$CheckOutResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'checked_in_at') DateTime checkedInAt,@JsonKey(name: 'checked_out_at') DateTime checkedOutAt, int minutes
});




}
/// @nodoc
class __$CheckOutResultCopyWithImpl<$Res>
    implements _$CheckOutResultCopyWith<$Res> {
  __$CheckOutResultCopyWithImpl(this._self, this._then);

  final _CheckOutResult _self;
  final $Res Function(_CheckOutResult) _then;

/// Create a copy of CheckOutResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? checkedInAt = null,Object? checkedOutAt = null,Object? minutes = null,}) {
  return _then(_CheckOutResult(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,checkedInAt: null == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,checkedOutAt: null == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
