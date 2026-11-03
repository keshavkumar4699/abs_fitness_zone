// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutItem {

 String? get id;@JsonKey(name: 'exercise_id') String get exerciseId; int get position; Block get block;@JsonKey(name: 'group_key') String? get groupKey; int get sets; int? get reps;@JsonKey(name: 'reps_max') int? get repsMax;@JsonKey(name: 'duration_s') int? get durationS;@JsonKey(name: 'distance_m') int? get distanceM;@JsonKey(name: 'target_weight', fromJson: _num) double? get targetWeight;@JsonKey(fromJson: _num) double? get rpe;@JsonKey(name: 'rest_s') int get restS; String? get tempo; String? get notes;
/// Create a copy of WorkoutItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutItemCopyWith<WorkoutItem> get copyWith => _$WorkoutItemCopyWithImpl<WorkoutItem>(this as WorkoutItem, _$identity);

  /// Serializes this WorkoutItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.block, _this.block) || other.block == _this.block)&&(identical(other.groupKey, _this.groupKey) || other.groupKey == _this.groupKey)&&(identical(other.sets, _this.sets) || other.sets == _this.sets)&&(identical(other.reps, _this.reps) || other.reps == _this.reps)&&(identical(other.repsMax, _this.repsMax) || other.repsMax == _this.repsMax)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.targetWeight, _this.targetWeight) || other.targetWeight == _this.targetWeight)&&(identical(other.rpe, _this.rpe) || other.rpe == _this.rpe)&&(identical(other.restS, _this.restS) || other.restS == _this.restS)&&(identical(other.tempo, _this.tempo) || other.tempo == _this.tempo)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutItem;
  return Object.hash(runtimeType,_this.id,_this.exerciseId,_this.position,_this.block,_this.groupKey,_this.sets,_this.reps,_this.repsMax,_this.durationS,_this.distanceM,_this.targetWeight,_this.rpe,_this.restS,_this.tempo,_this.notes);
}

@override
String toString() {
  final _this = this as WorkoutItem;
  return 'WorkoutItem(id: ${_this.id}, exerciseId: ${_this.exerciseId}, position: ${_this.position}, block: ${_this.block}, groupKey: ${_this.groupKey}, sets: ${_this.sets}, reps: ${_this.reps}, repsMax: ${_this.repsMax}, durationS: ${_this.durationS}, distanceM: ${_this.distanceM}, targetWeight: ${_this.targetWeight}, rpe: ${_this.rpe}, restS: ${_this.restS}, tempo: ${_this.tempo}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $WorkoutItemCopyWith<$Res>  {
  factory $WorkoutItemCopyWith(WorkoutItem value, $Res Function(WorkoutItem) _then) = _$WorkoutItemCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'exercise_id') String exerciseId, int position, Block block,@JsonKey(name: 'group_key') String? groupKey, int sets, int? reps,@JsonKey(name: 'reps_max') int? repsMax,@JsonKey(name: 'duration_s') int? durationS,@JsonKey(name: 'distance_m') int? distanceM,@JsonKey(name: 'target_weight', fromJson: _num) double? targetWeight,@JsonKey(fromJson: _num) double? rpe,@JsonKey(name: 'rest_s') int restS, String? tempo, String? notes
});




}
/// @nodoc
class _$WorkoutItemCopyWithImpl<$Res>
    implements $WorkoutItemCopyWith<$Res> {
  _$WorkoutItemCopyWithImpl(this._self, this._then);

  final WorkoutItem _self;
  final $Res Function(WorkoutItem) _then;

/// Create a copy of WorkoutItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? exerciseId = null,Object? position = null,Object? block = null,Object? groupKey = freezed,Object? sets = null,Object? reps = freezed,Object? repsMax = freezed,Object? durationS = freezed,Object? distanceM = freezed,Object? targetWeight = freezed,Object? rpe = freezed,Object? restS = null,Object? tempo = freezed,Object? notes = freezed,}) {
  return _then(WorkoutItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as Block,groupKey: freezed == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String?,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,repsMax: freezed == repsMax ? _self.repsMax : repsMax // ignore: cast_nullable_to_non_nullable
as int?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,targetWeight: freezed == targetWeight ? _self.targetWeight : targetWeight // ignore: cast_nullable_to_non_nullable
as double?,rpe: freezed == rpe ? _self.rpe : rpe // ignore: cast_nullable_to_non_nullable
as double?,restS: null == restS ? _self.restS : restS // ignore: cast_nullable_to_non_nullable
as int,tempo: freezed == tempo ? _self.tempo : tempo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutItem].
extension WorkoutItemPatterns on WorkoutItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutItem value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutItem value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'exercise_id')  String exerciseId,  int position,  Block block, @JsonKey(name: 'group_key')  String? groupKey,  int sets,  int? reps, @JsonKey(name: 'reps_max')  int? repsMax, @JsonKey(name: 'duration_s')  int? durationS, @JsonKey(name: 'distance_m')  int? distanceM, @JsonKey(name: 'target_weight', fromJson: _num)  double? targetWeight, @JsonKey(fromJson: _num)  double? rpe, @JsonKey(name: 'rest_s')  int restS,  String? tempo,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutItem() when $default != null:
return $default(_that.id,_that.exerciseId,_that.position,_that.block,_that.groupKey,_that.sets,_that.reps,_that.repsMax,_that.durationS,_that.distanceM,_that.targetWeight,_that.rpe,_that.restS,_that.tempo,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'exercise_id')  String exerciseId,  int position,  Block block, @JsonKey(name: 'group_key')  String? groupKey,  int sets,  int? reps, @JsonKey(name: 'reps_max')  int? repsMax, @JsonKey(name: 'duration_s')  int? durationS, @JsonKey(name: 'distance_m')  int? distanceM, @JsonKey(name: 'target_weight', fromJson: _num)  double? targetWeight, @JsonKey(fromJson: _num)  double? rpe, @JsonKey(name: 'rest_s')  int restS,  String? tempo,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _WorkoutItem():
return $default(_that.id,_that.exerciseId,_that.position,_that.block,_that.groupKey,_that.sets,_that.reps,_that.repsMax,_that.durationS,_that.distanceM,_that.targetWeight,_that.rpe,_that.restS,_that.tempo,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'exercise_id')  String exerciseId,  int position,  Block block, @JsonKey(name: 'group_key')  String? groupKey,  int sets,  int? reps, @JsonKey(name: 'reps_max')  int? repsMax, @JsonKey(name: 'duration_s')  int? durationS, @JsonKey(name: 'distance_m')  int? distanceM, @JsonKey(name: 'target_weight', fromJson: _num)  double? targetWeight, @JsonKey(fromJson: _num)  double? rpe, @JsonKey(name: 'rest_s')  int restS,  String? tempo,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutItem() when $default != null:
return $default(_that.id,_that.exerciseId,_that.position,_that.block,_that.groupKey,_that.sets,_that.reps,_that.repsMax,_that.durationS,_that.distanceM,_that.targetWeight,_that.rpe,_that.restS,_that.tempo,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutItem extends WorkoutItem {
  const _WorkoutItem({this.id, @JsonKey(name: 'exercise_id') required this.exerciseId, this.position = 1, this.block = Block.main, @JsonKey(name: 'group_key') this.groupKey, this.sets = 3, this.reps, @JsonKey(name: 'reps_max') this.repsMax, @JsonKey(name: 'duration_s') this.durationS, @JsonKey(name: 'distance_m') this.distanceM, @JsonKey(name: 'target_weight', fromJson: _num) this.targetWeight, @JsonKey(fromJson: _num) this.rpe, @JsonKey(name: 'rest_s') this.restS = 60, this.tempo, this.notes}): super._();
  factory _WorkoutItem.fromJson(Map<String, dynamic> json) => _$WorkoutItemFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'exercise_id') final  String exerciseId;
@override@JsonKey() final  int position;
@override@JsonKey() final  Block block;
@override@JsonKey(name: 'group_key') final  String? groupKey;
@override@JsonKey() final  int sets;
@override final  int? reps;
@override@JsonKey(name: 'reps_max') final  int? repsMax;
@override@JsonKey(name: 'duration_s') final  int? durationS;
@override@JsonKey(name: 'distance_m') final  int? distanceM;
@override@JsonKey(name: 'target_weight', fromJson: _num) final  double? targetWeight;
@override@JsonKey(fromJson: _num) final  double? rpe;
@override@JsonKey(name: 'rest_s') final  int restS;
@override final  String? tempo;
@override final  String? notes;

/// Create a copy of WorkoutItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutItemCopyWith<_WorkoutItem> get copyWith => __$WorkoutItemCopyWithImpl<_WorkoutItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutItem&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.position, position) || other.position == position)&&(identical(other.block, block) || other.block == block)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.sets, sets) || other.sets == sets)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.repsMax, repsMax) || other.repsMax == repsMax)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.targetWeight, targetWeight) || other.targetWeight == targetWeight)&&(identical(other.rpe, rpe) || other.rpe == rpe)&&(identical(other.restS, restS) || other.restS == restS)&&(identical(other.tempo, tempo) || other.tempo == tempo)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,exerciseId,position,block,groupKey,sets,reps,repsMax,durationS,distanceM,targetWeight,rpe,restS,tempo,notes);
}

