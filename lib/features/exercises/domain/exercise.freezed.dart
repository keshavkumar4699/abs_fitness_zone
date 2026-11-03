// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exercise {

 String get id;@JsonKey(name: 'source_id') String? get sourceId; String get name;@JsonKey(name: 'local_name') String? get localName;@JsonKey(name: 'primary_muscles') List<String> get primaryMuscles;@JsonKey(name: 'secondary_muscles') List<String> get secondaryMuscles; String? get equipment; String? get level; String? get category; String? get mechanic; String? get force;@JsonKey(name: 'tracking_type') TrackingType get trackingType; List<String> get instructions; String? get tips; String? get mistakes; List<String> get images;@JsonKey(name: 'video_url') String? get videoUrl;@JsonKey(name: 'is_custom') bool get isCustom;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'updated_at', fromJson: _ts) DateTime get updatedAt;@JsonKey(name: 'archived_at') DateTime? get archivedAt;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Exercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.localName, _this.localName) || other.localName == _this.localName)&&const DeepCollectionEquality().equals(other.primaryMuscles, _this.primaryMuscles)&&const DeepCollectionEquality().equals(other.secondaryMuscles, _this.secondaryMuscles)&&(identical(other.equipment, _this.equipment) || other.equipment == _this.equipment)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.mechanic, _this.mechanic) || other.mechanic == _this.mechanic)&&(identical(other.force, _this.force) || other.force == _this.force)&&(identical(other.trackingType, _this.trackingType) || other.trackingType == _this.trackingType)&&const DeepCollectionEquality().equals(other.instructions, _this.instructions)&&(identical(other.tips, _this.tips) || other.tips == _this.tips)&&(identical(other.mistakes, _this.mistakes) || other.mistakes == _this.mistakes)&&const DeepCollectionEquality().equals(other.images, _this.images)&&(identical(other.videoUrl, _this.videoUrl) || other.videoUrl == _this.videoUrl)&&(identical(other.isCustom, _this.isCustom) || other.isCustom == _this.isCustom)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Exercise;
  return Object.hashAll([runtimeType,_this.id,_this.sourceId,_this.name,_this.localName,const DeepCollectionEquality().hash(_this.primaryMuscles),const DeepCollectionEquality().hash(_this.secondaryMuscles),_this.equipment,_this.level,_this.category,_this.mechanic,_this.force,_this.trackingType,const DeepCollectionEquality().hash(_this.instructions),_this.tips,_this.mistakes,const DeepCollectionEquality().hash(_this.images),_this.videoUrl,_this.isCustom,_this.createdBy,_this.updatedAt,_this.archivedAt]);
}

