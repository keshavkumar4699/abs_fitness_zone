// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

@JsonKey(name: 'id') String get userId; UserRole get role; String get name; String? get phone;@JsonKey(name: 'staff_id') String? get staffId;@JsonKey(name: 'member_id') String? get memberId;@JsonKey(name: 'must_set_password') bool get mustSetPassword;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.staffId, _this.staffId) || other.staffId == _this.staffId)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.mustSetPassword, _this.mustSetPassword) || other.mustSetPassword == _this.mustSetPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppUser;
  return Object.hash(runtimeType,_this.userId,_this.role,_this.name,_this.phone,_this.staffId,_this.memberId,_this.mustSetPassword);
}

@override
String toString() {
  final _this = this as AppUser;
  return 'AppUser(userId: ${_this.userId}, role: ${_this.role}, name: ${_this.name}, phone: ${_this.phone}, staffId: ${_this.staffId}, memberId: ${_this.memberId}, mustSetPassword: ${_this.mustSetPassword})';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String userId, UserRole role, String name, String? phone,@JsonKey(name: 'staff_id') String? staffId,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'must_set_password') bool mustSetPassword
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? name = null,Object? phone = freezed,Object? staffId = freezed,Object? memberId = freezed,Object? mustSetPassword = null,}) {
  return _then(AppUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,staffId: freezed == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,mustSetPassword: null == mustSetPassword ? _self.mustSetPassword : mustSetPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId,  UserRole role,  String name,  String? phone, @JsonKey(name: 'staff_id')  String? staffId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'must_set_password')  bool mustSetPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.userId,_that.role,_that.name,_that.phone,_that.staffId,_that.memberId,_that.mustSetPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId,  UserRole role,  String name,  String? phone, @JsonKey(name: 'staff_id')  String? staffId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'must_set_password')  bool mustSetPassword)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.userId,_that.role,_that.name,_that.phone,_that.staffId,_that.memberId,_that.mustSetPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String userId,  UserRole role,  String name,  String? phone, @JsonKey(name: 'staff_id')  String? staffId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'must_set_password')  bool mustSetPassword)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.userId,_that.role,_that.name,_that.phone,_that.staffId,_that.memberId,_that.mustSetPassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({@JsonKey(name: 'id') required this.userId, required this.role, required this.name, this.phone, @JsonKey(name: 'staff_id') this.staffId, @JsonKey(name: 'member_id') this.memberId, @JsonKey(name: 'must_set_password') this.mustSetPassword = false});
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override@JsonKey(name: 'id') final  String userId;
@override final  UserRole role;
@override final  String name;
@override final  String? phone;
@override@JsonKey(name: 'staff_id') final  String? staffId;
@override@JsonKey(name: 'member_id') final  String? memberId;
@override@JsonKey(name: 'must_set_password') final  bool mustSetPassword;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.staffId, staffId) || other.staffId == staffId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.mustSetPassword, mustSetPassword) || other.mustSetPassword == mustSetPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,role,name,phone,staffId,memberId,mustSetPassword);
}

@override
String toString() {
    return 'AppUser(userId: $userId, role: $role, name: $name, phone: $phone, staffId: $staffId, memberId: $memberId, mustSetPassword: $mustSetPassword)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String userId, UserRole role, String name, String? phone,@JsonKey(name: 'staff_id') String? staffId,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'must_set_password') bool mustSetPassword
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? name = null,Object? phone = freezed,Object? staffId = freezed,Object? memberId = freezed,Object? mustSetPassword = null,}) {
  return _then(_AppUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,staffId: freezed == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,mustSetPassword: null == mustSetPassword ? _self.mustSetPassword : mustSetPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