@override
String toString() {
    return 'WorkoutItem(id: $id, exerciseId: $exerciseId, position: $position, block: $block, groupKey: $groupKey, sets: $sets, reps: $reps, repsMax: $repsMax, durationS: $durationS, distanceM: $distanceM, targetWeight: $targetWeight, rpe: $rpe, restS: $restS, tempo: $tempo, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$WorkoutItemCopyWith<$Res> implements $WorkoutItemCopyWith<$Res> {
  factory _$WorkoutItemCopyWith(_WorkoutItem value, $Res Function(_WorkoutItem) _then) = __$WorkoutItemCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'exercise_id') String exerciseId, int position, Block block,@JsonKey(name: 'group_key') String? groupKey, int sets, int? reps,@JsonKey(name: 'reps_max') int? repsMax,@JsonKey(name: 'duration_s') int? durationS,@JsonKey(name: 'distance_m') int? distanceM,@JsonKey(name: 'target_weight', fromJson: _num) double? targetWeight,@JsonKey(fromJson: _num) double? rpe,@JsonKey(name: 'rest_s') int restS, String? tempo, String? notes
});




}
/// @nodoc
class __$WorkoutItemCopyWithImpl<$Res>
    implements _$WorkoutItemCopyWith<$Res> {
  __$WorkoutItemCopyWithImpl(this._self, this._then);

  final _WorkoutItem _self;
  final $Res Function(_WorkoutItem) _then;

/// Create a copy of WorkoutItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? exerciseId = null,Object? position = null,Object? block = null,Object? groupKey = freezed,Object? sets = null,Object? reps = freezed,Object? repsMax = freezed,Object? durationS = freezed,Object? distanceM = freezed,Object? targetWeight = freezed,Object? rpe = freezed,Object? restS = null,Object? tempo = freezed,Object? notes = freezed,}) {
  return _then(_WorkoutItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as Block,groupKey: freezed == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String?,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as int,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,repsMax: freezed == repsMax ? _self.repsMax : repsMax // ignore: cast_nullable_to_non_nullable
as int?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,targetWeight: freezed == targetWeight ? _self.targetWeight : targetWeight // ignore: cast_nullable_to_non_nullable
as double?,rpe: freezed == rpe ? _self.rpe : rpe // ignore: cast_nullable_to_non_nullable
as double?,restS: null == restS ? _self.restS : restS // ignore: cast_nullable_to_non_nullable
as int,tempo: freezed == tempo ? _self.tempo : tempo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WorkoutDay {

 String? get id;@JsonKey(name: 'day_index') int get dayIndex; String get name; String? get notes;@JsonKey(name: 'workout_items') List<WorkoutItem> get items;
/// Create a copy of WorkoutDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutDayCopyWith<WorkoutDay> get copyWith => _$WorkoutDayCopyWithImpl<WorkoutDay>(this as WorkoutDay, _$identity);

  /// Serializes this WorkoutDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutDay&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.dayIndex, _this.dayIndex) || other.dayIndex == _this.dayIndex)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutDay;
  return Object.hash(runtimeType,_this.id,_this.dayIndex,_this.name,_this.notes,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as WorkoutDay;
  return 'WorkoutDay(id: ${_this.id}, dayIndex: ${_this.dayIndex}, name: ${_this.name}, notes: ${_this.notes}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $WorkoutDayCopyWith<$Res>  {
  factory $WorkoutDayCopyWith(WorkoutDay value, $Res Function(WorkoutDay) _then) = _$WorkoutDayCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'day_index') int dayIndex, String name, String? notes,@JsonKey(name: 'workout_items') List<WorkoutItem> items
});




}
/// @nodoc
class _$WorkoutDayCopyWithImpl<$Res>
    implements $WorkoutDayCopyWith<$Res> {
  _$WorkoutDayCopyWithImpl(this._self, this._then);

  final WorkoutDay _self;
  final $Res Function(WorkoutDay) _then;

/// Create a copy of WorkoutDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? dayIndex = null,Object? name = null,Object? notes = freezed,Object? items = null,}) {
  return _then(WorkoutDay(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WorkoutItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutDay].
extension WorkoutDayPatterns on WorkoutDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutDay value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutDay value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'day_index')  int dayIndex,  String name,  String? notes, @JsonKey(name: 'workout_items')  List<WorkoutItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutDay() when $default != null:
return $default(_that.id,_that.dayIndex,_that.name,_that.notes,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'day_index')  int dayIndex,  String name,  String? notes, @JsonKey(name: 'workout_items')  List<WorkoutItem> items)  $default,) {final _that = this;
switch (_that) {
case _WorkoutDay():
return $default(_that.id,_that.dayIndex,_that.name,_that.notes,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'day_index')  int dayIndex,  String name,  String? notes, @JsonKey(name: 'workout_items')  List<WorkoutItem> items)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutDay() when $default != null:
return $default(_that.id,_that.dayIndex,_that.name,_that.notes,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutDay extends WorkoutDay {
  const _WorkoutDay({this.id, @JsonKey(name: 'day_index') this.dayIndex = 1, required this.name, this.notes, @JsonKey(name: 'workout_items')  List<WorkoutItem> items = const <WorkoutItem>[]}): _items = items,super._();
  factory _WorkoutDay.fromJson(Map<String, dynamic> json) => _$WorkoutDayFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'day_index') final  int dayIndex;
@override final  String name;
@override final  String? notes;
 final  List<WorkoutItem> _items;
@override@JsonKey(name: 'workout_items') List<WorkoutItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of WorkoutDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutDayCopyWith<_WorkoutDay> get copyWith => __$WorkoutDayCopyWithImpl<_WorkoutDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutDay&&(identical(other.id, id) || other.id == id)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.name, name) || other.name == name)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,dayIndex,name,notes,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'WorkoutDay(id: $id, dayIndex: $dayIndex, name: $name, notes: $notes, items: $items)';
}


}

/// @nodoc
abstract mixin class _$WorkoutDayCopyWith<$Res> implements $WorkoutDayCopyWith<$Res> {
  factory _$WorkoutDayCopyWith(_WorkoutDay value, $Res Function(_WorkoutDay) _then) = __$WorkoutDayCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'day_index') int dayIndex, String name, String? notes,@JsonKey(name: 'workout_items') List<WorkoutItem> items
});




}
/// @nodoc
class __$WorkoutDayCopyWithImpl<$Res>
    implements _$WorkoutDayCopyWith<$Res> {
  __$WorkoutDayCopyWithImpl(this._self, this._then);

  final _WorkoutDay _self;
  final $Res Function(_WorkoutDay) _then;

/// Create a copy of WorkoutDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? dayIndex = null,Object? name = null,Object? notes = freezed,Object? items = null,}) {
  return _then(_WorkoutDay(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WorkoutItem>,
  ));
}


}


/// @nodoc
mixin _$WorkoutTemplate {

 String? get id; String get name; String? get description; String? get goal; String? get level; int get weeks; Progression get progression;@JsonKey(name: 'progression_step', fromJson: _num) double? get progressionStep;@JsonKey(name: 'is_gym_template') bool get isGymTemplate;@JsonKey(name: 'is_starter') bool get isStarter;@JsonKey(name: 'source_template_id') String? get sourceTemplateId;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'workout_days') List<WorkoutDay> get days;
/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutTemplateCopyWith<WorkoutTemplate> get copyWith => _$WorkoutTemplateCopyWithImpl<WorkoutTemplate>(this as WorkoutTemplate, _$identity);

  /// Serializes this WorkoutTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutTemplate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.weeks, _this.weeks) || other.weeks == _this.weeks)&&(identical(other.progression, _this.progression) || other.progression == _this.progression)&&(identical(other.progressionStep, _this.progressionStep) || other.progressionStep == _this.progressionStep)&&(identical(other.isGymTemplate, _this.isGymTemplate) || other.isGymTemplate == _this.isGymTemplate)&&(identical(other.isStarter, _this.isStarter) || other.isStarter == _this.isStarter)&&(identical(other.sourceTemplateId, _this.sourceTemplateId) || other.sourceTemplateId == _this.sourceTemplateId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&const DeepCollectionEquality().equals(other.days, _this.days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutTemplate;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.goal,_this.level,_this.weeks,_this.progression,_this.progressionStep,_this.isGymTemplate,_this.isStarter,_this.sourceTemplateId,_this.createdBy,const DeepCollectionEquality().hash(_this.days));
}

@override
String toString() {
  final _this = this as WorkoutTemplate;
  return 'WorkoutTemplate(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, goal: ${_this.goal}, level: ${_this.level}, weeks: ${_this.weeks}, progression: ${_this.progression}, progressionStep: ${_this.progressionStep}, isGymTemplate: ${_this.isGymTemplate}, isStarter: ${_this.isStarter}, sourceTemplateId: ${_this.sourceTemplateId}, createdBy: ${_this.createdBy}, days: ${_this.days})';
}


}