@override
String toString() {
  final _this = this as Exercise;
  return 'Exercise(id: ${_this.id}, sourceId: ${_this.sourceId}, name: ${_this.name}, localName: ${_this.localName}, primaryMuscles: ${_this.primaryMuscles}, secondaryMuscles: ${_this.secondaryMuscles}, equipment: ${_this.equipment}, level: ${_this.level}, category: ${_this.category}, mechanic: ${_this.mechanic}, force: ${_this.force}, trackingType: ${_this.trackingType}, instructions: ${_this.instructions}, tips: ${_this.tips}, mistakes: ${_this.mistakes}, images: ${_this.images}, videoUrl: ${_this.videoUrl}, isCustom: ${_this.isCustom}, createdBy: ${_this.createdBy}, updatedAt: ${_this.updatedAt}, archivedAt: ${_this.archivedAt})';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'source_id') String? sourceId, String name,@JsonKey(name: 'local_name') String? localName,@JsonKey(name: 'primary_muscles') List<String> primaryMuscles,@JsonKey(name: 'secondary_muscles') List<String> secondaryMuscles, String? equipment, String? level, String? category, String? mechanic, String? force,@JsonKey(name: 'tracking_type') TrackingType trackingType, List<String> instructions, String? tips, String? mistakes, List<String> images,@JsonKey(name: 'video_url') String? videoUrl,@JsonKey(name: 'is_custom') bool isCustom,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'updated_at', fromJson: _ts) DateTime updatedAt,@JsonKey(name: 'archived_at') DateTime? archivedAt
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceId = freezed,Object? name = null,Object? localName = freezed,Object? primaryMuscles = null,Object? secondaryMuscles = null,Object? equipment = freezed,Object? level = freezed,Object? category = freezed,Object? mechanic = freezed,Object? force = freezed,Object? trackingType = null,Object? instructions = null,Object? tips = freezed,Object? mistakes = freezed,Object? images = null,Object? videoUrl = freezed,Object? isCustom = null,Object? createdBy = freezed,Object? updatedAt = null,Object? archivedAt = freezed,}) {
  return _then(Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,localName: freezed == localName ? _self.localName : localName // ignore: cast_nullable_to_non_nullable
as String?,primaryMuscles: null == primaryMuscles ? _self.primaryMuscles : primaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryMuscles: null == secondaryMuscles ? _self.secondaryMuscles : secondaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,mechanic: freezed == mechanic ? _self.mechanic : mechanic // ignore: cast_nullable_to_non_nullable
as String?,force: freezed == force ? _self.force : force // ignore: cast_nullable_to_non_nullable
as String?,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as TrackingType,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,tips: freezed == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as String?,mistakes: freezed == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'source_id')  String? sourceId,  String name, @JsonKey(name: 'local_name')  String? localName, @JsonKey(name: 'primary_muscles')  List<String> primaryMuscles, @JsonKey(name: 'secondary_muscles')  List<String> secondaryMuscles,  String? equipment,  String? level,  String? category,  String? mechanic,  String? force, @JsonKey(name: 'tracking_type')  TrackingType trackingType,  List<String> instructions,  String? tips,  String? mistakes,  List<String> images, @JsonKey(name: 'video_url')  String? videoUrl, @JsonKey(name: 'is_custom')  bool isCustom, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'updated_at', fromJson: _ts)  DateTime updatedAt, @JsonKey(name: 'archived_at')  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.sourceId,_that.name,_that.localName,_that.primaryMuscles,_that.secondaryMuscles,_that.equipment,_that.level,_that.category,_that.mechanic,_that.force,_that.trackingType,_that.instructions,_that.tips,_that.mistakes,_that.images,_that.videoUrl,_that.isCustom,_that.createdBy,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'source_id')  String? sourceId,  String name, @JsonKey(name: 'local_name')  String? localName, @JsonKey(name: 'primary_muscles')  List<String> primaryMuscles, @JsonKey(name: 'secondary_muscles')  List<String> secondaryMuscles,  String? equipment,  String? level,  String? category,  String? mechanic,  String? force, @JsonKey(name: 'tracking_type')  TrackingType trackingType,  List<String> instructions,  String? tips,  String? mistakes,  List<String> images, @JsonKey(name: 'video_url')  String? videoUrl, @JsonKey(name: 'is_custom')  bool isCustom, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'updated_at', fromJson: _ts)  DateTime updatedAt, @JsonKey(name: 'archived_at')  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.sourceId,_that.name,_that.localName,_that.primaryMuscles,_that.secondaryMuscles,_that.equipment,_that.level,_that.category,_that.mechanic,_that.force,_that.trackingType,_that.instructions,_that.tips,_that.mistakes,_that.images,_that.videoUrl,_that.isCustom,_that.createdBy,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'source_id')  String? sourceId,  String name, @JsonKey(name: 'local_name')  String? localName, @JsonKey(name: 'primary_muscles')  List<String> primaryMuscles, @JsonKey(name: 'secondary_muscles')  List<String> secondaryMuscles,  String? equipment,  String? level,  String? category,  String? mechanic,  String? force, @JsonKey(name: 'tracking_type')  TrackingType trackingType,  List<String> instructions,  String? tips,  String? mistakes,  List<String> images, @JsonKey(name: 'video_url')  String? videoUrl, @JsonKey(name: 'is_custom')  bool isCustom, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'updated_at', fromJson: _ts)  DateTime updatedAt, @JsonKey(name: 'archived_at')  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.sourceId,_that.name,_that.localName,_that.primaryMuscles,_that.secondaryMuscles,_that.equipment,_that.level,_that.category,_that.mechanic,_that.force,_that.trackingType,_that.instructions,_that.tips,_that.mistakes,_that.images,_that.videoUrl,_that.isCustom,_that.createdBy,_that.updatedAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise extends Exercise {
  const _Exercise({required this.id, @JsonKey(name: 'source_id') this.sourceId, required this.name, @JsonKey(name: 'local_name') this.localName, @JsonKey(name: 'primary_muscles')  List<String> primaryMuscles = const <String>[], @JsonKey(name: 'secondary_muscles')  List<String> secondaryMuscles = const <String>[], this.equipment, this.level, this.category, this.mechanic, this.force, @JsonKey(name: 'tracking_type') this.trackingType = TrackingType.repsWeight,  List<String> instructions = const <String>[], this.tips, this.mistakes,  List<String> images = const <String>[], @JsonKey(name: 'video_url') this.videoUrl, @JsonKey(name: 'is_custom') this.isCustom = false, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'updated_at', fromJson: _ts) required this.updatedAt, @JsonKey(name: 'archived_at') this.archivedAt}): _primaryMuscles = primaryMuscles,_secondaryMuscles = secondaryMuscles,_instructions = instructions,_images = images,super._();
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'source_id') final  String? sourceId;
@override final  String name;
@override@JsonKey(name: 'local_name') final  String? localName;
 final  List<String> _primaryMuscles;
