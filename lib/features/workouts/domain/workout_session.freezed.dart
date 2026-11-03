// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionSet {

 int get setNo; double? get targetWeight; int? get targetReps; int? get targetDuration; double? get weight; int? get reps; int? get durationS; int? get distanceM; bool get done; DateTime? get doneAt;
/// Create a copy of SessionSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionSetCopyWith<SessionSet> get copyWith => _$SessionSetCopyWithImpl<SessionSet>(this as SessionSet, _$identity);

  /// Serializes this SessionSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SessionSet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionSet&&(identical(other.setNo, _this.setNo) || other.setNo == _this.setNo)&&(identical(other.targetWeight, _this.targetWeight) || other.targetWeight == _this.targetWeight)&&(identical(other.targetReps, _this.targetReps) || other.targetReps == _this.targetReps)&&(identical(other.targetDuration, _this.targetDuration) || other.targetDuration == _this.targetDuration)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.reps, _this.reps) || other.reps == _this.reps)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.doneAt, _this.doneAt) || other.doneAt == _this.doneAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionSet;
  return Object.hash(runtimeType,_this.setNo,_this.targetWeight,_this.targetReps,_this.targetDuration,_this.weight,_this.reps,_this.durationS,_this.distanceM,_this.done,_this.doneAt);
}

@override
String toString() {
  final _this = this as SessionSet;
  return 'SessionSet(setNo: ${_this.setNo}, targetWeight: ${_this.targetWeight}, targetReps: ${_this.targetReps}, targetDuration: ${_this.targetDuration}, weight: ${_this.weight}, reps: ${_this.reps}, durationS: ${_this.durationS}, distanceM: ${_this.distanceM}, done: ${_this.done}, doneAt: ${_this.doneAt})';
}


}