/// @nodoc
abstract mixin class $WorkoutTemplateCopyWith<$Res>  {
  factory $WorkoutTemplateCopyWith(WorkoutTemplate value, $Res Function(WorkoutTemplate) _then) = _$WorkoutTemplateCopyWithImpl;
@useResult
$Res call({
 String? id, String name, String? description, String? goal, String? level, int weeks, Progression progression,@JsonKey(name: 'progression_step', fromJson: _num) double? progressionStep,@JsonKey(name: 'is_gym_template') bool isGymTemplate,@JsonKey(name: 'is_starter') bool isStarter,@JsonKey(name: 'source_template_id') String? sourceTemplateId,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'workout_days') List<WorkoutDay> days
});




}
/// @nodoc
class _$WorkoutTemplateCopyWithImpl<$Res>
    implements $WorkoutTemplateCopyWith<$Res> {
  _$WorkoutTemplateCopyWithImpl(this._self, this._then);

  final WorkoutTemplate _self;
  final $Res Function(WorkoutTemplate) _then;

/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? goal = freezed,Object? level = freezed,Object? weeks = null,Object? progression = null,Object? progressionStep = freezed,Object? isGymTemplate = null,Object? isStarter = null,Object? sourceTemplateId = freezed,Object? createdBy = freezed,Object? days = null,}) {
  return _then(WorkoutTemplate(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,weeks: null == weeks ? _self.weeks : weeks // ignore: cast_nullable_to_non_nullable
as int,progression: null == progression ? _self.progression : progression // ignore: cast_nullable_to_non_nullable
as Progression,progressionStep: freezed == progressionStep ? _self.progressionStep : progressionStep // ignore: cast_nullable_to_non_nullable
as double?,isGymTemplate: null == isGymTemplate ? _self.isGymTemplate : isGymTemplate // ignore: cast_nullable_to_non_nullable
as bool,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<WorkoutDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutTemplate].
extension WorkoutTemplatePatterns on WorkoutTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutTemplate value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  String? description,  String? goal,  String? level,  int weeks,  Progression progression, @JsonKey(name: 'progression_step', fromJson: _num)  double? progressionStep, @JsonKey(name: 'is_gym_template')  bool isGymTemplate, @JsonKey(name: 'is_starter')  bool isStarter, @JsonKey(name: 'source_template_id')  String? sourceTemplateId, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'workout_days')  List<WorkoutDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.goal,_that.level,_that.weeks,_that.progression,_that.progressionStep,_that.isGymTemplate,_that.isStarter,_that.sourceTemplateId,_that.createdBy,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  String? description,  String? goal,  String? level,  int weeks,  Progression progression, @JsonKey(name: 'progression_step', fromJson: _num)  double? progressionStep, @JsonKey(name: 'is_gym_template')  bool isGymTemplate, @JsonKey(name: 'is_starter')  bool isStarter, @JsonKey(name: 'source_template_id')  String? sourceTemplateId, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'workout_days')  List<WorkoutDay> days)  $default,) {final _that = this;
switch (_that) {
case _WorkoutTemplate():
return $default(_that.id,_that.name,_that.description,_that.goal,_that.level,_that.weeks,_that.progression,_that.progressionStep,_that.isGymTemplate,_that.isStarter,_that.sourceTemplateId,_that.createdBy,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  String? description,  String? goal,  String? level,  int weeks,  Progression progression, @JsonKey(name: 'progression_step', fromJson: _num)  double? progressionStep, @JsonKey(name: 'is_gym_template')  bool isGymTemplate, @JsonKey(name: 'is_starter')  bool isStarter, @JsonKey(name: 'source_template_id')  String? sourceTemplateId, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'workout_days')  List<WorkoutDay> days)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.goal,_that.level,_that.weeks,_that.progression,_that.progressionStep,_that.isGymTemplate,_that.isStarter,_that.sourceTemplateId,_that.createdBy,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutTemplate extends WorkoutTemplate {
  const _WorkoutTemplate({this.id, required this.name, this.description, this.goal, this.level, this.weeks = 4, this.progression = Progression.none, @JsonKey(name: 'progression_step', fromJson: _num) this.progressionStep = 0, @JsonKey(name: 'is_gym_template') this.isGymTemplate = true, @JsonKey(name: 'is_starter') this.isStarter = false, @JsonKey(name: 'source_template_id') this.sourceTemplateId, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'workout_days')  List<WorkoutDay> days = const <WorkoutDay>[]}): _days = days,super._();
  factory _WorkoutTemplate.fromJson(Map<String, dynamic> json) => _$WorkoutTemplateFromJson(json);

@override final  String? id;
@override final  String name;
@override final  String? description;
@override final  String? goal;
@override final  String? level;
@override@JsonKey() final  int weeks;
@override@JsonKey() final  Progression progression;
@override@JsonKey(name: 'progression_step', fromJson: _num) final  double? progressionStep;
@override@JsonKey(name: 'is_gym_template') final  bool isGymTemplate;
@override@JsonKey(name: 'is_starter') final  bool isStarter;
@override@JsonKey(name: 'source_template_id') final  String? sourceTemplateId;
@override@JsonKey(name: 'created_by') final  String? createdBy;
 final  List<WorkoutDay> _days;
@override@JsonKey(name: 'workout_days') List<WorkoutDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutTemplateCopyWith<_WorkoutTemplate> get copyWith => __$WorkoutTemplateCopyWithImpl<_WorkoutTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.level, level) || other.level == level)&&(identical(other.weeks, weeks) || other.weeks == weeks)&&(identical(other.progression, progression) || other.progression == progression)&&(identical(other.progressionStep, progressionStep) || other.progressionStep == progressionStep)&&(identical(other.isGymTemplate, isGymTemplate) || other.isGymTemplate == isGymTemplate)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.sourceTemplateId, sourceTemplateId) || other.sourceTemplateId == sourceTemplateId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other.days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,goal,level,weeks,progression,progressionStep,isGymTemplate,isStarter,sourceTemplateId,createdBy,const DeepCollectionEquality().hash(_days));
}

@override
String toString() {
    return 'WorkoutTemplate(id: $id, name: $name, description: $description, goal: $goal, level: $level, weeks: $weeks, progression: $progression, progressionStep: $progressionStep, isGymTemplate: $isGymTemplate, isStarter: $isStarter, sourceTemplateId: $sourceTemplateId, createdBy: $createdBy, days: $days)';
}


}

/// @nodoc
abstract mixin class _$WorkoutTemplateCopyWith<$Res> implements $WorkoutTemplateCopyWith<$Res> {
  factory _$WorkoutTemplateCopyWith(_WorkoutTemplate value, $Res Function(_WorkoutTemplate) _then) = __$WorkoutTemplateCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, String? description, String? goal, String? level, int weeks, Progression progression,@JsonKey(name: 'progression_step', fromJson: _num) double? progressionStep,@JsonKey(name: 'is_gym_template') bool isGymTemplate,@JsonKey(name: 'is_starter') bool isStarter,@JsonKey(name: 'source_template_id') String? sourceTemplateId,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'workout_days') List<WorkoutDay> days
});




}
/// @nodoc
class __$WorkoutTemplateCopyWithImpl<$Res>
    implements _$WorkoutTemplateCopyWith<$Res> {
  __$WorkoutTemplateCopyWithImpl(this._self, this._then);

  final _WorkoutTemplate _self;
  final $Res Function(_WorkoutTemplate) _then;

/// Create a copy of WorkoutTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? goal = freezed,Object? level = freezed,Object? weeks = null,Object? progression = null,Object? progressionStep = freezed,Object? isGymTemplate = null,Object? isStarter = null,Object? sourceTemplateId = freezed,Object? createdBy = freezed,Object? days = null,}) {
  return _then(_WorkoutTemplate(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,weeks: null == weeks ? _self.weeks : weeks // ignore: cast_nullable_to_non_nullable
as int,progression: null == progression ? _self.progression : progression // ignore: cast_nullable_to_non_nullable
as Progression,progressionStep: freezed == progressionStep ? _self.progressionStep : progressionStep // ignore: cast_nullable_to_non_nullable
as double?,isGymTemplate: null == isGymTemplate ? _self.isGymTemplate : isGymTemplate // ignore: cast_nullable_to_non_nullable
as bool,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<WorkoutDay>,
  ));
}


}


/// @nodoc
mixin _$MemberProgram {

 String get id;@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'template_id') String get templateId;@JsonKey(name: 'source_template_id') String? get sourceTemplateId; String get name;@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? get startDate;@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? get endDate; List<int> get weekdays; ProgramStatus get status;@JsonKey(name: 'assigned_at') DateTime? get assignedAt; WorkoutTemplate? get template;
/// Create a copy of MemberProgram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberProgramCopyWith<MemberProgram> get copyWith => _$MemberProgramCopyWithImpl<MemberProgram>(this as MemberProgram, _$identity);

  /// Serializes this MemberProgram to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemberProgram;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProgram&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.templateId, _this.templateId) || other.templateId == _this.templateId)&&(identical(other.sourceTemplateId, _this.sourceTemplateId) || other.sourceTemplateId == _this.sourceTemplateId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.assignedAt, _this.assignedAt) || other.assignedAt == _this.assignedAt)&&(identical(other.template, _this.template) || other.template == _this.template));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemberProgram;
  return Object.hash(runtimeType,_this.id,_this.memberId,_this.templateId,_this.sourceTemplateId,_this.name,_this.startDate,_this.endDate,const DeepCollectionEquality().hash(_this.weekdays),_this.status,_this.assignedAt,_this.template);
}

@override
String toString() {
  final _this = this as MemberProgram;
  return 'MemberProgram(id: ${_this.id}, memberId: ${_this.memberId}, templateId: ${_this.templateId}, sourceTemplateId: ${_this.sourceTemplateId}, name: ${_this.name}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, weekdays: ${_this.weekdays}, status: ${_this.status}, assignedAt: ${_this.assignedAt}, template: ${_this.template})';
}


}

/// @nodoc
abstract mixin class $MemberProgramCopyWith<$Res>  {
  factory $MemberProgramCopyWith(MemberProgram value, $Res Function(MemberProgram) _then) = _$MemberProgramCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'template_id') String templateId,@JsonKey(name: 'source_template_id') String? sourceTemplateId, String name,@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? startDate,@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? endDate, List<int> weekdays, ProgramStatus status,@JsonKey(name: 'assigned_at') DateTime? assignedAt, WorkoutTemplate? template
});


$WorkoutTemplateCopyWith<$Res>? get template;

}
/// @nodoc
class _$MemberProgramCopyWithImpl<$Res>
    implements $MemberProgramCopyWith<$Res> {
  _$MemberProgramCopyWithImpl(this._self, this._then);

  final MemberProgram _self;
  final $Res Function(MemberProgram) _then;

/// Create a copy of MemberProgram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? templateId = null,Object? sourceTemplateId = freezed,Object? name = null,Object? startDate = freezed,Object? endDate = freezed,Object? weekdays = null,Object? status = null,Object? assignedAt = freezed,Object? template = freezed,}) {
  return _then(MemberProgram(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProgramStatus,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as WorkoutTemplate?,
  ));
}
/// Create a copy of MemberProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutTemplateCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $WorkoutTemplateCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}


/// Adds pattern-matching-related methods to [MemberProgram].
extension MemberProgramPatterns on MemberProgram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberProgram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberProgram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberProgram value)  $default,){
final _that = this;
switch (_that) {
case _MemberProgram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberProgram value)?  $default,){
final _that = this;
switch (_that) {
case _MemberProgram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_id')  String templateId, @JsonKey(name: 'source_template_id')  String? sourceTemplateId,  String name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate,  List<int> weekdays,  ProgramStatus status, @JsonKey(name: 'assigned_at')  DateTime? assignedAt,  WorkoutTemplate? template)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberProgram() when $default != null:
return $default(_that.id,_that.memberId,_that.templateId,_that.sourceTemplateId,_that.name,_that.startDate,_that.endDate,_that.weekdays,_that.status,_that.assignedAt,_that.template);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_id')  String templateId, @JsonKey(name: 'source_template_id')  String? sourceTemplateId,  String name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate,  List<int> weekdays,  ProgramStatus status, @JsonKey(name: 'assigned_at')  DateTime? assignedAt,  WorkoutTemplate? template)  $default,) {final _that = this;
switch (_that) {
case _MemberProgram():
return $default(_that.id,_that.memberId,_that.templateId,_that.sourceTemplateId,_that.name,_that.startDate,_that.endDate,_that.weekdays,_that.status,_that.assignedAt,_that.template);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_id')  String templateId, @JsonKey(name: 'source_template_id')  String? sourceTemplateId,  String name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate,  List<int> weekdays,  ProgramStatus status, @JsonKey(name: 'assigned_at')  DateTime? assignedAt,  WorkoutTemplate? template)?  $default,) {final _that = this;
switch (_that) {
case _MemberProgram() when $default != null:
return $default(_that.id,_that.memberId,_that.templateId,_that.sourceTemplateId,_that.name,_that.startDate,_that.endDate,_that.weekdays,_that.status,_that.assignedAt,_that.template);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberProgram extends MemberProgram {
  const _MemberProgram({required this.id, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'template_id') required this.templateId, @JsonKey(name: 'source_template_id') this.sourceTemplateId, required this.name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) required this.startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) required this.endDate,  List<int> weekdays = const <int>[], this.status = ProgramStatus.active, @JsonKey(name: 'assigned_at') this.assignedAt, this.template}): _weekdays = weekdays,super._();
  factory _MemberProgram.fromJson(Map<String, dynamic> json) => _$MemberProgramFromJson(json);

@override final  String id;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'template_id') final  String templateId;
@override@JsonKey(name: 'source_template_id') final  String? sourceTemplateId;
@override final  String name;
@override@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) final  DateTime? startDate;
@override@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) final  DateTime? endDate;
 final  List<int> _weekdays;