@override@JsonKey(name: 'primary_muscles') List<String> get primaryMuscles {
  if (_primaryMuscles is EqualUnmodifiableListView) return _primaryMuscles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_primaryMuscles);
}

 final  List<String> _secondaryMuscles;
@override@JsonKey(name: 'secondary_muscles') List<String> get secondaryMuscles {
  if (_secondaryMuscles is EqualUnmodifiableListView) return _secondaryMuscles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondaryMuscles);
}

@override final  String? equipment;
@override final  String? level;
@override final  String? category;
@override final  String? mechanic;
@override final  String? force;
@override@JsonKey(name: 'tracking_type') final  TrackingType trackingType;
 final  List<String> _instructions;
@override@JsonKey() List<String> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

@override final  String? tips;
@override final  String? mistakes;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override@JsonKey(name: 'video_url') final  String? videoUrl;
@override@JsonKey(name: 'is_custom') final  bool isCustom;
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'updated_at', fromJson: _ts) final  DateTime updatedAt;
@override@JsonKey(name: 'archived_at') final  DateTime? archivedAt;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.localName, localName) || other.localName == localName)&&const DeepCollectionEquality().equals(other.primaryMuscles, _primaryMuscles)&&const DeepCollectionEquality().equals(other.secondaryMuscles, _secondaryMuscles)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.mechanic, mechanic) || other.mechanic == mechanic)&&(identical(other.force, force) || other.force == force)&&(identical(other.trackingType, trackingType) || other.trackingType == trackingType)&&const DeepCollectionEquality().equals(other.instructions, _instructions)&&(identical(other.tips, tips) || other.tips == tips)&&(identical(other.mistakes, mistakes) || other.mistakes == mistakes)&&const DeepCollectionEquality().equals(other.images, _images)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,sourceId,name,localName,const DeepCollectionEquality().hash(_primaryMuscles),const DeepCollectionEquality().hash(_secondaryMuscles),equipment,level,category,mechanic,force,trackingType,const DeepCollectionEquality().hash(_instructions),tips,mistakes,const DeepCollectionEquality().hash(_images),videoUrl,isCustom,createdBy,updatedAt,archivedAt]);
}