/// @nodoc
abstract mixin class $SessionSetCopyWith<$Res>  {
  factory $SessionSetCopyWith(SessionSet value, $Res Function(SessionSet) _then) = _$SessionSetCopyWithImpl;
@useResult
$Res call({
 int setNo, double? targetWeight, int? targetReps, int? targetDuration, double? weight, int? reps, int? durationS, int? distanceM, bool done, DateTime? doneAt
});




}
/// @nodoc
class _$SessionSetCopyWithImpl<$Res>
    implements $SessionSetCopyWith<$Res> {
  _$SessionSetCopyWithImpl(this._self, this._then);

  final SessionSet _self;
  final $Res Function(SessionSet) _then;

/// Create a copy of SessionSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setNo = null,Object? targetWeight = freezed,Object? targetReps = freezed,Object? targetDuration = freezed,Object? weight = freezed,Object? reps = freezed,Object? durationS = freezed,Object? distanceM = freezed,Object? done = null,Object? doneAt = freezed,}) {
  return _then(SessionSet(
setNo: null == setNo ? _self.setNo : setNo // ignore: cast_nullable_to_non_nullable
as int,targetWeight: freezed == targetWeight ? _self.targetWeight : targetWeight // ignore: cast_nullable_to_non_nullable
as double?,targetReps: freezed == targetReps ? _self.targetReps : targetReps // ignore: cast_nullable_to_non_nullable
as int?,targetDuration: freezed == targetDuration ? _self.targetDuration : targetDuration // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionSet].
extension SessionSetPatterns on SessionSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionSet value)  $default,){
final _that = this;
switch (_that) {
case _SessionSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionSet value)?  $default,){
final _that = this;
switch (_that) {
case _SessionSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int setNo,  double? targetWeight,  int? targetReps,  int? targetDuration,  double? weight,  int? reps,  int? durationS,  int? distanceM,  bool done,  DateTime? doneAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionSet() when $default != null:
return $default(_that.setNo,_that.targetWeight,_that.targetReps,_that.targetDuration,_that.weight,_that.reps,_that.durationS,_that.distanceM,_that.done,_that.doneAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int setNo,  double? targetWeight,  int? targetReps,  int? targetDuration,  double? weight,  int? reps,  int? durationS,  int? distanceM,  bool done,  DateTime? doneAt)  $default,) {final _that = this;
switch (_that) {
case _SessionSet():
return $default(_that.setNo,_that.targetWeight,_that.targetReps,_that.targetDuration,_that.weight,_that.reps,_that.durationS,_that.distanceM,_that.done,_that.doneAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int setNo,  double? targetWeight,  int? targetReps,  int? targetDuration,  double? weight,  int? reps,  int? durationS,  int? distanceM,  bool done,  DateTime? doneAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionSet() when $default != null:
return $default(_that.setNo,_that.targetWeight,_that.targetReps,_that.targetDuration,_that.weight,_that.reps,_that.durationS,_that.distanceM,_that.done,_that.doneAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionSet implements SessionSet {
  const _SessionSet({required this.setNo, this.targetWeight, this.targetReps, this.targetDuration, this.weight, this.reps, this.durationS, this.distanceM, this.done = false, this.doneAt});
  factory _SessionSet.fromJson(Map<String, dynamic> json) => _$SessionSetFromJson(json);

@override final  int setNo;
@override final  double? targetWeight;
@override final  int? targetReps;
@override final  int? targetDuration;
@override final  double? weight;
@override final  int? reps;
@override final  int? durationS;
@override final  int? distanceM;
@override@JsonKey() final  bool done;
@override final  DateTime? doneAt;

/// Create a copy of SessionSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionSetCopyWith<_SessionSet> get copyWith => __$SessionSetCopyWithImpl<_SessionSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionSetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionSet&&(identical(other.setNo, setNo) || other.setNo == setNo)&&(identical(other.targetWeight, targetWeight) || other.targetWeight == targetWeight)&&(identical(other.targetReps, targetReps) || other.targetReps == targetReps)&&(identical(other.targetDuration, targetDuration) || other.targetDuration == targetDuration)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.done, done) || other.done == done)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,setNo,targetWeight,targetReps,targetDuration,weight,reps,durationS,distanceM,done,doneAt);
}

@override
String toString() {
    return 'SessionSet(setNo: $setNo, targetWeight: $targetWeight, targetReps: $targetReps, targetDuration: $targetDuration, weight: $weight, reps: $reps, durationS: $durationS, distanceM: $distanceM, done: $done, doneAt: $doneAt)';
}


}

/// @nodoc
abstract mixin class _$SessionSetCopyWith<$Res> implements $SessionSetCopyWith<$Res> {
  factory _$SessionSetCopyWith(_SessionSet value, $Res Function(_SessionSet) _then) = __$SessionSetCopyWithImpl;
@override @useResult
$Res call({
 int setNo, double? targetWeight, int? targetReps, int? targetDuration, double? weight, int? reps, int? durationS, int? distanceM, bool done, DateTime? doneAt
});




}
/// @nodoc
class __$SessionSetCopyWithImpl<$Res>
    implements _$SessionSetCopyWith<$Res> {
  __$SessionSetCopyWithImpl(this._self, this._then);

  final _SessionSet _self;
  final $Res Function(_SessionSet) _then;

/// Create a copy of SessionSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setNo = null,Object? targetWeight = freezed,Object? targetReps = freezed,Object? targetDuration = freezed,Object? weight = freezed,Object? reps = freezed,Object? durationS = freezed,Object? distanceM = freezed,Object? done = null,Object? doneAt = freezed,}) {
  return _then(_SessionSet(
setNo: null == setNo ? _self.setNo : setNo // ignore: cast_nullable_to_non_nullable
as int,targetWeight: freezed == targetWeight ? _self.targetWeight : targetWeight // ignore: cast_nullable_to_non_nullable
as double?,targetReps: freezed == targetReps ? _self.targetReps : targetReps // ignore: cast_nullable_to_non_nullable
as int?,targetDuration: freezed == targetDuration ? _self.targetDuration : targetDuration // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,durationS: freezed == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SessionExercise {

 String get exerciseId; String get name; TrackingType get trackingType; Block get block; String? get groupKey; int get restS; String? get tempo; String? get notes; List<SessionSet> get sets;
/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionExerciseCopyWith<SessionExercise> get copyWith => _$SessionExerciseCopyWithImpl<SessionExercise>(this as SessionExercise, _$identity);

  /// Serializes this SessionExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SessionExercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionExercise&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.trackingType, _this.trackingType) || other.trackingType == _this.trackingType)&&(identical(other.block, _this.block) || other.block == _this.block)&&(identical(other.groupKey, _this.groupKey) || other.groupKey == _this.groupKey)&&(identical(other.restS, _this.restS) || other.restS == _this.restS)&&(identical(other.tempo, _this.tempo) || other.tempo == _this.tempo)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.sets, _this.sets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionExercise;
  return Object.hash(runtimeType,_this.exerciseId,_this.name,_this.trackingType,_this.block,_this.groupKey,_this.restS,_this.tempo,_this.notes,const DeepCollectionEquality().hash(_this.sets));
}

@override
String toString() {
  final _this = this as SessionExercise;
  return 'SessionExercise(exerciseId: ${_this.exerciseId}, name: ${_this.name}, trackingType: ${_this.trackingType}, block: ${_this.block}, groupKey: ${_this.groupKey}, restS: ${_this.restS}, tempo: ${_this.tempo}, notes: ${_this.notes}, sets: ${_this.sets})';
}


}

/// @nodoc
abstract mixin class $SessionExerciseCopyWith<$Res>  {
  factory $SessionExerciseCopyWith(SessionExercise value, $Res Function(SessionExercise) _then) = _$SessionExerciseCopyWithImpl;
@useResult
$Res call({
 String exerciseId, String name, TrackingType trackingType, Block block, String? groupKey, int restS, String? tempo, String? notes, List<SessionSet> sets
});




}
/// @nodoc
class _$SessionExerciseCopyWithImpl<$Res>
    implements $SessionExerciseCopyWith<$Res> {
  _$SessionExerciseCopyWithImpl(this._self, this._then);

  final SessionExercise _self;
  final $Res Function(SessionExercise) _then;

/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? name = null,Object? trackingType = null,Object? block = null,Object? groupKey = freezed,Object? restS = null,Object? tempo = freezed,Object? notes = freezed,Object? sets = null,}) {
  return _then(SessionExercise(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as TrackingType,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as Block,groupKey: freezed == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String?,restS: null == restS ? _self.restS : restS // ignore: cast_nullable_to_non_nullable
as int,tempo: freezed == tempo ? _self.tempo : tempo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<SessionSet>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionExercise].
extension SessionExercisePatterns on SessionExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionExercise value)  $default,){
final _that = this;
switch (_that) {
case _SessionExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionExercise value)?  $default,){
final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseId,  String name,  TrackingType trackingType,  Block block,  String? groupKey,  int restS,  String? tempo,  String? notes,  List<SessionSet> sets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
return $default(_that.exerciseId,_that.name,_that.trackingType,_that.block,_that.groupKey,_that.restS,_that.tempo,_that.notes,_that.sets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseId,  String name,  TrackingType trackingType,  Block block,  String? groupKey,  int restS,  String? tempo,  String? notes,  List<SessionSet> sets)  $default,) {final _that = this;
switch (_that) {
case _SessionExercise():
return $default(_that.exerciseId,_that.name,_that.trackingType,_that.block,_that.groupKey,_that.restS,_that.tempo,_that.notes,_that.sets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseId,  String name,  TrackingType trackingType,  Block block,  String? groupKey,  int restS,  String? tempo,  String? notes,  List<SessionSet> sets)?  $default,) {final _that = this;
switch (_that) {
case _SessionExercise() when $default != null:
return $default(_that.exerciseId,_that.name,_that.trackingType,_that.block,_that.groupKey,_that.restS,_that.tempo,_that.notes,_that.sets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionExercise extends SessionExercise {
  const _SessionExercise({required this.exerciseId, required this.name, this.trackingType = TrackingType.repsWeight, this.block = Block.main, this.groupKey, this.restS = 60, this.tempo, this.notes,  List<SessionSet> sets = const <SessionSet>[]}): _sets = sets,super._();
  factory _SessionExercise.fromJson(Map<String, dynamic> json) => _$SessionExerciseFromJson(json);

@override final  String exerciseId;
@override final  String name;
@override@JsonKey() final  TrackingType trackingType;
@override@JsonKey() final  Block block;
@override final  String? groupKey;
@override@JsonKey() final  int restS;
@override final  String? tempo;
@override final  String? notes;
 final  List<SessionSet> _sets;
@override@JsonKey() List<SessionSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}


/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionExerciseCopyWith<_SessionExercise> get copyWith => __$SessionExerciseCopyWithImpl<_SessionExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExercise&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.name, name) || other.name == name)&&(identical(other.trackingType, trackingType) || other.trackingType == trackingType)&&(identical(other.block, block) || other.block == block)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.restS, restS) || other.restS == restS)&&(identical(other.tempo, tempo) || other.tempo == tempo)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.sets, _sets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,exerciseId,name,trackingType,block,groupKey,restS,tempo,notes,const DeepCollectionEquality().hash(_sets));
}

@override
String toString() {
    return 'SessionExercise(exerciseId: $exerciseId, name: $name, trackingType: $trackingType, block: $block, groupKey: $groupKey, restS: $restS, tempo: $tempo, notes: $notes, sets: $sets)';
}


}

/// @nodoc
abstract mixin class _$SessionExerciseCopyWith<$Res> implements $SessionExerciseCopyWith<$Res> {
  factory _$SessionExerciseCopyWith(_SessionExercise value, $Res Function(_SessionExercise) _then) = __$SessionExerciseCopyWithImpl;
@override @useResult
$Res call({
 String exerciseId, String name, TrackingType trackingType, Block block, String? groupKey, int restS, String? tempo, String? notes, List<SessionSet> sets
});




}
/// @nodoc
class __$SessionExerciseCopyWithImpl<$Res>
    implements _$SessionExerciseCopyWith<$Res> {
  __$SessionExerciseCopyWithImpl(this._self, this._then);

  final _SessionExercise _self;
  final $Res Function(_SessionExercise) _then;

/// Create a copy of SessionExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? name = null,Object? trackingType = null,Object? block = null,Object? groupKey = freezed,Object? restS = null,Object? tempo = freezed,Object? notes = freezed,Object? sets = null,}) {
  return _then(_SessionExercise(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as TrackingType,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as Block,groupKey: freezed == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String?,restS: null == restS ? _self.restS : restS // ignore: cast_nullable_to_non_nullable
as int,tempo: freezed == tempo ? _self.tempo : tempo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<SessionSet>,
  ));
}


}


/// @nodoc
mixin _$WorkoutSession {

 String get clientId; String get memberId; String? get programId; String? get dayId; String get name; DateTime get startedAt; List<SessionExercise> get exercises; int get current; DateTime? get restEndsAt; int get restTotalS;
/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSessionCopyWith<WorkoutSession> get copyWith => _$WorkoutSessionCopyWithImpl<WorkoutSession>(this as WorkoutSession, _$identity);

  /// Serializes this WorkoutSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSession&&(identical(other.clientId, _this.clientId) || other.clientId == _this.clientId)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.dayId, _this.dayId) || other.dayId == _this.dayId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises)&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.restEndsAt, _this.restEndsAt) || other.restEndsAt == _this.restEndsAt)&&(identical(other.restTotalS, _this.restTotalS) || other.restTotalS == _this.restTotalS));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutSession;
  return Object.hash(runtimeType,_this.clientId,_this.memberId,_this.programId,_this.dayId,_this.name,_this.startedAt,const DeepCollectionEquality().hash(_this.exercises),_this.current,_this.restEndsAt,_this.restTotalS);
}

@override
String toString() {
  final _this = this as WorkoutSession;
  return 'WorkoutSession(clientId: ${_this.clientId}, memberId: ${_this.memberId}, programId: ${_this.programId}, dayId: ${_this.dayId}, name: ${_this.name}, startedAt: ${_this.startedAt}, exercises: ${_this.exercises}, current: ${_this.current}, restEndsAt: ${_this.restEndsAt}, restTotalS: ${_this.restTotalS})';
}


}