@override@JsonKey() List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

@override@JsonKey() final  ProgramStatus status;
@override@JsonKey(name: 'assigned_at') final  DateTime? assignedAt;
@override final  WorkoutTemplate? template;

/// Create a copy of MemberProgram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberProgramCopyWith<_MemberProgram> get copyWith => __$MemberProgramCopyWithImpl<_MemberProgram>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberProgramToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberProgram&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.sourceTemplateId, sourceTemplateId) || other.sourceTemplateId == sourceTemplateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.template, template) || other.template == template));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,memberId,templateId,sourceTemplateId,name,startDate,endDate,const DeepCollectionEquality().hash(_weekdays),status,assignedAt,template);
}

@override
String toString() {
    return 'MemberProgram(id: $id, memberId: $memberId, templateId: $templateId, sourceTemplateId: $sourceTemplateId, name: $name, startDate: $startDate, endDate: $endDate, weekdays: $weekdays, status: $status, assignedAt: $assignedAt, template: $template)';
}


}

/// @nodoc
abstract mixin class _$MemberProgramCopyWith<$Res> implements $MemberProgramCopyWith<$Res> {
  factory _$MemberProgramCopyWith(_MemberProgram value, $Res Function(_MemberProgram) _then) = __$MemberProgramCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'template_id') String templateId,@JsonKey(name: 'source_template_id') String? sourceTemplateId, String name,@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? startDate,@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? endDate, List<int> weekdays, ProgramStatus status,@JsonKey(name: 'assigned_at') DateTime? assignedAt, WorkoutTemplate? template
});


@override $WorkoutTemplateCopyWith<$Res>? get template;

}
/// @nodoc
class __$MemberProgramCopyWithImpl<$Res>
    implements _$MemberProgramCopyWith<$Res> {
  __$MemberProgramCopyWithImpl(this._self, this._then);

  final _MemberProgram _self;
  final $Res Function(_MemberProgram) _then;

/// Create a copy of MemberProgram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? templateId = null,Object? sourceTemplateId = freezed,Object? name = null,Object? startDate = freezed,Object? endDate = freezed,Object? weekdays = null,Object? status = null,Object? assignedAt = freezed,Object? template = freezed,}) {
  return _then(_MemberProgram(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProgramStatus,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as WorkoutTemplate?,
  ));
}

/// Create a copy of MemberProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutTemplateCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $WorkoutTemplateCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}


/// @nodoc
mixin _$SetLog {

 String? get id;@JsonKey(name: 'exercise_id') String get exerciseId;@JsonKey(name: 'set_no') int get setNo;@JsonKey(fromJson: _num) double? get weight; int? get reps;@JsonKey(name: 'duration_s') int? get durationS;@JsonKey(name: 'distance_m') int? get distanceM;@JsonKey(fromJson: _num) double? get e1rm;@JsonKey(name: 'is_pr') bool get isPr;@JsonKey(name: 'pr_kinds') List<String> get prKinds;@JsonKey(name: 'done_at') DateTime? get doneAt;
/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetLogCopyWith<SetLog> get copyWith => _$SetLogCopyWithImpl<SetLog>(this as SetLog, _$identity);

  /// Serializes this SetLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.setNo, _this.setNo) || other.setNo == _this.setNo)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.reps, _this.reps) || other.reps == _this.reps)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.e1rm, _this.e1rm) || other.e1rm == _this.e1rm)&&(identical(other.isPr, _this.isPr) || other.isPr == _this.isPr)&&const DeepCollectionEquality().equals(other.prKinds, _this.prKinds)&&(identical(other.doneAt, _this.doneAt) || other.doneAt == _this.doneAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetLog;
  return Object.hash(runtimeType,_this.id,_this.exerciseId,_this.setNo,_this.weight,_this.reps,_this.durationS,_this.distanceM,_this.e1rm,_this.isPr,const DeepCollectionEquality().hash(_this.prKinds),_this.doneAt);
}

@override
String toString() {
  final _this = this as SetLog;
  return 'SetLog(id: ${_this.id}, exerciseId: ${_this.exerciseId}, setNo: ${_this.setNo}, weight: ${_this.weight}, reps: ${_this.reps}, durationS: ${_this.durationS}, distanceM: ${_this.distanceM}, e1rm: ${_this.e1rm}, isPr: ${_this.isPr}, prKinds: ${_this.prKinds}, doneAt: ${_this.doneAt})';
}


}

/// @nodoc
abstract mixin class $SetLogCopyWith<$Res>  {
  factory $SetLogCopyWith(SetLog value, $Res Function(SetLog) _then) = _$SetLogCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'exercise_id') String exerciseId,@JsonKey(name: 'set_no') int setNo,@JsonKey(fromJson: _num) double? weight, int? reps,@JsonKey(name: 'duration_s') int? durationS,@JsonKey(name: 'distance_m') int? distanceM,@JsonKey(fromJson: _num) double? e1rm,@JsonKey(name: 'is_pr') bool isPr,@JsonKey(name: 'pr_kinds') List<String> prKinds,@JsonKey(name: 'done_at') DateTime? doneAt
});




}
/// @nodoc
class _$SetLogCopyWithImpl<$Res>
    implements $SetLogCopyWith<$Res> {
  _$SetLogCopyWithImpl(this._self, this._then);

  final SetLog _self;
  final $Res Function(SetLog) _then;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? exerciseId = null,Object? setNo = null,Object? weight = freezed,Object? reps = freezed,Object? durationS = freezed,Object? distanceM = freezed,Object? e1rm = freezed,Object? isPr = null,Object? prKinds = null,Object? doneAt = freezed,}) {
  return _then(SetLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,setNo: null == setNo ? _self.setNo : setNo // ignore: cast_nullable_to_non_nullable
as int,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,e1rm: freezed == e1rm ? _self.e1rm : e1rm // ignore: cast_nullable_to_non_nullable
as double?,isPr: null == isPr ? _self.isPr : isPr // ignore: cast_nullable_to_non_nullable
as bool,prKinds: null == prKinds ? _self.prKinds : prKinds // ignore: cast_nullable_to_non_nullable
as List<String>,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetLog].
extension SetLogPatterns on SetLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetLog value)  $default,){
final _that = this;
switch (_that) {
case _SetLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetLog value)?  $default,){
final _that = this;
switch (_that) {
case _SetLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'exercise_id')  String exerciseId, @JsonKey(name: 'set_no')  int setNo, @JsonKey(fromJson: _num)  double? weight,  int? reps, @JsonKey(name: 'duration_s')  int? durationS, @JsonKey(name: 'distance_m')  int? distanceM, @JsonKey(fromJson: _num)  double? e1rm, @JsonKey(name: 'is_pr')  bool isPr, @JsonKey(name: 'pr_kinds')  List<String> prKinds, @JsonKey(name: 'done_at')  DateTime? doneAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetLog() when $default != null:
return $default(_that.id,_that.exerciseId,_that.setNo,_that.weight,_that.reps,_that.durationS,_that.distanceM,_that.e1rm,_that.isPr,_that.prKinds,_that.doneAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'exercise_id')  String exerciseId, @JsonKey(name: 'set_no')  int setNo, @JsonKey(fromJson: _num)  double? weight,  int? reps, @JsonKey(name: 'duration_s')  int? durationS, @JsonKey(name: 'distance_m')  int? distanceM, @JsonKey(fromJson: _num)  double? e1rm, @JsonKey(name: 'is_pr')  bool isPr, @JsonKey(name: 'pr_kinds')  List<String> prKinds, @JsonKey(name: 'done_at')  DateTime? doneAt)  $default,) {final _that = this;
switch (_that) {
case _SetLog():
return $default(_that.id,_that.exerciseId,_that.setNo,_that.weight,_that.reps,_that.durationS,_that.distanceM,_that.e1rm,_that.isPr,_that.prKinds,_that.doneAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'exercise_id')  String exerciseId, @JsonKey(name: 'set_no')  int setNo, @JsonKey(fromJson: _num)  double? weight,  int? reps, @JsonKey(name: 'duration_s')  int? durationS, @JsonKey(name: 'distance_m')  int? distanceM, @JsonKey(fromJson: _num)  double? e1rm, @JsonKey(name: 'is_pr')  bool isPr, @JsonKey(name: 'pr_kinds')  List<String> prKinds, @JsonKey(name: 'done_at')  DateTime? doneAt)?  $default,) {final _that = this;
switch (_that) {
case _SetLog() when $default != null:
return $default(_that.id,_that.exerciseId,_that.setNo,_that.weight,_that.reps,_that.durationS,_that.distanceM,_that.e1rm,_that.isPr,_that.prKinds,_that.doneAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetLog extends SetLog {
  const _SetLog({this.id, @JsonKey(name: 'exercise_id') required this.exerciseId, @JsonKey(name: 'set_no') required this.setNo, @JsonKey(fromJson: _num) this.weight, this.reps, @JsonKey(name: 'duration_s') this.durationS, @JsonKey(name: 'distance_m') this.distanceM, @JsonKey(fromJson: _num) this.e1rm, @JsonKey(name: 'is_pr') this.isPr = false, @JsonKey(name: 'pr_kinds')  List<String> prKinds = const <String>[], @JsonKey(name: 'done_at') this.doneAt}): _prKinds = prKinds,super._();
  factory _SetLog.fromJson(Map<String, dynamic> json) => _$SetLogFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'exercise_id') final  String exerciseId;
@override@JsonKey(name: 'set_no') final  int setNo;
@override@JsonKey(fromJson: _num) final  double? weight;
@override final  int? reps;
@override@JsonKey(name: 'duration_s') final  int? durationS;
@override@JsonKey(name: 'distance_m') final  int? distanceM;
@override@JsonKey(fromJson: _num) final  double? e1rm;
@override@JsonKey(name: 'is_pr') final  bool isPr;
 final  List<String> _prKinds;
@override@JsonKey(name: 'pr_kinds') List<String> get prKinds {
  if (_prKinds is EqualUnmodifiableListView) return _prKinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prKinds);
}

@override@JsonKey(name: 'done_at') final  DateTime? doneAt;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetLogCopyWith<_SetLog> get copyWith => __$SetLogCopyWithImpl<_SetLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetLog&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.setNo, setNo) || other.setNo == setNo)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.e1rm, e1rm) || other.e1rm == e1rm)&&(identical(other.isPr, isPr) || other.isPr == isPr)&&const DeepCollectionEquality().equals(other.prKinds, _prKinds)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,exerciseId,setNo,weight,reps,durationS,distanceM,e1rm,isPr,const DeepCollectionEquality().hash(_prKinds),doneAt);
}