@override
String toString() {
    return 'Exercise(id: $id, sourceId: $sourceId, name: $name, localName: $localName, primaryMuscles: $primaryMuscles, secondaryMuscles: $secondaryMuscles, equipment: $equipment, level: $level, category: $category, mechanic: $mechanic, force: $force, trackingType: $trackingType, instructions: $instructions, tips: $tips, mistakes: $mistakes, images: $images, videoUrl: $videoUrl, isCustom: $isCustom, createdBy: $createdBy, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'source_id') String? sourceId, String name,@JsonKey(name: 'local_name') String? localName,@JsonKey(name: 'primary_muscles') List<String> primaryMuscles,@JsonKey(name: 'secondary_muscles') List<String> secondaryMuscles, String? equipment, String? level, String? category, String? mechanic, String? force,@JsonKey(name: 'tracking_type') TrackingType trackingType, List<String> instructions, String? tips, String? mistakes, List<String> images,@JsonKey(name: 'video_url') String? videoUrl,@JsonKey(name: 'is_custom') bool isCustom,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'updated_at', fromJson: _ts) DateTime updatedAt,@JsonKey(name: 'archived_at') DateTime? archivedAt
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceId = freezed,Object? name = null,Object? localName = freezed,Object? primaryMuscles = null,Object? secondaryMuscles = null,Object? equipment = freezed,Object? level = freezed,Object? category = freezed,Object? mechanic = freezed,Object? force = freezed,Object? trackingType = null,Object? instructions = null,Object? tips = freezed,Object? mistakes = freezed,Object? images = null,Object? videoUrl = freezed,Object? isCustom = null,Object? createdBy = freezed,Object? updatedAt = null,Object? archivedAt = freezed,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,localName: freezed == localName ? _self.localName : localName // ignore: cast_nullable_to_non_nullable
as String?,primaryMuscles: null == primaryMuscles ? _self._primaryMuscles : primaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,secondaryMuscles: null == secondaryMuscles ? _self._secondaryMuscles : secondaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,mechanic: freezed == mechanic ? _self.mechanic : mechanic // ignore: cast_nullable_to_non_nullable
as String?,force: freezed == force ? _self.force : force // ignore: cast_nullable_to_non_nullable
as String?,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as TrackingType,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<String>,tips: freezed == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as String?,mistakes: freezed == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ExerciseFilter {

 String get search; String? get muscle; String? get equipment; String? get level; String? get category; bool get ourEquipmentOnly; bool get favouritesOnly;
/// Create a copy of ExerciseFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseFilterCopyWith<ExerciseFilter> get copyWith => _$ExerciseFilterCopyWithImpl<ExerciseFilter>(this as ExerciseFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExerciseFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseFilter&&(identical(other.search, _this.search) || other.search == _this.search)&&(identical(other.muscle, _this.muscle) || other.muscle == _this.muscle)&&(identical(other.equipment, _this.equipment) || other.equipment == _this.equipment)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.ourEquipmentOnly, _this.ourEquipmentOnly) || other.ourEquipmentOnly == _this.ourEquipmentOnly)&&(identical(other.favouritesOnly, _this.favouritesOnly) || other.favouritesOnly == _this.favouritesOnly));
}


@override
int get hashCode {
  final _this = this as ExerciseFilter;
  return Object.hash(runtimeType,_this.search,_this.muscle,_this.equipment,_this.level,_this.category,_this.ourEquipmentOnly,_this.favouritesOnly);
}

@override
String toString() {
  final _this = this as ExerciseFilter;
  return 'ExerciseFilter(search: ${_this.search}, muscle: ${_this.muscle}, equipment: ${_this.equipment}, level: ${_this.level}, category: ${_this.category}, ourEquipmentOnly: ${_this.ourEquipmentOnly}, favouritesOnly: ${_this.favouritesOnly})';
}


}