/// @nodoc
abstract mixin class $WorkoutSessionCopyWith<$Res>  {
  factory $WorkoutSessionCopyWith(WorkoutSession value, $Res Function(WorkoutSession) _then) = _$WorkoutSessionCopyWithImpl;
@useResult
$Res call({
 String clientId, String memberId, String? programId, String? dayId, String name, DateTime startedAt, List<SessionExercise> exercises, int current, DateTime? restEndsAt, int restTotalS
});




}
/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._self, this._then);

  final WorkoutSession _self;
  final $Res Function(WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientId = null,Object? memberId = null,Object? programId = freezed,Object? dayId = freezed,Object? name = null,Object? startedAt = null,Object? exercises = null,Object? current = null,Object? restEndsAt = freezed,Object? restTotalS = null,}) {
  return _then(WorkoutSession(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,dayId: freezed == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<SessionExercise>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,restEndsAt: freezed == restEndsAt ? _self.restEndsAt : restEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,restTotalS: null == restTotalS ? _self.restTotalS : restTotalS // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSession].
extension WorkoutSessionPatterns on WorkoutSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSession value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSession value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientId,  String memberId,  String? programId,  String? dayId,  String name,  DateTime startedAt,  List<SessionExercise> exercises,  int current,  DateTime? restEndsAt,  int restTotalS)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.clientId,_that.memberId,_that.programId,_that.dayId,_that.name,_that.startedAt,_that.exercises,_that.current,_that.restEndsAt,_that.restTotalS);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientId,  String memberId,  String? programId,  String? dayId,  String name,  DateTime startedAt,  List<SessionExercise> exercises,  int current,  DateTime? restEndsAt,  int restTotalS)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession():
return $default(_that.clientId,_that.memberId,_that.programId,_that.dayId,_that.name,_that.startedAt,_that.exercises,_that.current,_that.restEndsAt,_that.restTotalS);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientId,  String memberId,  String? programId,  String? dayId,  String name,  DateTime startedAt,  List<SessionExercise> exercises,  int current,  DateTime? restEndsAt,  int restTotalS)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.clientId,_that.memberId,_that.programId,_that.dayId,_that.name,_that.startedAt,_that.exercises,_that.current,_that.restEndsAt,_that.restTotalS);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutSession extends WorkoutSession {
  const _WorkoutSession({required this.clientId, required this.memberId, this.programId, this.dayId, required this.name, required this.startedAt,  List<SessionExercise> exercises = const <SessionExercise>[], this.current = 0, this.restEndsAt, this.restTotalS = 0}): _exercises = exercises,super._();
  factory _WorkoutSession.fromJson(Map<String, dynamic> json) => _$WorkoutSessionFromJson(json);

@override final  String clientId;
@override final  String memberId;
@override final  String? programId;
@override final  String? dayId;
@override final  String name;
@override final  DateTime startedAt;
 final  List<SessionExercise> _exercises;
@override@JsonKey() List<SessionExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey() final  int current;
@override final  DateTime? restEndsAt;
@override@JsonKey() final  int restTotalS;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSessionCopyWith<_WorkoutSession> get copyWith => __$WorkoutSessionCopyWithImpl<_WorkoutSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutSession&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&const DeepCollectionEquality().equals(other.exercises, _exercises)&&(identical(other.current, current) || other.current == current)&&(identical(other.restEndsAt, restEndsAt) || other.restEndsAt == restEndsAt)&&(identical(other.restTotalS, restTotalS) || other.restTotalS == restTotalS));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,clientId,memberId,programId,dayId,name,startedAt,const DeepCollectionEquality().hash(_exercises),current,restEndsAt,restTotalS);
}