@override
String toString() {
    return 'SetLog(id: $id, exerciseId: $exerciseId, setNo: $setNo, weight: $weight, reps: $reps, durationS: $durationS, distanceM: $distanceM, e1rm: $e1rm, isPr: $isPr, prKinds: $prKinds, doneAt: $doneAt)';
}


}

/// @nodoc
abstract mixin class _$SetLogCopyWith<$Res> implements $SetLogCopyWith<$Res> {
  factory _$SetLogCopyWith(_SetLog value, $Res Function(_SetLog) _then) = __$SetLogCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'exercise_id') String exerciseId,@JsonKey(name: 'set_no') int setNo,@JsonKey(fromJson: _num) double? weight, int? reps,@JsonKey(name: 'duration_s') int? durationS,@JsonKey(name: 'distance_m') int? distanceM,@JsonKey(fromJson: _num) double? e1rm,@JsonKey(name: 'is_pr') bool isPr,@JsonKey(name: 'pr_kinds') List<String> prKinds,@JsonKey(name: 'done_at') DateTime? doneAt
});




}
/// @nodoc
class __$SetLogCopyWithImpl<$Res>
    implements _$SetLogCopyWith<$Res> {
  __$SetLogCopyWithImpl(this._self, this._then);

  final _SetLog _self;
  final $Res Function(_SetLog) _then;

/// Create a copy of SetLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? exerciseId = null,Object? setNo = null,Object? weight = freezed,Object? reps = freezed,Object? durationS = freezed,Object? distanceM = freezed,Object? e1rm = freezed,Object? isPr = null,Object? prKinds = null,Object? doneAt = freezed,}) {
  return _then(_SetLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,setNo: null == setNo ? _self.setNo : setNo // ignore: cast_nullable_to_non_nullable
as int,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,e1rm: freezed == e1rm ? _self.e1rm : e1rm // ignore: cast_nullable_to_non_nullable
as double?,isPr: null == isPr ? _self.isPr : isPr // ignore: cast_nullable_to_non_nullable
as bool,prKinds: null == prKinds ? _self._prKinds : prKinds // ignore: cast_nullable_to_non_nullable
as List<String>,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WorkoutComment {

 String get id;@JsonKey(name: 'author_name') String get authorName; String? get body; String? get emoji;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of WorkoutComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutCommentCopyWith<WorkoutComment> get copyWith => _$WorkoutCommentCopyWithImpl<WorkoutComment>(this as WorkoutComment, _$identity);

  /// Serializes this WorkoutComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutComment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutComment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.emoji, _this.emoji) || other.emoji == _this.emoji)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutComment;
  return Object.hash(runtimeType,_this.id,_this.authorName,_this.body,_this.emoji,_this.createdAt);
}

@override
String toString() {
  final _this = this as WorkoutComment;
  return 'WorkoutComment(id: ${_this.id}, authorName: ${_this.authorName}, body: ${_this.body}, emoji: ${_this.emoji}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $WorkoutCommentCopyWith<$Res>  {
  factory $WorkoutCommentCopyWith(WorkoutComment value, $Res Function(WorkoutComment) _then) = _$WorkoutCommentCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'author_name') String authorName, String? body, String? emoji,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$WorkoutCommentCopyWithImpl<$Res>
    implements $WorkoutCommentCopyWith<$Res> {
  _$WorkoutCommentCopyWithImpl(this._self, this._then);

  final WorkoutComment _self;
  final $Res Function(WorkoutComment) _then;

/// Create a copy of WorkoutComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorName = null,Object? body = freezed,Object? emoji = freezed,Object? createdAt = null,}) {
  return _then(WorkoutComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutComment].
extension WorkoutCommentPatterns on WorkoutComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutComment value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutComment value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'author_name')  String authorName,  String? body,  String? emoji, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutComment() when $default != null:
return $default(_that.id,_that.authorName,_that.body,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'author_name')  String authorName,  String? body,  String? emoji, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WorkoutComment():
return $default(_that.id,_that.authorName,_that.body,_that.emoji,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'author_name')  String authorName,  String? body,  String? emoji, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutComment() when $default != null:
return $default(_that.id,_that.authorName,_that.body,_that.emoji,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutComment implements WorkoutComment {
  const _WorkoutComment({required this.id, @JsonKey(name: 'author_name') required this.authorName, this.body, this.emoji, @JsonKey(name: 'created_at') required this.createdAt});
  factory _WorkoutComment.fromJson(Map<String, dynamic> json) => _$WorkoutCommentFromJson(json);

@override final  String id;
@override@JsonKey(name: 'author_name') final  String authorName;
@override final  String? body;
@override final  String? emoji;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of WorkoutComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutCommentCopyWith<_WorkoutComment> get copyWith => __$WorkoutCommentCopyWithImpl<_WorkoutComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutComment&&(identical(other.id, id) || other.id == id)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,authorName,body,emoji,createdAt);
}

@override
String toString() {
    return 'WorkoutComment(id: $id, authorName: $authorName, body: $body, emoji: $emoji, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WorkoutCommentCopyWith<$Res> implements $WorkoutCommentCopyWith<$Res> {
  factory _$WorkoutCommentCopyWith(_WorkoutComment value, $Res Function(_WorkoutComment) _then) = __$WorkoutCommentCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'author_name') String authorName, String? body, String? emoji,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$WorkoutCommentCopyWithImpl<$Res>
    implements _$WorkoutCommentCopyWith<$Res> {
  __$WorkoutCommentCopyWithImpl(this._self, this._then);

  final _WorkoutComment _self;
  final $Res Function(_WorkoutComment) _then;

/// Create a copy of WorkoutComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorName = null,Object? body = freezed,Object? emoji = freezed,Object? createdAt = null,}) {
  return _then(_WorkoutComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WorkoutLog {

 String get id;@JsonKey(name: 'client_id') String get clientId;@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'program_id') String? get programId;@JsonKey(name: 'day_id') String? get dayId; String get name;@JsonKey(name: 'started_at') DateTime get startedAt;@JsonKey(name: 'finished_at') DateTime get finishedAt;@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day;@JsonKey(name: 'duration_s') int get durationS;@JsonKey(name: 'total_volume', fromJson: _num) double? get totalVolume; String get status; String? get notes;@JsonKey(name: 'set_logs') List<SetLog> get sets;@JsonKey(name: 'workout_comments') List<WorkoutComment> get comments;
/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutLogCopyWith<WorkoutLog> get copyWith => _$WorkoutLogCopyWithImpl<WorkoutLog>(this as WorkoutLog, _$identity);

  /// Serializes this WorkoutLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.clientId, _this.clientId) || other.clientId == _this.clientId)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.dayId, _this.dayId) || other.dayId == _this.dayId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.totalVolume, _this.totalVolume) || other.totalVolume == _this.totalVolume)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.sets, _this.sets)&&const DeepCollectionEquality().equals(other.comments, _this.comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutLog;
  return Object.hash(runtimeType,_this.id,_this.clientId,_this.memberId,_this.programId,_this.dayId,_this.name,_this.startedAt,_this.finishedAt,_this.day,_this.durationS,_this.totalVolume,_this.status,_this.notes,const DeepCollectionEquality().hash(_this.sets),const DeepCollectionEquality().hash(_this.comments));
}

@override
String toString() {
  final _this = this as WorkoutLog;
  return 'WorkoutLog(id: ${_this.id}, clientId: ${_this.clientId}, memberId: ${_this.memberId}, programId: ${_this.programId}, dayId: ${_this.dayId}, name: ${_this.name}, startedAt: ${_this.startedAt}, finishedAt: ${_this.finishedAt}, day: ${_this.day}, durationS: ${_this.durationS}, totalVolume: ${_this.totalVolume}, status: ${_this.status}, notes: ${_this.notes}, sets: ${_this.sets}, comments: ${_this.comments})';
}


}

/// @nodoc
abstract mixin class $WorkoutLogCopyWith<$Res>  {
  factory $WorkoutLogCopyWith(WorkoutLog value, $Res Function(WorkoutLog) _then) = _$WorkoutLogCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'client_id') String clientId,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'program_id') String? programId,@JsonKey(name: 'day_id') String? dayId, String name,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'finished_at') DateTime finishedAt,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'duration_s') int durationS,@JsonKey(name: 'total_volume', fromJson: _num) double? totalVolume, String status, String? notes,@JsonKey(name: 'set_logs') List<SetLog> sets,@JsonKey(name: 'workout_comments') List<WorkoutComment> comments
});




}
/// @nodoc
class _$WorkoutLogCopyWithImpl<$Res>
    implements $WorkoutLogCopyWith<$Res> {
  _$WorkoutLogCopyWithImpl(this._self, this._then);

  final WorkoutLog _self;
  final $Res Function(WorkoutLog) _then;

/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? memberId = null,Object? programId = freezed,Object? dayId = freezed,Object? name = null,Object? startedAt = null,Object? finishedAt = null,Object? day = freezed,Object? durationS = null,Object? totalVolume = freezed,Object? status = null,Object? notes = freezed,Object? sets = null,Object? comments = null,}) {
  return _then(WorkoutLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,dayId: freezed == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,totalVolume: freezed == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<SetLog>,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<WorkoutComment>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutLog].
extension WorkoutLogPatterns on WorkoutLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutLog value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutLog value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'client_id')  String clientId, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'day_id')  String? dayId,  String name, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'finished_at')  DateTime finishedAt, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'duration_s')  int durationS, @JsonKey(name: 'total_volume', fromJson: _num)  double? totalVolume,  String status,  String? notes, @JsonKey(name: 'set_logs')  List<SetLog> sets, @JsonKey(name: 'workout_comments')  List<WorkoutComment> comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
return $default(_that.id,_that.clientId,_that.memberId,_that.programId,_that.dayId,_that.name,_that.startedAt,_that.finishedAt,_that.day,_that.durationS,_that.totalVolume,_that.status,_that.notes,_that.sets,_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'client_id')  String clientId, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'day_id')  String? dayId,  String name, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'finished_at')  DateTime finishedAt, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'duration_s')  int durationS, @JsonKey(name: 'total_volume', fromJson: _num)  double? totalVolume,  String status,  String? notes, @JsonKey(name: 'set_logs')  List<SetLog> sets, @JsonKey(name: 'workout_comments')  List<WorkoutComment> comments)  $default,) {final _that = this;
switch (_that) {
case _WorkoutLog():
return $default(_that.id,_that.clientId,_that.memberId,_that.programId,_that.dayId,_that.name,_that.startedAt,_that.finishedAt,_that.day,_that.durationS,_that.totalVolume,_that.status,_that.notes,_that.sets,_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'client_id')  String clientId, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'day_id')  String? dayId,  String name, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'finished_at')  DateTime finishedAt, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'duration_s')  int durationS, @JsonKey(name: 'total_volume', fromJson: _num)  double? totalVolume,  String status,  String? notes, @JsonKey(name: 'set_logs')  List<SetLog> sets, @JsonKey(name: 'workout_comments')  List<WorkoutComment> comments)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutLog() when $default != null:
return $default(_that.id,_that.clientId,_that.memberId,_that.programId,_that.dayId,_that.name,_that.startedAt,_that.finishedAt,_that.day,_that.durationS,_that.totalVolume,_that.status,_that.notes,_that.sets,_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutLog extends WorkoutLog {
  const _WorkoutLog({required this.id, @JsonKey(name: 'client_id') required this.clientId, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'program_id') this.programId, @JsonKey(name: 'day_id') this.dayId, required this.name, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'finished_at') required this.finishedAt, @JsonKey(fromJson: _date, toJson: _dateOut) required this.day, @JsonKey(name: 'duration_s') this.durationS = 0, @JsonKey(name: 'total_volume', fromJson: _num) this.totalVolume = 0, this.status = 'completed', this.notes, @JsonKey(name: 'set_logs')  List<SetLog> sets = const <SetLog>[], @JsonKey(name: 'workout_comments')  List<WorkoutComment> comments = const <WorkoutComment>[]}): _sets = sets,_comments = comments,super._();
  factory _WorkoutLog.fromJson(Map<String, dynamic> json) => _$WorkoutLogFromJson(json);