/// @nodoc
abstract mixin class $ExerciseFilterCopyWith<$Res>  {
  factory $ExerciseFilterCopyWith(ExerciseFilter value, $Res Function(ExerciseFilter) _then) = _$ExerciseFilterCopyWithImpl;
@useResult
$Res call({
 String search, String? muscle, String? equipment, String? level, String? category, bool ourEquipmentOnly, bool favouritesOnly
});




}
/// @nodoc
class _$ExerciseFilterCopyWithImpl<$Res>
    implements $ExerciseFilterCopyWith<$Res> {
  _$ExerciseFilterCopyWithImpl(this._self, this._then);

  final ExerciseFilter _self;
  final $Res Function(ExerciseFilter) _then;

/// Create a copy of ExerciseFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? muscle = freezed,Object? equipment = freezed,Object? level = freezed,Object? category = freezed,Object? ourEquipmentOnly = null,Object? favouritesOnly = null,}) {
  return _then(ExerciseFilter(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,muscle: freezed == muscle ? _self.muscle : muscle // ignore: cast_nullable_to_non_nullable
as String?,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,ourEquipmentOnly: null == ourEquipmentOnly ? _self.ourEquipmentOnly : ourEquipmentOnly // ignore: cast_nullable_to_non_nullable
as bool,favouritesOnly: null == favouritesOnly ? _self.favouritesOnly : favouritesOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseFilter].
extension ExerciseFilterPatterns on ExerciseFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseFilter value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  String? muscle,  String? equipment,  String? level,  String? category,  bool ourEquipmentOnly,  bool favouritesOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseFilter() when $default != null:
return $default(_that.search,_that.muscle,_that.equipment,_that.level,_that.category,_that.ourEquipmentOnly,_that.favouritesOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  String? muscle,  String? equipment,  String? level,  String? category,  bool ourEquipmentOnly,  bool favouritesOnly)  $default,) {final _that = this;
switch (_that) {
case _ExerciseFilter():
return $default(_that.search,_that.muscle,_that.equipment,_that.level,_that.category,_that.ourEquipmentOnly,_that.favouritesOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  String? muscle,  String? equipment,  String? level,  String? category,  bool ourEquipmentOnly,  bool favouritesOnly)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseFilter() when $default != null:
return $default(_that.search,_that.muscle,_that.equipment,_that.level,_that.category,_that.ourEquipmentOnly,_that.favouritesOnly);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseFilter extends ExerciseFilter {
  const _ExerciseFilter({this.search = '', this.muscle, this.equipment, this.level, this.category, this.ourEquipmentOnly = false, this.favouritesOnly = false}): super._();
  

@override@JsonKey() final  String search;
@override final  String? muscle;
@override final  String? equipment;
@override final  String? level;
@override final  String? category;
@override@JsonKey() final  bool ourEquipmentOnly;
@override@JsonKey() final  bool favouritesOnly;

/// Create a copy of ExerciseFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseFilterCopyWith<_ExerciseFilter> get copyWith => __$ExerciseFilterCopyWithImpl<_ExerciseFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseFilter&&(identical(other.search, search) || other.search == search)&&(identical(other.muscle, muscle) || other.muscle == muscle)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.ourEquipmentOnly, ourEquipmentOnly) || other.ourEquipmentOnly == ourEquipmentOnly)&&(identical(other.favouritesOnly, favouritesOnly) || other.favouritesOnly == favouritesOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,search,muscle,equipment,level,category,ourEquipmentOnly,favouritesOnly);
}

@override
String toString() {
    return 'ExerciseFilter(search: $search, muscle: $muscle, equipment: $equipment, level: $level, category: $category, ourEquipmentOnly: $ourEquipmentOnly, favouritesOnly: $favouritesOnly)';
}


}

/// @nodoc
abstract mixin class _$ExerciseFilterCopyWith<$Res> implements $ExerciseFilterCopyWith<$Res> {
  factory _$ExerciseFilterCopyWith(_ExerciseFilter value, $Res Function(_ExerciseFilter) _then) = __$ExerciseFilterCopyWithImpl;
@override @useResult
$Res call({
 String search, String? muscle, String? equipment, String? level, String? category, bool ourEquipmentOnly, bool favouritesOnly
});




}
/// @nodoc
class __$ExerciseFilterCopyWithImpl<$Res>
    implements _$ExerciseFilterCopyWith<$Res> {
  __$ExerciseFilterCopyWithImpl(this._self, this._then);

  final _ExerciseFilter _self;
  final $Res Function(_ExerciseFilter) _then;

/// Create a copy of ExerciseFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? muscle = freezed,Object? equipment = freezed,Object? level = freezed,Object? category = freezed,Object? ourEquipmentOnly = null,Object? favouritesOnly = null,}) {
  return _then(_ExerciseFilter(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,muscle: freezed == muscle ? _self.muscle : muscle // ignore: cast_nullable_to_non_nullable
as String?,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,ourEquipmentOnly: null == ourEquipmentOnly ? _self.ourEquipmentOnly : ourEquipmentOnly // ignore: cast_nullable_to_non_nullable
as bool,favouritesOnly: null == favouritesOnly ? _self.favouritesOnly : favouritesOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