@override
String toString() {
    return 'WorkoutSession(clientId: $clientId, memberId: $memberId, programId: $programId, dayId: $dayId, name: $name, startedAt: $startedAt, exercises: $exercises, current: $current, restEndsAt: $restEndsAt, restTotalS: $restTotalS)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSessionCopyWith<$Res> implements $WorkoutSessionCopyWith<$Res> {
  factory _$WorkoutSessionCopyWith(_WorkoutSession value, $Res Function(_WorkoutSession) _then) = __$WorkoutSessionCopyWithImpl;
@override @useResult
$Res call({
 String clientId, String memberId, String? programId, String? dayId, String name, DateTime startedAt, List<SessionExercise> exercises, int current, DateTime? restEndsAt, int restTotalS
});




}
/// @nodoc
class __$WorkoutSessionCopyWithImpl<$Res>
    implements _$WorkoutSessionCopyWith<$Res> {
  __$WorkoutSessionCopyWithImpl(this._self, this._then);

  final _WorkoutSession _self;
  final $Res Function(_WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientId = null,Object? memberId = null,Object? programId = freezed,Object? dayId = freezed,Object? name = null,Object? startedAt = null,Object? exercises = null,Object? current = null,Object? restEndsAt = freezed,Object? restTotalS = null,}) {
  return _then(_WorkoutSession(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,dayId: freezed == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<SessionExercise>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,restEndsAt: freezed == restEndsAt ? _self.restEndsAt : restEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,restTotalS: null == restTotalS ? _self.restTotalS : restTotalS // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