@override final  String id;
@override@JsonKey(name: 'client_id') final  String clientId;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'program_id') final  String? programId;
@override@JsonKey(name: 'day_id') final  String? dayId;
@override final  String name;
@override@JsonKey(name: 'started_at') final  DateTime startedAt;
@override@JsonKey(name: 'finished_at') final  DateTime finishedAt;
@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override@JsonKey(name: 'duration_s') final  int durationS;
@override@JsonKey(name: 'total_volume', fromJson: _num) final  double? totalVolume;
@override@JsonKey() final  String status;
@override final  String? notes;
 final  List<SetLog> _sets;
@override@JsonKey(name: 'set_logs') List<SetLog> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

 final  List<WorkoutComment> _comments;
@override@JsonKey(name: 'workout_comments') List<WorkoutComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}


/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutLogCopyWith<_WorkoutLog> get copyWith => __$WorkoutLogCopyWithImpl<_WorkoutLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutLog&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.day, day) || other.day == day)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.sets, _sets)&&const DeepCollectionEquality().equals(other.comments, _comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,clientId,memberId,programId,dayId,name,startedAt,finishedAt,day,durationS,totalVolume,status,notes,const DeepCollectionEquality().hash(_sets),const DeepCollectionEquality().hash(_comments));
}

@override
String toString() {
    return 'WorkoutLog(id: $id, clientId: $clientId, memberId: $memberId, programId: $programId, dayId: $dayId, name: $name, startedAt: $startedAt, finishedAt: $finishedAt, day: $day, durationS: $durationS, totalVolume: $totalVolume, status: $status, notes: $notes, sets: $sets, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$WorkoutLogCopyWith<$Res> implements $WorkoutLogCopyWith<$Res> {
  factory _$WorkoutLogCopyWith(_WorkoutLog value, $Res Function(_WorkoutLog) _then) = __$WorkoutLogCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'client_id') String clientId,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'program_id') String? programId,@JsonKey(name: 'day_id') String? dayId, String name,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'finished_at') DateTime finishedAt,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'duration_s') int durationS,@JsonKey(name: 'total_volume', fromJson: _num) double? totalVolume, String status, String? notes,@JsonKey(name: 'set_logs') List<SetLog> sets,@JsonKey(name: 'workout_comments') List<WorkoutComment> comments
});




}
/// @nodoc
class __$WorkoutLogCopyWithImpl<$Res>
    implements _$WorkoutLogCopyWith<$Res> {
  __$WorkoutLogCopyWithImpl(this._self, this._then);

  final _WorkoutLog _self;
  final $Res Function(_WorkoutLog) _then;

/// Create a copy of WorkoutLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? memberId = null,Object? programId = freezed,Object? dayId = freezed,Object? name = null,Object? startedAt = null,Object? finishedAt = null,Object? day = freezed,Object? durationS = null,Object? totalVolume = freezed,Object? status = null,Object? notes = freezed,Object? sets = null,Object? comments = null,}) {
  return _then(_WorkoutLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,dayId: freezed == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,totalVolume: freezed == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<SetLog>,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<WorkoutComment>,
  ));
}


}


/// @nodoc
mixin _$CoachRow {

@JsonKey(name: 'member_id') String get memberId; String get name;@JsonKey(name: 'member_code') String get memberCode;@JsonKey(name: 'photo_url') String? get photoPath;@JsonKey(name: 'trainer_id') String? get trainerId; String? get status;@JsonKey(name: 'program_id') String? get programId;@JsonKey(name: 'program_name') String? get programName;@JsonKey(name: 'program_status') ProgramStatus? get programStatus;@JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut) DateTime? get programStart;@JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut) DateTime? get programEnd;@JsonKey(name: 'last_workout_at') DateTime? get lastWorkoutAt;@JsonKey(name: 'workouts_7d') int get workouts7d;@JsonKey(fromJson: _num) double? get adherence;
/// Create a copy of CoachRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachRowCopyWith<CoachRow> get copyWith => _$CoachRowCopyWithImpl<CoachRow>(this as CoachRow, _$identity);

  /// Serializes this CoachRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CoachRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachRow&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.memberCode, _this.memberCode) || other.memberCode == _this.memberCode)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.trainerId, _this.trainerId) || other.trainerId == _this.trainerId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.programStatus, _this.programStatus) || other.programStatus == _this.programStatus)&&(identical(other.programStart, _this.programStart) || other.programStart == _this.programStart)&&(identical(other.programEnd, _this.programEnd) || other.programEnd == _this.programEnd)&&(identical(other.lastWorkoutAt, _this.lastWorkoutAt) || other.lastWorkoutAt == _this.lastWorkoutAt)&&(identical(other.workouts7d, _this.workouts7d) || other.workouts7d == _this.workouts7d)&&(identical(other.adherence, _this.adherence) || other.adherence == _this.adherence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CoachRow;
  return Object.hash(runtimeType,_this.memberId,_this.name,_this.memberCode,_this.photoPath,_this.trainerId,_this.status,_this.programId,_this.programName,_this.programStatus,_this.programStart,_this.programEnd,_this.lastWorkoutAt,_this.workouts7d,_this.adherence);
}

@override
String toString() {
  final _this = this as CoachRow;
  return 'CoachRow(memberId: ${_this.memberId}, name: ${_this.name}, memberCode: ${_this.memberCode}, photoPath: ${_this.photoPath}, trainerId: ${_this.trainerId}, status: ${_this.status}, programId: ${_this.programId}, programName: ${_this.programName}, programStatus: ${_this.programStatus}, programStart: ${_this.programStart}, programEnd: ${_this.programEnd}, lastWorkoutAt: ${_this.lastWorkoutAt}, workouts7d: ${_this.workouts7d}, adherence: ${_this.adherence})';
}


}

/// @nodoc
abstract mixin class $CoachRowCopyWith<$Res>  {
  factory $CoachRowCopyWith(CoachRow value, $Res Function(CoachRow) _then) = _$CoachRowCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(name: 'trainer_id') String? trainerId, String? status,@JsonKey(name: 'program_id') String? programId,@JsonKey(name: 'program_name') String? programName,@JsonKey(name: 'program_status') ProgramStatus? programStatus,@JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut) DateTime? programStart,@JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut) DateTime? programEnd,@JsonKey(name: 'last_workout_at') DateTime? lastWorkoutAt,@JsonKey(name: 'workouts_7d') int workouts7d,@JsonKey(fromJson: _num) double? adherence
});




}
/// @nodoc
class _$CoachRowCopyWithImpl<$Res>
    implements $CoachRowCopyWith<$Res> {
  _$CoachRowCopyWithImpl(this._self, this._then);

  final CoachRow _self;
  final $Res Function(CoachRow) _then;

/// Create a copy of CoachRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? name = null,Object? memberCode = null,Object? photoPath = freezed,Object? trainerId = freezed,Object? status = freezed,Object? programId = freezed,Object? programName = freezed,Object? programStatus = freezed,Object? programStart = freezed,Object? programEnd = freezed,Object? lastWorkoutAt = freezed,Object? workouts7d = null,Object? adherence = freezed,}) {
  return _then(CoachRow(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,programName: freezed == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String?,programStatus: freezed == programStatus ? _self.programStatus : programStatus // ignore: cast_nullable_to_non_nullable
as ProgramStatus?,programStart: freezed == programStart ? _self.programStart : programStart // ignore: cast_nullable_to_non_nullable
as DateTime?,programEnd: freezed == programEnd ? _self.programEnd : programEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,lastWorkoutAt: freezed == lastWorkoutAt ? _self.lastWorkoutAt : lastWorkoutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workouts7d: null == workouts7d ? _self.workouts7d : workouts7d // ignore: cast_nullable_to_non_nullable
as int,adherence: freezed == adherence ? _self.adherence : adherence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachRow].
extension CoachRowPatterns on CoachRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachRow value)  $default,){
final _that = this;
switch (_that) {
case _CoachRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachRow value)?  $default,){
final _that = this;
switch (_that) {
case _CoachRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(name: 'trainer_id')  String? trainerId,  String? status, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'program_name')  String? programName, @JsonKey(name: 'program_status')  ProgramStatus? programStatus, @JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut)  DateTime? programStart, @JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut)  DateTime? programEnd, @JsonKey(name: 'last_workout_at')  DateTime? lastWorkoutAt, @JsonKey(name: 'workouts_7d')  int workouts7d, @JsonKey(fromJson: _num)  double? adherence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachRow() when $default != null:
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.trainerId,_that.status,_that.programId,_that.programName,_that.programStatus,_that.programStart,_that.programEnd,_that.lastWorkoutAt,_that.workouts7d,_that.adherence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(name: 'trainer_id')  String? trainerId,  String? status, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'program_name')  String? programName, @JsonKey(name: 'program_status')  ProgramStatus? programStatus, @JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut)  DateTime? programStart, @JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut)  DateTime? programEnd, @JsonKey(name: 'last_workout_at')  DateTime? lastWorkoutAt, @JsonKey(name: 'workouts_7d')  int workouts7d, @JsonKey(fromJson: _num)  double? adherence)  $default,) {final _that = this;
switch (_that) {
case _CoachRow():
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.trainerId,_that.status,_that.programId,_that.programName,_that.programStatus,_that.programStart,_that.programEnd,_that.lastWorkoutAt,_that.workouts7d,_that.adherence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(name: 'trainer_id')  String? trainerId,  String? status, @JsonKey(name: 'program_id')  String? programId, @JsonKey(name: 'program_name')  String? programName, @JsonKey(name: 'program_status')  ProgramStatus? programStatus, @JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut)  DateTime? programStart, @JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut)  DateTime? programEnd, @JsonKey(name: 'last_workout_at')  DateTime? lastWorkoutAt, @JsonKey(name: 'workouts_7d')  int workouts7d, @JsonKey(fromJson: _num)  double? adherence)?  $default,) {final _that = this;
switch (_that) {
case _CoachRow() when $default != null:
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.trainerId,_that.status,_that.programId,_that.programName,_that.programStatus,_that.programStart,_that.programEnd,_that.lastWorkoutAt,_that.workouts7d,_that.adherence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoachRow implements CoachRow {
  const _CoachRow({@JsonKey(name: 'member_id') required this.memberId, required this.name, @JsonKey(name: 'member_code') required this.memberCode, @JsonKey(name: 'photo_url') this.photoPath, @JsonKey(name: 'trainer_id') this.trainerId, this.status, @JsonKey(name: 'program_id') this.programId, @JsonKey(name: 'program_name') this.programName, @JsonKey(name: 'program_status') this.programStatus, @JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut) this.programStart, @JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut) this.programEnd, @JsonKey(name: 'last_workout_at') this.lastWorkoutAt, @JsonKey(name: 'workouts_7d') this.workouts7d = 0, @JsonKey(fromJson: _num) this.adherence});
  factory _CoachRow.fromJson(Map<String, dynamic> json) => _$CoachRowFromJson(json);

@override@JsonKey(name: 'member_id') final  String memberId;
@override final  String name;
@override@JsonKey(name: 'member_code') final  String memberCode;
@override@JsonKey(name: 'photo_url') final  String? photoPath;
@override@JsonKey(name: 'trainer_id') final  String? trainerId;
@override final  String? status;
@override@JsonKey(name: 'program_id') final  String? programId;
@override@JsonKey(name: 'program_name') final  String? programName;
@override@JsonKey(name: 'program_status') final  ProgramStatus? programStatus;
@override@JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut) final  DateTime? programStart;
@override@JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut) final  DateTime? programEnd;
@override@JsonKey(name: 'last_workout_at') final  DateTime? lastWorkoutAt;
@override@JsonKey(name: 'workouts_7d') final  int workouts7d;
@override@JsonKey(fromJson: _num) final  double? adherence;

/// Create a copy of CoachRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachRowCopyWith<_CoachRow> get copyWith => __$CoachRowCopyWithImpl<_CoachRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachRow&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.name, name) || other.name == name)&&(identical(other.memberCode, memberCode) || other.memberCode == memberCode)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.programStatus, programStatus) || other.programStatus == programStatus)&&(identical(other.programStart, programStart) || other.programStart == programStart)&&(identical(other.programEnd, programEnd) || other.programEnd == programEnd)&&(identical(other.lastWorkoutAt, lastWorkoutAt) || other.lastWorkoutAt == lastWorkoutAt)&&(identical(other.workouts7d, workouts7d) || other.workouts7d == workouts7d)&&(identical(other.adherence, adherence) || other.adherence == adherence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memberId,name,memberCode,photoPath,trainerId,status,programId,programName,programStatus,programStart,programEnd,lastWorkoutAt,workouts7d,adherence);
}

@override
String toString() {
    return 'CoachRow(memberId: $memberId, name: $name, memberCode: $memberCode, photoPath: $photoPath, trainerId: $trainerId, status: $status, programId: $programId, programName: $programName, programStatus: $programStatus, programStart: $programStart, programEnd: $programEnd, lastWorkoutAt: $lastWorkoutAt, workouts7d: $workouts7d, adherence: $adherence)';
}


}

/// @nodoc
abstract mixin class _$CoachRowCopyWith<$Res> implements $CoachRowCopyWith<$Res> {
  factory _$CoachRowCopyWith(_CoachRow value, $Res Function(_CoachRow) _then) = __$CoachRowCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(name: 'trainer_id') String? trainerId, String? status,@JsonKey(name: 'program_id') String? programId,@JsonKey(name: 'program_name') String? programName,@JsonKey(name: 'program_status') ProgramStatus? programStatus,@JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut) DateTime? programStart,@JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut) DateTime? programEnd,@JsonKey(name: 'last_workout_at') DateTime? lastWorkoutAt,@JsonKey(name: 'workouts_7d') int workouts7d,@JsonKey(fromJson: _num) double? adherence
});




}
/// @nodoc
class __$CoachRowCopyWithImpl<$Res>
    implements _$CoachRowCopyWith<$Res> {
  __$CoachRowCopyWithImpl(this._self, this._then);

  final _CoachRow _self;
  final $Res Function(_CoachRow) _then;

/// Create a copy of CoachRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? name = null,Object? memberCode = null,Object? photoPath = freezed,Object? trainerId = freezed,Object? status = freezed,Object? programId = freezed,Object? programName = freezed,Object? programStatus = freezed,Object? programStart = freezed,Object? programEnd = freezed,Object? lastWorkoutAt = freezed,Object? workouts7d = null,Object? adherence = freezed,}) {
  return _then(_CoachRow(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,programName: freezed == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String?,programStatus: freezed == programStatus ? _self.programStatus : programStatus // ignore: cast_nullable_to_non_nullable
as ProgramStatus?,programStart: freezed == programStart ? _self.programStart : programStart // ignore: cast_nullable_to_non_nullable
as DateTime?,programEnd: freezed == programEnd ? _self.programEnd : programEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,lastWorkoutAt: freezed == lastWorkoutAt ? _self.lastWorkoutAt : lastWorkoutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workouts7d: null == workouts7d ? _self.workouts7d : workouts7d // ignore: cast_nullable_to_non_nullable
as int,adherence: freezed == adherence ? _self.adherence : adherence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$PrHit {

@JsonKey(name: 'exercise_id') String get exerciseId;@JsonKey(name: 'set_no') int get setNo; List<String> get kinds;@JsonKey(fromJson: _num) double? get weight; int? get reps;@JsonKey(fromJson: _num) double? get e1rm;
/// Create a copy of PrHit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrHitCopyWith<PrHit> get copyWith => _$PrHitCopyWithImpl<PrHit>(this as PrHit, _$identity);

  /// Serializes this PrHit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PrHit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrHit&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.setNo, _this.setNo) || other.setNo == _this.setNo)&&const DeepCollectionEquality().equals(other.kinds, _this.kinds)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.reps, _this.reps) || other.reps == _this.reps)&&(identical(other.e1rm, _this.e1rm) || other.e1rm == _this.e1rm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PrHit;
  return Object.hash(runtimeType,_this.exerciseId,_this.setNo,const DeepCollectionEquality().hash(_this.kinds),_this.weight,_this.reps,_this.e1rm);
}

@override
String toString() {
  final _this = this as PrHit;
  return 'PrHit(exerciseId: ${_this.exerciseId}, setNo: ${_this.setNo}, kinds: ${_this.kinds}, weight: ${_this.weight}, reps: ${_this.reps}, e1rm: ${_this.e1rm})';
}


}

/// @nodoc
abstract mixin class $PrHitCopyWith<$Res>  {
  factory $PrHitCopyWith(PrHit value, $Res Function(PrHit) _then) = _$PrHitCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'exercise_id') String exerciseId,@JsonKey(name: 'set_no') int setNo, List<String> kinds,@JsonKey(fromJson: _num) double? weight, int? reps,@JsonKey(fromJson: _num) double? e1rm
});




}
/// @nodoc
class _$PrHitCopyWithImpl<$Res>
    implements $PrHitCopyWith<$Res> {
  _$PrHitCopyWithImpl(this._self, this._then);

  final PrHit _self;
  final $Res Function(PrHit) _then;

/// Create a copy of PrHit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? setNo = null,Object? kinds = null,Object? weight = freezed,Object? reps = freezed,Object? e1rm = freezed,}) {
  return _then(PrHit(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,setNo: null == setNo ? _self.setNo : setNo // ignore: cast_nullable_to_non_nullable
as int,kinds: null == kinds ? _self.kinds : kinds // ignore: cast_nullable_to_non_nullable
as List<String>,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,e1rm: freezed == e1rm ? _self.e1rm : e1rm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrHit].
extension PrHitPatterns on PrHit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrHit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrHit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrHit value)  $default,){
final _that = this;
switch (_that) {
case _PrHit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrHit value)?  $default,){
final _that = this;
switch (_that) {
case _PrHit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'exercise_id')  String exerciseId, @JsonKey(name: 'set_no')  int setNo,  List<String> kinds, @JsonKey(fromJson: _num)  double? weight,  int? reps, @JsonKey(fromJson: _num)  double? e1rm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrHit() when $default != null:
return $default(_that.exerciseId,_that.setNo,_that.kinds,_that.weight,_that.reps,_that.e1rm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'exercise_id')  String exerciseId, @JsonKey(name: 'set_no')  int setNo,  List<String> kinds, @JsonKey(fromJson: _num)  double? weight,  int? reps, @JsonKey(fromJson: _num)  double? e1rm)  $default,) {final _that = this;
switch (_that) {
case _PrHit():
return $default(_that.exerciseId,_that.setNo,_that.kinds,_that.weight,_that.reps,_that.e1rm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'exercise_id')  String exerciseId, @JsonKey(name: 'set_no')  int setNo,  List<String> kinds, @JsonKey(fromJson: _num)  double? weight,  int? reps, @JsonKey(fromJson: _num)  double? e1rm)?  $default,) {final _that = this;
switch (_that) {
case _PrHit() when $default != null:
return $default(_that.exerciseId,_that.setNo,_that.kinds,_that.weight,_that.reps,_that.e1rm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrHit implements PrHit {
  const _PrHit({@JsonKey(name: 'exercise_id') required this.exerciseId, @JsonKey(name: 'set_no') required this.setNo,  List<String> kinds = const <String>[], @JsonKey(fromJson: _num) this.weight, this.reps, @JsonKey(fromJson: _num) this.e1rm}): _kinds = kinds;
  factory _PrHit.fromJson(Map<String, dynamic> json) => _$PrHitFromJson(json);

@override@JsonKey(name: 'exercise_id') final  String exerciseId;
@override@JsonKey(name: 'set_no') final  int setNo;
 final  List<String> _kinds;
@override@JsonKey() List<String> get kinds {
  if (_kinds is EqualUnmodifiableListView) return _kinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kinds);
}

@override@JsonKey(fromJson: _num) final  double? weight;
@override final  int? reps;
@override@JsonKey(fromJson: _num) final  double? e1rm;

/// Create a copy of PrHit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrHitCopyWith<_PrHit> get copyWith => __$PrHitCopyWithImpl<_PrHit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrHitToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrHit&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.setNo, setNo) || other.setNo == setNo)&&const DeepCollectionEquality().equals(other.kinds, _kinds)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.e1rm, e1rm) || other.e1rm == e1rm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,exerciseId,setNo,const DeepCollectionEquality().hash(_kinds),weight,reps,e1rm);
}

@override
String toString() {
    return 'PrHit(exerciseId: $exerciseId, setNo: $setNo, kinds: $kinds, weight: $weight, reps: $reps, e1rm: $e1rm)';
}


}

/// @nodoc
abstract mixin class _$PrHitCopyWith<$Res> implements $PrHitCopyWith<$Res> {
  factory _$PrHitCopyWith(_PrHit value, $Res Function(_PrHit) _then) = __$PrHitCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'exercise_id') String exerciseId,@JsonKey(name: 'set_no') int setNo, List<String> kinds,@JsonKey(fromJson: _num) double? weight, int? reps,@JsonKey(fromJson: _num) double? e1rm
});




}
/// @nodoc
class __$PrHitCopyWithImpl<$Res>
    implements _$PrHitCopyWith<$Res> {
  __$PrHitCopyWithImpl(this._self, this._then);

  final _PrHit _self;
  final $Res Function(_PrHit) _then;

/// Create a copy of PrHit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? setNo = null,Object? kinds = null,Object? weight = freezed,Object? reps = freezed,Object? e1rm = freezed,}) {
  return _then(_PrHit(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,setNo: null == setNo ? _self.setNo : setNo // ignore: cast_nullable_to_non_nullable
as int,kinds: null == kinds ? _self._kinds : kinds // ignore: cast_nullable_to_non_nullable
as List<String>,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,e1rm: freezed == e1rm ? _self.e1rm : e1rm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$SaveLogResult {

@JsonKey(name: 'log_id') String get logId;@JsonKey(name: 'total_volume', fromJson: _num) double? get totalVolume; List<PrHit> get prs;
/// Create a copy of SaveLogResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveLogResultCopyWith<SaveLogResult> get copyWith => _$SaveLogResultCopyWithImpl<SaveLogResult>(this as SaveLogResult, _$identity);

  /// Serializes this SaveLogResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaveLogResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveLogResult&&(identical(other.logId, _this.logId) || other.logId == _this.logId)&&(identical(other.totalVolume, _this.totalVolume) || other.totalVolume == _this.totalVolume)&&const DeepCollectionEquality().equals(other.prs, _this.prs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaveLogResult;
  return Object.hash(runtimeType,_this.logId,_this.totalVolume,const DeepCollectionEquality().hash(_this.prs));
}

@override
String toString() {
  final _this = this as SaveLogResult;
  return 'SaveLogResult(logId: ${_this.logId}, totalVolume: ${_this.totalVolume}, prs: ${_this.prs})';
}


}

/// @nodoc
abstract mixin class $SaveLogResultCopyWith<$Res>  {
  factory $SaveLogResultCopyWith(SaveLogResult value, $Res Function(SaveLogResult) _then) = _$SaveLogResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'log_id') String logId,@JsonKey(name: 'total_volume', fromJson: _num) double? totalVolume, List<PrHit> prs
});




}
/// @nodoc
class _$SaveLogResultCopyWithImpl<$Res>
    implements $SaveLogResultCopyWith<$Res> {
  _$SaveLogResultCopyWithImpl(this._self, this._then);

  final SaveLogResult _self;
  final $Res Function(SaveLogResult) _then;

/// Create a copy of SaveLogResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logId = null,Object? totalVolume = freezed,Object? prs = null,}) {
  return _then(SaveLogResult(
logId: null == logId ? _self.logId : logId // ignore: cast_nullable_to_non_nullable
as String,totalVolume: freezed == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double?,prs: null == prs ? _self.prs : prs // ignore: cast_nullable_to_non_nullable
as List<PrHit>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveLogResult].
extension SaveLogResultPatterns on SaveLogResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveLogResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveLogResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveLogResult value)  $default,){
final _that = this;
switch (_that) {
case _SaveLogResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveLogResult value)?  $default,){
final _that = this;
switch (_that) {
case _SaveLogResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'log_id')  String logId, @JsonKey(name: 'total_volume', fromJson: _num)  double? totalVolume,  List<PrHit> prs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveLogResult() when $default != null:
return $default(_that.logId,_that.totalVolume,_that.prs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'log_id')  String logId, @JsonKey(name: 'total_volume', fromJson: _num)  double? totalVolume,  List<PrHit> prs)  $default,) {final _that = this;
switch (_that) {
case _SaveLogResult():
return $default(_that.logId,_that.totalVolume,_that.prs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'log_id')  String logId, @JsonKey(name: 'total_volume', fromJson: _num)  double? totalVolume,  List<PrHit> prs)?  $default,) {final _that = this;
switch (_that) {
case _SaveLogResult() when $default != null:
return $default(_that.logId,_that.totalVolume,_that.prs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveLogResult implements SaveLogResult {
  const _SaveLogResult({@JsonKey(name: 'log_id') required this.logId, @JsonKey(name: 'total_volume', fromJson: _num) this.totalVolume = 0,  List<PrHit> prs = const <PrHit>[]}): _prs = prs;
  factory _SaveLogResult.fromJson(Map<String, dynamic> json) => _$SaveLogResultFromJson(json);

@override@JsonKey(name: 'log_id') final  String logId;
@override@JsonKey(name: 'total_volume', fromJson: _num) final  double? totalVolume;
 final  List<PrHit> _prs;
@override@JsonKey() List<PrHit> get prs {
  if (_prs is EqualUnmodifiableListView) return _prs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prs);
}


/// Create a copy of SaveLogResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveLogResultCopyWith<_SaveLogResult> get copyWith => __$SaveLogResultCopyWithImpl<_SaveLogResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaveLogResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveLogResult&&(identical(other.logId, logId) || other.logId == logId)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&const DeepCollectionEquality().equals(other.prs, _prs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,logId,totalVolume,const DeepCollectionEquality().hash(_prs));
}

@override
String toString() {
    return 'SaveLogResult(logId: $logId, totalVolume: $totalVolume, prs: $prs)';
}


}

/// @nodoc
abstract mixin class _$SaveLogResultCopyWith<$Res> implements $SaveLogResultCopyWith<$Res> {
  factory _$SaveLogResultCopyWith(_SaveLogResult value, $Res Function(_SaveLogResult) _then) = __$SaveLogResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'log_id') String logId,@JsonKey(name: 'total_volume', fromJson: _num) double? totalVolume, List<PrHit> prs
});




}
/// @nodoc
class __$SaveLogResultCopyWithImpl<$Res>
    implements _$SaveLogResultCopyWith<$Res> {
  __$SaveLogResultCopyWithImpl(this._self, this._then);

  final _SaveLogResult _self;
  final $Res Function(_SaveLogResult) _then;

/// Create a copy of SaveLogResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logId = null,Object? totalVolume = freezed,Object? prs = null,}) {
  return _then(_SaveLogResult(
logId: null == logId ? _self.logId : logId // ignore: cast_nullable_to_non_nullable
as String,totalVolume: freezed == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double?,prs: null == prs ? _self._prs : prs // ignore: cast_nullable_to_non_nullable
as List<PrHit>,
  ));
}


}

// dart format on
