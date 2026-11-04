// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DietItem {

 String? get id;@JsonKey(name: 'food_id') String get foodId;@JsonKey(fromJson: _num) double get qty;@JsonKey(name: 'alt_group') int get altGroup; int get position; Food? get food;
/// Create a copy of DietItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietItemCopyWith<DietItem> get copyWith => _$DietItemCopyWithImpl<DietItem>(this as DietItem, _$identity);

  /// Serializes this DietItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DietItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.foodId, _this.foodId) || other.foodId == _this.foodId)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.altGroup, _this.altGroup) || other.altGroup == _this.altGroup)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.food, _this.food) || other.food == _this.food));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DietItem;
  return Object.hash(runtimeType,_this.id,_this.foodId,_this.qty,_this.altGroup,_this.position,_this.food);
}

@override
String toString() {
  final _this = this as DietItem;
  return 'DietItem(id: ${_this.id}, foodId: ${_this.foodId}, qty: ${_this.qty}, altGroup: ${_this.altGroup}, position: ${_this.position}, food: ${_this.food})';
}


}

/// @nodoc
abstract mixin class $DietItemCopyWith<$Res>  {
  factory $DietItemCopyWith(DietItem value, $Res Function(DietItem) _then) = _$DietItemCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'food_id') String foodId,@JsonKey(fromJson: _num) double qty,@JsonKey(name: 'alt_group') int altGroup, int position, Food? food
});


$FoodCopyWith<$Res>? get food;

}
/// @nodoc
class _$DietItemCopyWithImpl<$Res>
    implements $DietItemCopyWith<$Res> {
  _$DietItemCopyWithImpl(this._self, this._then);

  final DietItem _self;
  final $Res Function(DietItem) _then;

/// Create a copy of DietItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? foodId = null,Object? qty = null,Object? altGroup = null,Object? position = null,Object? food = freezed,}) {
  return _then(DietItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,foodId: null == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,altGroup: null == altGroup ? _self.altGroup : altGroup // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as Food?,
  ));
}
/// Create a copy of DietItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FoodCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $FoodCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}
}


/// Adds pattern-matching-related methods to [DietItem].
extension DietItemPatterns on DietItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietItem value)  $default,){
final _that = this;
switch (_that) {
case _DietItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietItem value)?  $default,){
final _that = this;
switch (_that) {
case _DietItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'food_id')  String foodId, @JsonKey(fromJson: _num)  double qty, @JsonKey(name: 'alt_group')  int altGroup,  int position,  Food? food)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietItem() when $default != null:
return $default(_that.id,_that.foodId,_that.qty,_that.altGroup,_that.position,_that.food);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'food_id')  String foodId, @JsonKey(fromJson: _num)  double qty, @JsonKey(name: 'alt_group')  int altGroup,  int position,  Food? food)  $default,) {final _that = this;
switch (_that) {
case _DietItem():
return $default(_that.id,_that.foodId,_that.qty,_that.altGroup,_that.position,_that.food);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'food_id')  String foodId, @JsonKey(fromJson: _num)  double qty, @JsonKey(name: 'alt_group')  int altGroup,  int position,  Food? food)?  $default,) {final _that = this;
switch (_that) {
case _DietItem() when $default != null:
return $default(_that.id,_that.foodId,_that.qty,_that.altGroup,_that.position,_that.food);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DietItem implements DietItem {
  const _DietItem({this.id, @JsonKey(name: 'food_id') required this.foodId, @JsonKey(fromJson: _num) required this.qty, @JsonKey(name: 'alt_group') this.altGroup = 0, this.position = 1, this.food});
  factory _DietItem.fromJson(Map<String, dynamic> json) => _$DietItemFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'food_id') final  String foodId;
@override@JsonKey(fromJson: _num) final  double qty;
@override@JsonKey(name: 'alt_group') final  int altGroup;
@override@JsonKey() final  int position;
@override final  Food? food;

/// Create a copy of DietItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietItemCopyWith<_DietItem> get copyWith => __$DietItemCopyWithImpl<_DietItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DietItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietItem&&(identical(other.id, id) || other.id == id)&&(identical(other.foodId, foodId) || other.foodId == foodId)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.altGroup, altGroup) || other.altGroup == altGroup)&&(identical(other.position, position) || other.position == position)&&(identical(other.food, food) || other.food == food));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,foodId,qty,altGroup,position,food);
}

@override
String toString() {
    return 'DietItem(id: $id, foodId: $foodId, qty: $qty, altGroup: $altGroup, position: $position, food: $food)';
}


}

/// @nodoc
abstract mixin class _$DietItemCopyWith<$Res> implements $DietItemCopyWith<$Res> {
  factory _$DietItemCopyWith(_DietItem value, $Res Function(_DietItem) _then) = __$DietItemCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'food_id') String foodId,@JsonKey(fromJson: _num) double qty,@JsonKey(name: 'alt_group') int altGroup, int position, Food? food
});


@override $FoodCopyWith<$Res>? get food;

}
/// @nodoc
class __$DietItemCopyWithImpl<$Res>
    implements _$DietItemCopyWith<$Res> {
  __$DietItemCopyWithImpl(this._self, this._then);

  final _DietItem _self;
  final $Res Function(_DietItem) _then;

/// Create a copy of DietItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? foodId = null,Object? qty = null,Object? altGroup = null,Object? position = null,Object? food = freezed,}) {
  return _then(_DietItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,foodId: null == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,altGroup: null == altGroup ? _self.altGroup : altGroup // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,food: freezed == food ? _self.food : food // ignore: cast_nullable_to_non_nullable
as Food?,
  ));
}

/// Create a copy of DietItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FoodCopyWith<$Res>? get food {
    if (_self.food == null) {
    return null;
  }

  return $FoodCopyWith<$Res>(_self.food!, (value) {
    return _then(_self.copyWith(food: value));
  });
}
}


/// @nodoc
mixin _$DietMeal {

 String? get id;@JsonKey(name: 'meal_slot') String get slot;@JsonKey(name: 'time_of_day') String? get time; int get position; String? get notes;@JsonKey(name: 'diet_meal_items') List<DietItem> get items;
/// Create a copy of DietMeal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietMealCopyWith<DietMeal> get copyWith => _$DietMealCopyWithImpl<DietMeal>(this as DietMeal, _$identity);

  /// Serializes this DietMeal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DietMeal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietMeal&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DietMeal;
  return Object.hash(runtimeType,_this.id,_this.slot,_this.time,_this.position,_this.notes,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as DietMeal;
  return 'DietMeal(id: ${_this.id}, slot: ${_this.slot}, time: ${_this.time}, position: ${_this.position}, notes: ${_this.notes}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $DietMealCopyWith<$Res>  {
  factory $DietMealCopyWith(DietMeal value, $Res Function(DietMeal) _then) = _$DietMealCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'meal_slot') String slot,@JsonKey(name: 'time_of_day') String? time, int position, String? notes,@JsonKey(name: 'diet_meal_items') List<DietItem> items
});




}
/// @nodoc
class _$DietMealCopyWithImpl<$Res>
    implements $DietMealCopyWith<$Res> {
  _$DietMealCopyWithImpl(this._self, this._then);

  final DietMeal _self;
  final $Res Function(DietMeal) _then;

/// Create a copy of DietMeal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? slot = null,Object? time = freezed,Object? position = null,Object? notes = freezed,Object? items = null,}) {
  return _then(DietMeal(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DietItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [DietMeal].
extension DietMealPatterns on DietMeal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietMeal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietMeal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietMeal value)  $default,){
final _that = this;
switch (_that) {
case _DietMeal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietMeal value)?  $default,){
final _that = this;
switch (_that) {
case _DietMeal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'meal_slot')  String slot, @JsonKey(name: 'time_of_day')  String? time,  int position,  String? notes, @JsonKey(name: 'diet_meal_items')  List<DietItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietMeal() when $default != null:
return $default(_that.id,_that.slot,_that.time,_that.position,_that.notes,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'meal_slot')  String slot, @JsonKey(name: 'time_of_day')  String? time,  int position,  String? notes, @JsonKey(name: 'diet_meal_items')  List<DietItem> items)  $default,) {final _that = this;
switch (_that) {
case _DietMeal():
return $default(_that.id,_that.slot,_that.time,_that.position,_that.notes,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'meal_slot')  String slot, @JsonKey(name: 'time_of_day')  String? time,  int position,  String? notes, @JsonKey(name: 'diet_meal_items')  List<DietItem> items)?  $default,) {final _that = this;
switch (_that) {
case _DietMeal() when $default != null:
return $default(_that.id,_that.slot,_that.time,_that.position,_that.notes,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DietMeal extends DietMeal {
  const _DietMeal({this.id, @JsonKey(name: 'meal_slot') required this.slot, @JsonKey(name: 'time_of_day') this.time, this.position = 1, this.notes, @JsonKey(name: 'diet_meal_items')  List<DietItem> items = const <DietItem>[]}): _items = items,super._();
  factory _DietMeal.fromJson(Map<String, dynamic> json) => _$DietMealFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'meal_slot') final  String slot;
@override@JsonKey(name: 'time_of_day') final  String? time;
@override@JsonKey() final  int position;
@override final  String? notes;
 final  List<DietItem> _items;
@override@JsonKey(name: 'diet_meal_items') List<DietItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of DietMeal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietMealCopyWith<_DietMeal> get copyWith => __$DietMealCopyWithImpl<_DietMeal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DietMealToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietMeal&&(identical(other.id, id) || other.id == id)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.time, time) || other.time == time)&&(identical(other.position, position) || other.position == position)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slot,time,position,notes,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'DietMeal(id: $id, slot: $slot, time: $time, position: $position, notes: $notes, items: $items)';
}


}

/// @nodoc
abstract mixin class _$DietMealCopyWith<$Res> implements $DietMealCopyWith<$Res> {
  factory _$DietMealCopyWith(_DietMeal value, $Res Function(_DietMeal) _then) = __$DietMealCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'meal_slot') String slot,@JsonKey(name: 'time_of_day') String? time, int position, String? notes,@JsonKey(name: 'diet_meal_items') List<DietItem> items
});




}
/// @nodoc
class __$DietMealCopyWithImpl<$Res>
    implements _$DietMealCopyWith<$Res> {
  __$DietMealCopyWithImpl(this._self, this._then);

  final _DietMeal _self;
  final $Res Function(_DietMeal) _then;

/// Create a copy of DietMeal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? slot = null,Object? time = freezed,Object? position = null,Object? notes = freezed,Object? items = null,}) {
  return _then(_DietMeal(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DietItem>,
  ));
}


}


/// @nodoc
mixin _$DietTemplate {

 String? get id; String get name; String? get description; String? get goal;@JsonKey(name: 'diet_pref') String? get dietPref;@JsonKey(name: 'kcal_target') int get kcalTarget;@JsonKey(name: 'protein_g') int? get proteinG;@JsonKey(name: 'carbs_g') int? get carbsG;@JsonKey(name: 'fat_g') int? get fatG;@JsonKey(name: 'macro_preset') String? get macroPreset; List<String> get supplements;@JsonKey(name: 'is_gym_template') bool get isGymTemplate;@JsonKey(name: 'is_starter') bool get isStarter;@JsonKey(name: 'source_template_id') String? get sourceTemplateId;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'diet_meals') List<DietMeal> get meals;
/// Create a copy of DietTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietTemplateCopyWith<DietTemplate> get copyWith => _$DietTemplateCopyWithImpl<DietTemplate>(this as DietTemplate, _$identity);

  /// Serializes this DietTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DietTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietTemplate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.dietPref, _this.dietPref) || other.dietPref == _this.dietPref)&&(identical(other.kcalTarget, _this.kcalTarget) || other.kcalTarget == _this.kcalTarget)&&(identical(other.proteinG, _this.proteinG) || other.proteinG == _this.proteinG)&&(identical(other.carbsG, _this.carbsG) || other.carbsG == _this.carbsG)&&(identical(other.fatG, _this.fatG) || other.fatG == _this.fatG)&&(identical(other.macroPreset, _this.macroPreset) || other.macroPreset == _this.macroPreset)&&const DeepCollectionEquality().equals(other.supplements, _this.supplements)&&(identical(other.isGymTemplate, _this.isGymTemplate) || other.isGymTemplate == _this.isGymTemplate)&&(identical(other.isStarter, _this.isStarter) || other.isStarter == _this.isStarter)&&(identical(other.sourceTemplateId, _this.sourceTemplateId) || other.sourceTemplateId == _this.sourceTemplateId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&const DeepCollectionEquality().equals(other.meals, _this.meals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DietTemplate;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.goal,_this.dietPref,_this.kcalTarget,_this.proteinG,_this.carbsG,_this.fatG,_this.macroPreset,const DeepCollectionEquality().hash(_this.supplements),_this.isGymTemplate,_this.isStarter,_this.sourceTemplateId,_this.createdBy,const DeepCollectionEquality().hash(_this.meals));
}

@override
String toString() {
  final _this = this as DietTemplate;
  return 'DietTemplate(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, goal: ${_this.goal}, dietPref: ${_this.dietPref}, kcalTarget: ${_this.kcalTarget}, proteinG: ${_this.proteinG}, carbsG: ${_this.carbsG}, fatG: ${_this.fatG}, macroPreset: ${_this.macroPreset}, supplements: ${_this.supplements}, isGymTemplate: ${_this.isGymTemplate}, isStarter: ${_this.isStarter}, sourceTemplateId: ${_this.sourceTemplateId}, createdBy: ${_this.createdBy}, meals: ${_this.meals})';
}


}

/// @nodoc
abstract mixin class $DietTemplateCopyWith<$Res>  {
  factory $DietTemplateCopyWith(DietTemplate value, $Res Function(DietTemplate) _then) = _$DietTemplateCopyWithImpl;
@useResult
$Res call({
 String? id, String name, String? description, String? goal,@JsonKey(name: 'diet_pref') String? dietPref,@JsonKey(name: 'kcal_target') int kcalTarget,@JsonKey(name: 'protein_g') int? proteinG,@JsonKey(name: 'carbs_g') int? carbsG,@JsonKey(name: 'fat_g') int? fatG,@JsonKey(name: 'macro_preset') String? macroPreset, List<String> supplements,@JsonKey(name: 'is_gym_template') bool isGymTemplate,@JsonKey(name: 'is_starter') bool isStarter,@JsonKey(name: 'source_template_id') String? sourceTemplateId,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'diet_meals') List<DietMeal> meals
});




}
/// @nodoc
class _$DietTemplateCopyWithImpl<$Res>
    implements $DietTemplateCopyWith<$Res> {
  _$DietTemplateCopyWithImpl(this._self, this._then);

  final DietTemplate _self;
  final $Res Function(DietTemplate) _then;

/// Create a copy of DietTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? goal = freezed,Object? dietPref = freezed,Object? kcalTarget = null,Object? proteinG = freezed,Object? carbsG = freezed,Object? fatG = freezed,Object? macroPreset = freezed,Object? supplements = null,Object? isGymTemplate = null,Object? isStarter = null,Object? sourceTemplateId = freezed,Object? createdBy = freezed,Object? meals = null,}) {
  return _then(DietTemplate(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,dietPref: freezed == dietPref ? _self.dietPref : dietPref // ignore: cast_nullable_to_non_nullable
as String?,kcalTarget: null == kcalTarget ? _self.kcalTarget : kcalTarget // ignore: cast_nullable_to_non_nullable
as int,proteinG: freezed == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as int?,carbsG: freezed == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as int?,fatG: freezed == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as int?,macroPreset: freezed == macroPreset ? _self.macroPreset : macroPreset // ignore: cast_nullable_to_non_nullable
as String?,supplements: null == supplements ? _self.supplements : supplements // ignore: cast_nullable_to_non_nullable
as List<String>,isGymTemplate: null == isGymTemplate ? _self.isGymTemplate : isGymTemplate // ignore: cast_nullable_to_non_nullable
as bool,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as List<DietMeal>,
  ));
}

}


/// Adds pattern-matching-related methods to [DietTemplate].
extension DietTemplatePatterns on DietTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietTemplate value)  $default,){
final _that = this;
switch (_that) {
case _DietTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _DietTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  String? description,  String? goal, @JsonKey(name: 'diet_pref')  String? dietPref, @JsonKey(name: 'kcal_target')  int kcalTarget, @JsonKey(name: 'protein_g')  int? proteinG, @JsonKey(name: 'carbs_g')  int? carbsG, @JsonKey(name: 'fat_g')  int? fatG, @JsonKey(name: 'macro_preset')  String? macroPreset,  List<String> supplements, @JsonKey(name: 'is_gym_template')  bool isGymTemplate, @JsonKey(name: 'is_starter')  bool isStarter, @JsonKey(name: 'source_template_id')  String? sourceTemplateId, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'diet_meals')  List<DietMeal> meals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.goal,_that.dietPref,_that.kcalTarget,_that.proteinG,_that.carbsG,_that.fatG,_that.macroPreset,_that.supplements,_that.isGymTemplate,_that.isStarter,_that.sourceTemplateId,_that.createdBy,_that.meals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  String? description,  String? goal, @JsonKey(name: 'diet_pref')  String? dietPref, @JsonKey(name: 'kcal_target')  int kcalTarget, @JsonKey(name: 'protein_g')  int? proteinG, @JsonKey(name: 'carbs_g')  int? carbsG, @JsonKey(name: 'fat_g')  int? fatG, @JsonKey(name: 'macro_preset')  String? macroPreset,  List<String> supplements, @JsonKey(name: 'is_gym_template')  bool isGymTemplate, @JsonKey(name: 'is_starter')  bool isStarter, @JsonKey(name: 'source_template_id')  String? sourceTemplateId, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'diet_meals')  List<DietMeal> meals)  $default,) {final _that = this;
switch (_that) {
case _DietTemplate():
return $default(_that.id,_that.name,_that.description,_that.goal,_that.dietPref,_that.kcalTarget,_that.proteinG,_that.carbsG,_that.fatG,_that.macroPreset,_that.supplements,_that.isGymTemplate,_that.isStarter,_that.sourceTemplateId,_that.createdBy,_that.meals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  String? description,  String? goal, @JsonKey(name: 'diet_pref')  String? dietPref, @JsonKey(name: 'kcal_target')  int kcalTarget, @JsonKey(name: 'protein_g')  int? proteinG, @JsonKey(name: 'carbs_g')  int? carbsG, @JsonKey(name: 'fat_g')  int? fatG, @JsonKey(name: 'macro_preset')  String? macroPreset,  List<String> supplements, @JsonKey(name: 'is_gym_template')  bool isGymTemplate, @JsonKey(name: 'is_starter')  bool isStarter, @JsonKey(name: 'source_template_id')  String? sourceTemplateId, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'diet_meals')  List<DietMeal> meals)?  $default,) {final _that = this;
switch (_that) {
case _DietTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.goal,_that.dietPref,_that.kcalTarget,_that.proteinG,_that.carbsG,_that.fatG,_that.macroPreset,_that.supplements,_that.isGymTemplate,_that.isStarter,_that.sourceTemplateId,_that.createdBy,_that.meals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DietTemplate extends DietTemplate {
  const _DietTemplate({this.id, required this.name, this.description, this.goal, @JsonKey(name: 'diet_pref') this.dietPref, @JsonKey(name: 'kcal_target') this.kcalTarget = 2000, @JsonKey(name: 'protein_g') this.proteinG, @JsonKey(name: 'carbs_g') this.carbsG, @JsonKey(name: 'fat_g') this.fatG, @JsonKey(name: 'macro_preset') this.macroPreset,  List<String> supplements = const <String>[], @JsonKey(name: 'is_gym_template') this.isGymTemplate = true, @JsonKey(name: 'is_starter') this.isStarter = false, @JsonKey(name: 'source_template_id') this.sourceTemplateId, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'diet_meals')  List<DietMeal> meals = const <DietMeal>[]}): _supplements = supplements,_meals = meals,super._();
  factory _DietTemplate.fromJson(Map<String, dynamic> json) => _$DietTemplateFromJson(json);

@override final  String? id;
@override final  String name;
@override final  String? description;
@override final  String? goal;
@override@JsonKey(name: 'diet_pref') final  String? dietPref;
@override@JsonKey(name: 'kcal_target') final  int kcalTarget;
@override@JsonKey(name: 'protein_g') final  int? proteinG;
@override@JsonKey(name: 'carbs_g') final  int? carbsG;
@override@JsonKey(name: 'fat_g') final  int? fatG;
@override@JsonKey(name: 'macro_preset') final  String? macroPreset;
 final  List<String> _supplements;
@override@JsonKey() List<String> get supplements {
  if (_supplements is EqualUnmodifiableListView) return _supplements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supplements);
}

@override@JsonKey(name: 'is_gym_template') final  bool isGymTemplate;
@override@JsonKey(name: 'is_starter') final  bool isStarter;
@override@JsonKey(name: 'source_template_id') final  String? sourceTemplateId;
@override@JsonKey(name: 'created_by') final  String? createdBy;
 final  List<DietMeal> _meals;
@override@JsonKey(name: 'diet_meals') List<DietMeal> get meals {
  if (_meals is EqualUnmodifiableListView) return _meals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meals);
}


/// Create a copy of DietTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietTemplateCopyWith<_DietTemplate> get copyWith => __$DietTemplateCopyWithImpl<_DietTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DietTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.dietPref, dietPref) || other.dietPref == dietPref)&&(identical(other.kcalTarget, kcalTarget) || other.kcalTarget == kcalTarget)&&(identical(other.proteinG, proteinG) || other.proteinG == proteinG)&&(identical(other.carbsG, carbsG) || other.carbsG == carbsG)&&(identical(other.fatG, fatG) || other.fatG == fatG)&&(identical(other.macroPreset, macroPreset) || other.macroPreset == macroPreset)&&const DeepCollectionEquality().equals(other.supplements, _supplements)&&(identical(other.isGymTemplate, isGymTemplate) || other.isGymTemplate == isGymTemplate)&&(identical(other.isStarter, isStarter) || other.isStarter == isStarter)&&(identical(other.sourceTemplateId, sourceTemplateId) || other.sourceTemplateId == sourceTemplateId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other.meals, _meals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,goal,dietPref,kcalTarget,proteinG,carbsG,fatG,macroPreset,const DeepCollectionEquality().hash(_supplements),isGymTemplate,isStarter,sourceTemplateId,createdBy,const DeepCollectionEquality().hash(_meals));
}

@override
String toString() {
    return 'DietTemplate(id: $id, name: $name, description: $description, goal: $goal, dietPref: $dietPref, kcalTarget: $kcalTarget, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, macroPreset: $macroPreset, supplements: $supplements, isGymTemplate: $isGymTemplate, isStarter: $isStarter, sourceTemplateId: $sourceTemplateId, createdBy: $createdBy, meals: $meals)';
}


}

/// @nodoc
abstract mixin class _$DietTemplateCopyWith<$Res> implements $DietTemplateCopyWith<$Res> {
  factory _$DietTemplateCopyWith(_DietTemplate value, $Res Function(_DietTemplate) _then) = __$DietTemplateCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, String? description, String? goal,@JsonKey(name: 'diet_pref') String? dietPref,@JsonKey(name: 'kcal_target') int kcalTarget,@JsonKey(name: 'protein_g') int? proteinG,@JsonKey(name: 'carbs_g') int? carbsG,@JsonKey(name: 'fat_g') int? fatG,@JsonKey(name: 'macro_preset') String? macroPreset, List<String> supplements,@JsonKey(name: 'is_gym_template') bool isGymTemplate,@JsonKey(name: 'is_starter') bool isStarter,@JsonKey(name: 'source_template_id') String? sourceTemplateId,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'diet_meals') List<DietMeal> meals
});




}
/// @nodoc
class __$DietTemplateCopyWithImpl<$Res>
    implements _$DietTemplateCopyWith<$Res> {
  __$DietTemplateCopyWithImpl(this._self, this._then);

  final _DietTemplate _self;
  final $Res Function(_DietTemplate) _then;

/// Create a copy of DietTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? goal = freezed,Object? dietPref = freezed,Object? kcalTarget = null,Object? proteinG = freezed,Object? carbsG = freezed,Object? fatG = freezed,Object? macroPreset = freezed,Object? supplements = null,Object? isGymTemplate = null,Object? isStarter = null,Object? sourceTemplateId = freezed,Object? createdBy = freezed,Object? meals = null,}) {
  return _then(_DietTemplate(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,dietPref: freezed == dietPref ? _self.dietPref : dietPref // ignore: cast_nullable_to_non_nullable
as String?,kcalTarget: null == kcalTarget ? _self.kcalTarget : kcalTarget // ignore: cast_nullable_to_non_nullable
as int,proteinG: freezed == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as int?,carbsG: freezed == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as int?,fatG: freezed == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as int?,macroPreset: freezed == macroPreset ? _self.macroPreset : macroPreset // ignore: cast_nullable_to_non_nullable
as String?,supplements: null == supplements ? _self._supplements : supplements // ignore: cast_nullable_to_non_nullable
as List<String>,isGymTemplate: null == isGymTemplate ? _self.isGymTemplate : isGymTemplate // ignore: cast_nullable_to_non_nullable
as bool,isStarter: null == isStarter ? _self.isStarter : isStarter // ignore: cast_nullable_to_non_nullable
as bool,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,meals: null == meals ? _self._meals : meals // ignore: cast_nullable_to_non_nullable
as List<DietMeal>,
  ));
}


}


/// @nodoc
mixin _$MemberDiet {

 String get id;@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'template_id') String get templateId;@JsonKey(name: 'source_template_id') String? get sourceTemplateId; String get name;@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? get startDate;@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? get endDate; DietStatus get status;@JsonKey(name: 'assigned_at') DateTime? get assignedAt; DietTemplate? get template;
/// Create a copy of MemberDiet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberDietCopyWith<MemberDiet> get copyWith => _$MemberDietCopyWithImpl<MemberDiet>(this as MemberDiet, _$identity);

  /// Serializes this MemberDiet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemberDiet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberDiet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.templateId, _this.templateId) || other.templateId == _this.templateId)&&(identical(other.sourceTemplateId, _this.sourceTemplateId) || other.sourceTemplateId == _this.sourceTemplateId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.assignedAt, _this.assignedAt) || other.assignedAt == _this.assignedAt)&&(identical(other.template, _this.template) || other.template == _this.template));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemberDiet;
  return Object.hash(runtimeType,_this.id,_this.memberId,_this.templateId,_this.sourceTemplateId,_this.name,_this.startDate,_this.endDate,_this.status,_this.assignedAt,_this.template);
}

@override
String toString() {
  final _this = this as MemberDiet;
  return 'MemberDiet(id: ${_this.id}, memberId: ${_this.memberId}, templateId: ${_this.templateId}, sourceTemplateId: ${_this.sourceTemplateId}, name: ${_this.name}, startDate: ${_this.startDate}, endDate: ${_this.endDate}, status: ${_this.status}, assignedAt: ${_this.assignedAt}, template: ${_this.template})';
}


}

/// @nodoc
abstract mixin class $MemberDietCopyWith<$Res>  {
  factory $MemberDietCopyWith(MemberDiet value, $Res Function(MemberDiet) _then) = _$MemberDietCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'template_id') String templateId,@JsonKey(name: 'source_template_id') String? sourceTemplateId, String name,@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? startDate,@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? endDate, DietStatus status,@JsonKey(name: 'assigned_at') DateTime? assignedAt, DietTemplate? template
});


$DietTemplateCopyWith<$Res>? get template;

}
/// @nodoc
class _$MemberDietCopyWithImpl<$Res>
    implements $MemberDietCopyWith<$Res> {
  _$MemberDietCopyWithImpl(this._self, this._then);

  final MemberDiet _self;
  final $Res Function(MemberDiet) _then;

/// Create a copy of MemberDiet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberId = null,Object? templateId = null,Object? sourceTemplateId = freezed,Object? name = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? assignedAt = freezed,Object? template = freezed,}) {
  return _then(MemberDiet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DietStatus,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as DietTemplate?,
  ));
}
/// Create a copy of MemberDiet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DietTemplateCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $DietTemplateCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}


/// Adds pattern-matching-related methods to [MemberDiet].
extension MemberDietPatterns on MemberDiet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberDiet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberDiet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberDiet value)  $default,){
final _that = this;
switch (_that) {
case _MemberDiet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberDiet value)?  $default,){
final _that = this;
switch (_that) {
case _MemberDiet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_id')  String templateId, @JsonKey(name: 'source_template_id')  String? sourceTemplateId,  String name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate,  DietStatus status, @JsonKey(name: 'assigned_at')  DateTime? assignedAt,  DietTemplate? template)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberDiet() when $default != null:
return $default(_that.id,_that.memberId,_that.templateId,_that.sourceTemplateId,_that.name,_that.startDate,_that.endDate,_that.status,_that.assignedAt,_that.template);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_id')  String templateId, @JsonKey(name: 'source_template_id')  String? sourceTemplateId,  String name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate,  DietStatus status, @JsonKey(name: 'assigned_at')  DateTime? assignedAt,  DietTemplate? template)  $default,) {final _that = this;
switch (_that) {
case _MemberDiet():
return $default(_that.id,_that.memberId,_that.templateId,_that.sourceTemplateId,_that.name,_that.startDate,_that.endDate,_that.status,_that.assignedAt,_that.template);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'template_id')  String templateId, @JsonKey(name: 'source_template_id')  String? sourceTemplateId,  String name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut)  DateTime? startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut)  DateTime? endDate,  DietStatus status, @JsonKey(name: 'assigned_at')  DateTime? assignedAt,  DietTemplate? template)?  $default,) {final _that = this;
switch (_that) {
case _MemberDiet() when $default != null:
return $default(_that.id,_that.memberId,_that.templateId,_that.sourceTemplateId,_that.name,_that.startDate,_that.endDate,_that.status,_that.assignedAt,_that.template);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberDiet implements MemberDiet {
  const _MemberDiet({required this.id, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'template_id') required this.templateId, @JsonKey(name: 'source_template_id') this.sourceTemplateId, required this.name, @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) required this.startDate, @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) this.endDate, this.status = DietStatus.active, @JsonKey(name: 'assigned_at') this.assignedAt, this.template});
  factory _MemberDiet.fromJson(Map<String, dynamic> json) => _$MemberDietFromJson(json);

@override final  String id;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'template_id') final  String templateId;
@override@JsonKey(name: 'source_template_id') final  String? sourceTemplateId;
@override final  String name;
@override@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) final  DateTime? startDate;
@override@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) final  DateTime? endDate;
@override@JsonKey() final  DietStatus status;
@override@JsonKey(name: 'assigned_at') final  DateTime? assignedAt;
@override final  DietTemplate? template;

/// Create a copy of MemberDiet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberDietCopyWith<_MemberDiet> get copyWith => __$MemberDietCopyWithImpl<_MemberDiet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberDietToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberDiet&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.sourceTemplateId, sourceTemplateId) || other.sourceTemplateId == sourceTemplateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.template, template) || other.template == template));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,memberId,templateId,sourceTemplateId,name,startDate,endDate,status,assignedAt,template);
}

@override
String toString() {
    return 'MemberDiet(id: $id, memberId: $memberId, templateId: $templateId, sourceTemplateId: $sourceTemplateId, name: $name, startDate: $startDate, endDate: $endDate, status: $status, assignedAt: $assignedAt, template: $template)';
}


}

/// @nodoc
abstract mixin class _$MemberDietCopyWith<$Res> implements $MemberDietCopyWith<$Res> {
  factory _$MemberDietCopyWith(_MemberDiet value, $Res Function(_MemberDiet) _then) = __$MemberDietCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'template_id') String templateId,@JsonKey(name: 'source_template_id') String? sourceTemplateId, String name,@JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) DateTime? startDate,@JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? endDate, DietStatus status,@JsonKey(name: 'assigned_at') DateTime? assignedAt, DietTemplate? template
});


@override $DietTemplateCopyWith<$Res>? get template;

}
/// @nodoc
class __$MemberDietCopyWithImpl<$Res>
    implements _$MemberDietCopyWith<$Res> {
  __$MemberDietCopyWithImpl(this._self, this._then);

  final _MemberDiet _self;
  final $Res Function(_MemberDiet) _then;

/// Create a copy of MemberDiet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberId = null,Object? templateId = null,Object? sourceTemplateId = freezed,Object? name = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = null,Object? assignedAt = freezed,Object? template = freezed,}) {
  return _then(_MemberDiet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,sourceTemplateId: freezed == sourceTemplateId ? _self.sourceTemplateId : sourceTemplateId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DietStatus,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as DietTemplate?,
  ));
}

/// Create a copy of MemberDiet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DietTemplateCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $DietTemplateCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}


/// @nodoc
mixin _$MealLog {

 String? get id;@JsonKey(name: 'member_id') String get memberId;@JsonKey(name: 'member_diet_id') String? get memberDietId;@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day;@JsonKey(name: 'meal_slot') String get slot; String get status;@JsonKey(name: 'alt_group') int? get altGroup;@JsonKey(fromJson: _num) double get kcal;@JsonKey(name: 'protein_g', fromJson: _num) double get protein;@JsonKey(name: 'carbs_g', fromJson: _num) double get carbs;@JsonKey(name: 'fat_g', fromJson: _num) double get fat;@JsonKey(name: 'logged_at') DateTime? get loggedAt;
/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealLogCopyWith<MealLog> get copyWith => _$MealLogCopyWithImpl<MealLog>(this as MealLog, _$identity);

  /// Serializes this MealLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MealLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.memberDietId, _this.memberDietId) || other.memberDietId == _this.memberDietId)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.altGroup, _this.altGroup) || other.altGroup == _this.altGroup)&&(identical(other.kcal, _this.kcal) || other.kcal == _this.kcal)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&(identical(other.loggedAt, _this.loggedAt) || other.loggedAt == _this.loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MealLog;
  return Object.hash(runtimeType,_this.id,_this.memberId,_this.memberDietId,_this.day,_this.slot,_this.status,_this.altGroup,_this.kcal,_this.protein,_this.carbs,_this.fat,_this.loggedAt);
}

@override
String toString() {
  final _this = this as MealLog;
  return 'MealLog(id: ${_this.id}, memberId: ${_this.memberId}, memberDietId: ${_this.memberDietId}, day: ${_this.day}, slot: ${_this.slot}, status: ${_this.status}, altGroup: ${_this.altGroup}, kcal: ${_this.kcal}, protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat}, loggedAt: ${_this.loggedAt})';
}


}

/// @nodoc
abstract mixin class $MealLogCopyWith<$Res>  {
  factory $MealLogCopyWith(MealLog value, $Res Function(MealLog) _then) = _$MealLogCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'member_diet_id') String? memberDietId,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'meal_slot') String slot, String status,@JsonKey(name: 'alt_group') int? altGroup,@JsonKey(fromJson: _num) double kcal,@JsonKey(name: 'protein_g', fromJson: _num) double protein,@JsonKey(name: 'carbs_g', fromJson: _num) double carbs,@JsonKey(name: 'fat_g', fromJson: _num) double fat,@JsonKey(name: 'logged_at') DateTime? loggedAt
});




}
/// @nodoc
class _$MealLogCopyWithImpl<$Res>
    implements $MealLogCopyWith<$Res> {
  _$MealLogCopyWithImpl(this._self, this._then);

  final MealLog _self;
  final $Res Function(MealLog) _then;

/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? memberId = null,Object? memberDietId = freezed,Object? day = freezed,Object? slot = null,Object? status = null,Object? altGroup = freezed,Object? kcal = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? loggedAt = freezed,}) {
  return _then(MealLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,memberDietId: freezed == memberDietId ? _self.memberDietId : memberDietId // ignore: cast_nullable_to_non_nullable
as String?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,altGroup: freezed == altGroup ? _self.altGroup : altGroup // ignore: cast_nullable_to_non_nullable
as int?,kcal: null == kcal ? _self.kcal : kcal // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,loggedAt: freezed == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MealLog].
extension MealLogPatterns on MealLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealLog value)  $default,){
final _that = this;
switch (_that) {
case _MealLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealLog value)?  $default,){
final _that = this;
switch (_that) {
case _MealLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'member_diet_id')  String? memberDietId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'meal_slot')  String slot,  String status, @JsonKey(name: 'alt_group')  int? altGroup, @JsonKey(fromJson: _num)  double kcal, @JsonKey(name: 'protein_g', fromJson: _num)  double protein, @JsonKey(name: 'carbs_g', fromJson: _num)  double carbs, @JsonKey(name: 'fat_g', fromJson: _num)  double fat, @JsonKey(name: 'logged_at')  DateTime? loggedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealLog() when $default != null:
return $default(_that.id,_that.memberId,_that.memberDietId,_that.day,_that.slot,_that.status,_that.altGroup,_that.kcal,_that.protein,_that.carbs,_that.fat,_that.loggedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'member_diet_id')  String? memberDietId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'meal_slot')  String slot,  String status, @JsonKey(name: 'alt_group')  int? altGroup, @JsonKey(fromJson: _num)  double kcal, @JsonKey(name: 'protein_g', fromJson: _num)  double protein, @JsonKey(name: 'carbs_g', fromJson: _num)  double carbs, @JsonKey(name: 'fat_g', fromJson: _num)  double fat, @JsonKey(name: 'logged_at')  DateTime? loggedAt)  $default,) {final _that = this;
switch (_that) {
case _MealLog():
return $default(_that.id,_that.memberId,_that.memberDietId,_that.day,_that.slot,_that.status,_that.altGroup,_that.kcal,_that.protein,_that.carbs,_that.fat,_that.loggedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'member_id')  String memberId, @JsonKey(name: 'member_diet_id')  String? memberDietId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'meal_slot')  String slot,  String status, @JsonKey(name: 'alt_group')  int? altGroup, @JsonKey(fromJson: _num)  double kcal, @JsonKey(name: 'protein_g', fromJson: _num)  double protein, @JsonKey(name: 'carbs_g', fromJson: _num)  double carbs, @JsonKey(name: 'fat_g', fromJson: _num)  double fat, @JsonKey(name: 'logged_at')  DateTime? loggedAt)?  $default,) {final _that = this;
switch (_that) {
case _MealLog() when $default != null:
return $default(_that.id,_that.memberId,_that.memberDietId,_that.day,_that.slot,_that.status,_that.altGroup,_that.kcal,_that.protein,_that.carbs,_that.fat,_that.loggedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealLog extends MealLog {
  const _MealLog({this.id, @JsonKey(name: 'member_id') required this.memberId, @JsonKey(name: 'member_diet_id') this.memberDietId, @JsonKey(fromJson: _date, toJson: _dateOut) required this.day, @JsonKey(name: 'meal_slot') required this.slot, required this.status, @JsonKey(name: 'alt_group') this.altGroup, @JsonKey(fromJson: _num) this.kcal = 0, @JsonKey(name: 'protein_g', fromJson: _num) this.protein = 0, @JsonKey(name: 'carbs_g', fromJson: _num) this.carbs = 0, @JsonKey(name: 'fat_g', fromJson: _num) this.fat = 0, @JsonKey(name: 'logged_at') this.loggedAt}): super._();
  factory _MealLog.fromJson(Map<String, dynamic> json) => _$MealLogFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey(name: 'member_diet_id') final  String? memberDietId;
@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override@JsonKey(name: 'meal_slot') final  String slot;
@override final  String status;
@override@JsonKey(name: 'alt_group') final  int? altGroup;
@override@JsonKey(fromJson: _num) final  double kcal;
@override@JsonKey(name: 'protein_g', fromJson: _num) final  double protein;
@override@JsonKey(name: 'carbs_g', fromJson: _num) final  double carbs;
@override@JsonKey(name: 'fat_g', fromJson: _num) final  double fat;
@override@JsonKey(name: 'logged_at') final  DateTime? loggedAt;

/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealLogCopyWith<_MealLog> get copyWith => __$MealLogCopyWithImpl<_MealLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealLog&&(identical(other.id, id) || other.id == id)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.memberDietId, memberDietId) || other.memberDietId == memberDietId)&&(identical(other.day, day) || other.day == day)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.status, status) || other.status == status)&&(identical(other.altGroup, altGroup) || other.altGroup == altGroup)&&(identical(other.kcal, kcal) || other.kcal == kcal)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,memberId,memberDietId,day,slot,status,altGroup,kcal,protein,carbs,fat,loggedAt);
}

@override
String toString() {
    return 'MealLog(id: $id, memberId: $memberId, memberDietId: $memberDietId, day: $day, slot: $slot, status: $status, altGroup: $altGroup, kcal: $kcal, protein: $protein, carbs: $carbs, fat: $fat, loggedAt: $loggedAt)';
}


}

/// @nodoc
abstract mixin class _$MealLogCopyWith<$Res> implements $MealLogCopyWith<$Res> {
  factory _$MealLogCopyWith(_MealLog value, $Res Function(_MealLog) _then) = __$MealLogCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'member_id') String memberId,@JsonKey(name: 'member_diet_id') String? memberDietId,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'meal_slot') String slot, String status,@JsonKey(name: 'alt_group') int? altGroup,@JsonKey(fromJson: _num) double kcal,@JsonKey(name: 'protein_g', fromJson: _num) double protein,@JsonKey(name: 'carbs_g', fromJson: _num) double carbs,@JsonKey(name: 'fat_g', fromJson: _num) double fat,@JsonKey(name: 'logged_at') DateTime? loggedAt
});




}
/// @nodoc
class __$MealLogCopyWithImpl<$Res>
    implements _$MealLogCopyWith<$Res> {
  __$MealLogCopyWithImpl(this._self, this._then);

  final _MealLog _self;
  final $Res Function(_MealLog) _then;

/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? memberId = null,Object? memberDietId = freezed,Object? day = freezed,Object? slot = null,Object? status = null,Object? altGroup = freezed,Object? kcal = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? loggedAt = freezed,}) {
  return _then(_MealLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,memberDietId: freezed == memberDietId ? _self.memberDietId : memberDietId // ignore: cast_nullable_to_non_nullable
as String?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,altGroup: freezed == altGroup ? _self.altGroup : altGroup // ignore: cast_nullable_to_non_nullable
as int?,kcal: null == kcal ? _self.kcal : kcal // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,loggedAt: freezed == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WaterLog {

@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day; int get glasses;
/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterLogCopyWith<WaterLog> get copyWith => _$WaterLogCopyWithImpl<WaterLog>(this as WaterLog, _$identity);

  /// Serializes this WaterLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WaterLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterLog&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.glasses, _this.glasses) || other.glasses == _this.glasses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WaterLog;
  return Object.hash(runtimeType,_this.day,_this.glasses);
}

@override
String toString() {
  final _this = this as WaterLog;
  return 'WaterLog(day: ${_this.day}, glasses: ${_this.glasses})';
}


}

/// @nodoc
abstract mixin class $WaterLogCopyWith<$Res>  {
  factory $WaterLogCopyWith(WaterLog value, $Res Function(WaterLog) _then) = _$WaterLogCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, int glasses
});




}
/// @nodoc
class _$WaterLogCopyWithImpl<$Res>
    implements $WaterLogCopyWith<$Res> {
  _$WaterLogCopyWithImpl(this._self, this._then);

  final WaterLog _self;
  final $Res Function(WaterLog) _then;

/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = freezed,Object? glasses = null,}) {
  return _then(WaterLog(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,glasses: null == glasses ? _self.glasses : glasses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterLog].
extension WaterLogPatterns on WaterLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterLog value)  $default,){
final _that = this;
switch (_that) {
case _WaterLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterLog value)?  $default,){
final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int glasses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
return $default(_that.day,_that.glasses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int glasses)  $default,) {final _that = this;
switch (_that) {
case _WaterLog():
return $default(_that.day,_that.glasses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int glasses)?  $default,) {final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
return $default(_that.day,_that.glasses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterLog implements WaterLog {
  const _WaterLog({@JsonKey(fromJson: _date, toJson: _dateOut) required this.day, this.glasses = 0});
  factory _WaterLog.fromJson(Map<String, dynamic> json) => _$WaterLogFromJson(json);

@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override@JsonKey() final  int glasses;

/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterLogCopyWith<_WaterLog> get copyWith => __$WaterLogCopyWithImpl<_WaterLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterLog&&(identical(other.day, day) || other.day == day)&&(identical(other.glasses, glasses) || other.glasses == glasses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,glasses);
}

@override
String toString() {
    return 'WaterLog(day: $day, glasses: $glasses)';
}


}

/// @nodoc
abstract mixin class _$WaterLogCopyWith<$Res> implements $WaterLogCopyWith<$Res> {
  factory _$WaterLogCopyWith(_WaterLog value, $Res Function(_WaterLog) _then) = __$WaterLogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, int glasses
});




}
/// @nodoc
class __$WaterLogCopyWithImpl<$Res>
    implements _$WaterLogCopyWith<$Res> {
  __$WaterLogCopyWithImpl(this._self, this._then);

  final _WaterLog _self;
  final $Res Function(_WaterLog) _then;

/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = freezed,Object? glasses = null,}) {
  return _then(_WaterLog(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,glasses: null == glasses ? _self.glasses : glasses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SupplementLog {

@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day; String get name;
/// Create a copy of SupplementLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplementLogCopyWith<SupplementLog> get copyWith => _$SupplementLogCopyWithImpl<SupplementLog>(this as SupplementLog, _$identity);

  /// Serializes this SupplementLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SupplementLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplementLog&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SupplementLog;
  return Object.hash(runtimeType,_this.day,_this.name);
}

@override
String toString() {
  final _this = this as SupplementLog;
  return 'SupplementLog(day: ${_this.day}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $SupplementLogCopyWith<$Res>  {
  factory $SupplementLogCopyWith(SupplementLog value, $Res Function(SupplementLog) _then) = _$SupplementLogCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, String name
});




}
/// @nodoc
class _$SupplementLogCopyWithImpl<$Res>
    implements $SupplementLogCopyWith<$Res> {
  _$SupplementLogCopyWithImpl(this._self, this._then);

  final SupplementLog _self;
  final $Res Function(SupplementLog) _then;

/// Create a copy of SupplementLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = freezed,Object? name = null,}) {
  return _then(SupplementLog(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SupplementLog].
extension SupplementLogPatterns on SupplementLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplementLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplementLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplementLog value)  $default,){
final _that = this;
switch (_that) {
case _SupplementLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplementLog value)?  $default,){
final _that = this;
switch (_that) {
case _SupplementLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplementLog() when $default != null:
return $default(_that.day,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  String name)  $default,) {final _that = this;
switch (_that) {
case _SupplementLog():
return $default(_that.day,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SupplementLog() when $default != null:
return $default(_that.day,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupplementLog implements SupplementLog {
  const _SupplementLog({@JsonKey(fromJson: _date, toJson: _dateOut) required this.day, required this.name});
  factory _SupplementLog.fromJson(Map<String, dynamic> json) => _$SupplementLogFromJson(json);

@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override final  String name;

/// Create a copy of SupplementLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplementLogCopyWith<_SupplementLog> get copyWith => __$SupplementLogCopyWithImpl<_SupplementLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplementLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplementLog&&(identical(other.day, day) || other.day == day)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,name);
}

@override
String toString() {
    return 'SupplementLog(day: $day, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SupplementLogCopyWith<$Res> implements $SupplementLogCopyWith<$Res> {
  factory _$SupplementLogCopyWith(_SupplementLog value, $Res Function(_SupplementLog) _then) = __$SupplementLogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, String name
});




}
/// @nodoc
class __$SupplementLogCopyWithImpl<$Res>
    implements _$SupplementLogCopyWith<$Res> {
  __$SupplementLogCopyWithImpl(this._self, this._then);

  final _SupplementLog _self;
  final $Res Function(_SupplementLog) _then;

/// Create a copy of SupplementLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = freezed,Object? name = null,}) {
  return _then(_SupplementLog(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DietLogs {

 List<MealLog> get meals; List<WaterLog> get water; List<SupplementLog> get supplements;
/// Create a copy of DietLogs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietLogsCopyWith<DietLogs> get copyWith => _$DietLogsCopyWithImpl<DietLogs>(this as DietLogs, _$identity);

  /// Serializes this DietLogs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DietLogs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietLogs&&const DeepCollectionEquality().equals(other.meals, _this.meals)&&const DeepCollectionEquality().equals(other.water, _this.water)&&const DeepCollectionEquality().equals(other.supplements, _this.supplements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DietLogs;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.meals),const DeepCollectionEquality().hash(_this.water),const DeepCollectionEquality().hash(_this.supplements));
}

@override
String toString() {
  final _this = this as DietLogs;
  return 'DietLogs(meals: ${_this.meals}, water: ${_this.water}, supplements: ${_this.supplements})';
}


}

/// @nodoc
abstract mixin class $DietLogsCopyWith<$Res>  {
  factory $DietLogsCopyWith(DietLogs value, $Res Function(DietLogs) _then) = _$DietLogsCopyWithImpl;
@useResult
$Res call({
 List<MealLog> meals, List<WaterLog> water, List<SupplementLog> supplements
});




}
/// @nodoc
class _$DietLogsCopyWithImpl<$Res>
    implements $DietLogsCopyWith<$Res> {
  _$DietLogsCopyWithImpl(this._self, this._then);

  final DietLogs _self;
  final $Res Function(DietLogs) _then;

/// Create a copy of DietLogs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meals = null,Object? water = null,Object? supplements = null,}) {
  return _then(DietLogs(
meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as List<MealLog>,water: null == water ? _self.water : water // ignore: cast_nullable_to_non_nullable
as List<WaterLog>,supplements: null == supplements ? _self.supplements : supplements // ignore: cast_nullable_to_non_nullable
as List<SupplementLog>,
  ));
}

}


/// Adds pattern-matching-related methods to [DietLogs].
extension DietLogsPatterns on DietLogs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietLogs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietLogs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietLogs value)  $default,){
final _that = this;
switch (_that) {
case _DietLogs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietLogs value)?  $default,){
final _that = this;
switch (_that) {
case _DietLogs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MealLog> meals,  List<WaterLog> water,  List<SupplementLog> supplements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietLogs() when $default != null:
return $default(_that.meals,_that.water,_that.supplements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MealLog> meals,  List<WaterLog> water,  List<SupplementLog> supplements)  $default,) {final _that = this;
switch (_that) {
case _DietLogs():
return $default(_that.meals,_that.water,_that.supplements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MealLog> meals,  List<WaterLog> water,  List<SupplementLog> supplements)?  $default,) {final _that = this;
switch (_that) {
case _DietLogs() when $default != null:
return $default(_that.meals,_that.water,_that.supplements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DietLogs extends DietLogs {
  const _DietLogs({ List<MealLog> meals = const <MealLog>[],  List<WaterLog> water = const <WaterLog>[],  List<SupplementLog> supplements = const <SupplementLog>[]}): _meals = meals,_water = water,_supplements = supplements,super._();
  factory _DietLogs.fromJson(Map<String, dynamic> json) => _$DietLogsFromJson(json);

 final  List<MealLog> _meals;
@override@JsonKey() List<MealLog> get meals {
  if (_meals is EqualUnmodifiableListView) return _meals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meals);
}

 final  List<WaterLog> _water;
@override@JsonKey() List<WaterLog> get water {
  if (_water is EqualUnmodifiableListView) return _water;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_water);
}

 final  List<SupplementLog> _supplements;
@override@JsonKey() List<SupplementLog> get supplements {
  if (_supplements is EqualUnmodifiableListView) return _supplements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supplements);
}


/// Create a copy of DietLogs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietLogsCopyWith<_DietLogs> get copyWith => __$DietLogsCopyWithImpl<_DietLogs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DietLogsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietLogs&&const DeepCollectionEquality().equals(other.meals, _meals)&&const DeepCollectionEquality().equals(other.water, _water)&&const DeepCollectionEquality().equals(other.supplements, _supplements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_meals),const DeepCollectionEquality().hash(_water),const DeepCollectionEquality().hash(_supplements));
}

@override
String toString() {
    return 'DietLogs(meals: $meals, water: $water, supplements: $supplements)';
}


}

/// @nodoc
abstract mixin class _$DietLogsCopyWith<$Res> implements $DietLogsCopyWith<$Res> {
  factory _$DietLogsCopyWith(_DietLogs value, $Res Function(_DietLogs) _then) = __$DietLogsCopyWithImpl;
@override @useResult
$Res call({
 List<MealLog> meals, List<WaterLog> water, List<SupplementLog> supplements
});




}
/// @nodoc
class __$DietLogsCopyWithImpl<$Res>
    implements _$DietLogsCopyWith<$Res> {
  __$DietLogsCopyWithImpl(this._self, this._then);

  final _DietLogs _self;
  final $Res Function(_DietLogs) _then;

/// Create a copy of DietLogs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meals = null,Object? water = null,Object? supplements = null,}) {
  return _then(_DietLogs(
meals: null == meals ? _self._meals : meals // ignore: cast_nullable_to_non_nullable
as List<MealLog>,water: null == water ? _self._water : water // ignore: cast_nullable_to_non_nullable
as List<WaterLog>,supplements: null == supplements ? _self._supplements : supplements // ignore: cast_nullable_to_non_nullable
as List<SupplementLog>,
  ));
}


}


/// @nodoc
mixin _$DietComment {

 String get id;@JsonKey(name: 'author_name') String get authorName; String get body;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of DietComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietCommentCopyWith<DietComment> get copyWith => _$DietCommentCopyWithImpl<DietComment>(this as DietComment, _$identity);

  /// Serializes this DietComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DietComment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietComment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DietComment;
  return Object.hash(runtimeType,_this.id,_this.authorName,_this.body,_this.createdAt);
}

@override
String toString() {
  final _this = this as DietComment;
  return 'DietComment(id: ${_this.id}, authorName: ${_this.authorName}, body: ${_this.body}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $DietCommentCopyWith<$Res>  {
  factory $DietCommentCopyWith(DietComment value, $Res Function(DietComment) _then) = _$DietCommentCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'author_name') String authorName, String body,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$DietCommentCopyWithImpl<$Res>
    implements $DietCommentCopyWith<$Res> {
  _$DietCommentCopyWithImpl(this._self, this._then);

  final DietComment _self;
  final $Res Function(DietComment) _then;

/// Create a copy of DietComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorName = null,Object? body = null,Object? createdAt = null,}) {
  return _then(DietComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DietComment].
extension DietCommentPatterns on DietComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietComment value)  $default,){
final _that = this;
switch (_that) {
case _DietComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietComment value)?  $default,){
final _that = this;
switch (_that) {
case _DietComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'author_name')  String authorName,  String body, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietComment() when $default != null:
return $default(_that.id,_that.authorName,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'author_name')  String authorName,  String body, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DietComment():
return $default(_that.id,_that.authorName,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'author_name')  String authorName,  String body, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DietComment() when $default != null:
return $default(_that.id,_that.authorName,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DietComment implements DietComment {
  const _DietComment({required this.id, @JsonKey(name: 'author_name') required this.authorName, required this.body, @JsonKey(name: 'created_at') required this.createdAt});
  factory _DietComment.fromJson(Map<String, dynamic> json) => _$DietCommentFromJson(json);

@override final  String id;
@override@JsonKey(name: 'author_name') final  String authorName;
@override final  String body;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of DietComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietCommentCopyWith<_DietComment> get copyWith => __$DietCommentCopyWithImpl<_DietComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DietCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietComment&&(identical(other.id, id) || other.id == id)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,authorName,body,createdAt);
}

@override
String toString() {
    return 'DietComment(id: $id, authorName: $authorName, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DietCommentCopyWith<$Res> implements $DietCommentCopyWith<$Res> {
  factory _$DietCommentCopyWith(_DietComment value, $Res Function(_DietComment) _then) = __$DietCommentCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'author_name') String authorName, String body,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$DietCommentCopyWithImpl<$Res>
    implements _$DietCommentCopyWith<$Res> {
  __$DietCommentCopyWithImpl(this._self, this._then);

  final _DietComment _self;
  final $Res Function(_DietComment) _then;

/// Create a copy of DietComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorName = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_DietComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DietFlags {

@JsonKey(name: 'member_id') String get memberId; String get name;@JsonKey(name: 'diet_pref') String? get dietPref;@JsonKey(name: 'food_allergies') List<String> get allergies;@JsonKey(name: 'foods_to_avoid') List<String> get avoid; String? get conditions;@JsonKey(name: 'has_conditions') bool get hasConditions;
/// Create a copy of DietFlags
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietFlagsCopyWith<DietFlags> get copyWith => _$DietFlagsCopyWithImpl<DietFlags>(this as DietFlags, _$identity);

  /// Serializes this DietFlags to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DietFlags;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietFlags&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.dietPref, _this.dietPref) || other.dietPref == _this.dietPref)&&const DeepCollectionEquality().equals(other.allergies, _this.allergies)&&const DeepCollectionEquality().equals(other.avoid, _this.avoid)&&(identical(other.conditions, _this.conditions) || other.conditions == _this.conditions)&&(identical(other.hasConditions, _this.hasConditions) || other.hasConditions == _this.hasConditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DietFlags;
  return Object.hash(runtimeType,_this.memberId,_this.name,_this.dietPref,const DeepCollectionEquality().hash(_this.allergies),const DeepCollectionEquality().hash(_this.avoid),_this.conditions,_this.hasConditions);
}

@override
String toString() {
  final _this = this as DietFlags;
  return 'DietFlags(memberId: ${_this.memberId}, name: ${_this.name}, dietPref: ${_this.dietPref}, allergies: ${_this.allergies}, avoid: ${_this.avoid}, conditions: ${_this.conditions}, hasConditions: ${_this.hasConditions})';
}


}

/// @nodoc
abstract mixin class $DietFlagsCopyWith<$Res>  {
  factory $DietFlagsCopyWith(DietFlags value, $Res Function(DietFlags) _then) = _$DietFlagsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'diet_pref') String? dietPref,@JsonKey(name: 'food_allergies') List<String> allergies,@JsonKey(name: 'foods_to_avoid') List<String> avoid, String? conditions,@JsonKey(name: 'has_conditions') bool hasConditions
});




}
/// @nodoc
class _$DietFlagsCopyWithImpl<$Res>
    implements $DietFlagsCopyWith<$Res> {
  _$DietFlagsCopyWithImpl(this._self, this._then);

  final DietFlags _self;
  final $Res Function(DietFlags) _then;

/// Create a copy of DietFlags
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? name = null,Object? dietPref = freezed,Object? allergies = null,Object? avoid = null,Object? conditions = freezed,Object? hasConditions = null,}) {
  return _then(DietFlags(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dietPref: freezed == dietPref ? _self.dietPref : dietPref // ignore: cast_nullable_to_non_nullable
as String?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,avoid: null == avoid ? _self.avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,hasConditions: null == hasConditions ? _self.hasConditions : hasConditions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DietFlags].
extension DietFlagsPatterns on DietFlags {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietFlags value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietFlags() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietFlags value)  $default,){
final _that = this;
switch (_that) {
case _DietFlags():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietFlags value)?  $default,){
final _that = this;
switch (_that) {
case _DietFlags() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'diet_pref')  String? dietPref, @JsonKey(name: 'food_allergies')  List<String> allergies, @JsonKey(name: 'foods_to_avoid')  List<String> avoid,  String? conditions, @JsonKey(name: 'has_conditions')  bool hasConditions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietFlags() when $default != null:
return $default(_that.memberId,_that.name,_that.dietPref,_that.allergies,_that.avoid,_that.conditions,_that.hasConditions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'diet_pref')  String? dietPref, @JsonKey(name: 'food_allergies')  List<String> allergies, @JsonKey(name: 'foods_to_avoid')  List<String> avoid,  String? conditions, @JsonKey(name: 'has_conditions')  bool hasConditions)  $default,) {final _that = this;
switch (_that) {
case _DietFlags():
return $default(_that.memberId,_that.name,_that.dietPref,_that.allergies,_that.avoid,_that.conditions,_that.hasConditions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'diet_pref')  String? dietPref, @JsonKey(name: 'food_allergies')  List<String> allergies, @JsonKey(name: 'foods_to_avoid')  List<String> avoid,  String? conditions, @JsonKey(name: 'has_conditions')  bool hasConditions)?  $default,) {final _that = this;
switch (_that) {
case _DietFlags() when $default != null:
return $default(_that.memberId,_that.name,_that.dietPref,_that.allergies,_that.avoid,_that.conditions,_that.hasConditions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DietFlags extends DietFlags {
  const _DietFlags({@JsonKey(name: 'member_id') required this.memberId, this.name = '', @JsonKey(name: 'diet_pref') this.dietPref, @JsonKey(name: 'food_allergies')  List<String> allergies = const <String>[], @JsonKey(name: 'foods_to_avoid')  List<String> avoid = const <String>[], this.conditions, @JsonKey(name: 'has_conditions') this.hasConditions = false}): _allergies = allergies,_avoid = avoid,super._();
  factory _DietFlags.fromJson(Map<String, dynamic> json) => _$DietFlagsFromJson(json);

@override@JsonKey(name: 'member_id') final  String memberId;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'diet_pref') final  String? dietPref;
 final  List<String> _allergies;
@override@JsonKey(name: 'food_allergies') List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

 final  List<String> _avoid;
@override@JsonKey(name: 'foods_to_avoid') List<String> get avoid {
  if (_avoid is EqualUnmodifiableListView) return _avoid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avoid);
}

@override final  String? conditions;
@override@JsonKey(name: 'has_conditions') final  bool hasConditions;

/// Create a copy of DietFlags
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietFlagsCopyWith<_DietFlags> get copyWith => __$DietFlagsCopyWithImpl<_DietFlags>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DietFlagsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietFlags&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.name, name) || other.name == name)&&(identical(other.dietPref, dietPref) || other.dietPref == dietPref)&&const DeepCollectionEquality().equals(other.allergies, _allergies)&&const DeepCollectionEquality().equals(other.avoid, _avoid)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.hasConditions, hasConditions) || other.hasConditions == hasConditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memberId,name,dietPref,const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_avoid),conditions,hasConditions);
}

@override
String toString() {
    return 'DietFlags(memberId: $memberId, name: $name, dietPref: $dietPref, allergies: $allergies, avoid: $avoid, conditions: $conditions, hasConditions: $hasConditions)';
}


}

/// @nodoc
abstract mixin class _$DietFlagsCopyWith<$Res> implements $DietFlagsCopyWith<$Res> {
  factory _$DietFlagsCopyWith(_DietFlags value, $Res Function(_DietFlags) _then) = __$DietFlagsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'diet_pref') String? dietPref,@JsonKey(name: 'food_allergies') List<String> allergies,@JsonKey(name: 'foods_to_avoid') List<String> avoid, String? conditions,@JsonKey(name: 'has_conditions') bool hasConditions
});




}
/// @nodoc
class __$DietFlagsCopyWithImpl<$Res>
    implements _$DietFlagsCopyWith<$Res> {
  __$DietFlagsCopyWithImpl(this._self, this._then);

  final _DietFlags _self;
  final $Res Function(_DietFlags) _then;

/// Create a copy of DietFlags
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? name = null,Object? dietPref = freezed,Object? allergies = null,Object? avoid = null,Object? conditions = freezed,Object? hasConditions = null,}) {
  return _then(_DietFlags(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dietPref: freezed == dietPref ? _self.dietPref : dietPref // ignore: cast_nullable_to_non_nullable
as String?,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,avoid: null == avoid ? _self._avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,hasConditions: null == hasConditions ? _self.hasConditions : hasConditions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DietRow {

@JsonKey(name: 'member_id') String get memberId; String get name;@JsonKey(name: 'member_code') String get memberCode;@JsonKey(name: 'photo_url') String? get photoPath;@JsonKey(name: 'trainer_id') String? get trainerId; String? get status;@JsonKey(name: 'diet_id') String? get dietId;@JsonKey(name: 'diet_name') String? get dietName;@JsonKey(name: 'diet_status') DietStatus? get dietStatus;@JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut) DateTime? get dietStart;@JsonKey(name: 'kcal_target') int? get kcalTarget;@JsonKey(name: 'meals_per_day') int get mealsPerDay;@JsonKey(name: 'adherence_7d', fromJson: _numOrNull) double? get adherence;@JsonKey(name: 'missed_7d') int get missed7d;@JsonKey(name: 'logged_today') int get loggedToday;@JsonKey(name: 'last_logged_at') DateTime? get lastLoggedAt;@JsonKey(name: 'has_conditions') bool get hasConditions;
/// Create a copy of DietRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietRowCopyWith<DietRow> get copyWith => _$DietRowCopyWithImpl<DietRow>(this as DietRow, _$identity);

  /// Serializes this DietRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DietRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietRow&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.memberCode, _this.memberCode) || other.memberCode == _this.memberCode)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.trainerId, _this.trainerId) || other.trainerId == _this.trainerId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.dietId, _this.dietId) || other.dietId == _this.dietId)&&(identical(other.dietName, _this.dietName) || other.dietName == _this.dietName)&&(identical(other.dietStatus, _this.dietStatus) || other.dietStatus == _this.dietStatus)&&(identical(other.dietStart, _this.dietStart) || other.dietStart == _this.dietStart)&&(identical(other.kcalTarget, _this.kcalTarget) || other.kcalTarget == _this.kcalTarget)&&(identical(other.mealsPerDay, _this.mealsPerDay) || other.mealsPerDay == _this.mealsPerDay)&&(identical(other.adherence, _this.adherence) || other.adherence == _this.adherence)&&(identical(other.missed7d, _this.missed7d) || other.missed7d == _this.missed7d)&&(identical(other.loggedToday, _this.loggedToday) || other.loggedToday == _this.loggedToday)&&(identical(other.lastLoggedAt, _this.lastLoggedAt) || other.lastLoggedAt == _this.lastLoggedAt)&&(identical(other.hasConditions, _this.hasConditions) || other.hasConditions == _this.hasConditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DietRow;
  return Object.hash(runtimeType,_this.memberId,_this.name,_this.memberCode,_this.photoPath,_this.trainerId,_this.status,_this.dietId,_this.dietName,_this.dietStatus,_this.dietStart,_this.kcalTarget,_this.mealsPerDay,_this.adherence,_this.missed7d,_this.loggedToday,_this.lastLoggedAt,_this.hasConditions);
}

@override
String toString() {
  final _this = this as DietRow;
  return 'DietRow(memberId: ${_this.memberId}, name: ${_this.name}, memberCode: ${_this.memberCode}, photoPath: ${_this.photoPath}, trainerId: ${_this.trainerId}, status: ${_this.status}, dietId: ${_this.dietId}, dietName: ${_this.dietName}, dietStatus: ${_this.dietStatus}, dietStart: ${_this.dietStart}, kcalTarget: ${_this.kcalTarget}, mealsPerDay: ${_this.mealsPerDay}, adherence: ${_this.adherence}, missed7d: ${_this.missed7d}, loggedToday: ${_this.loggedToday}, lastLoggedAt: ${_this.lastLoggedAt}, hasConditions: ${_this.hasConditions})';
}


}

/// @nodoc
abstract mixin class $DietRowCopyWith<$Res>  {
  factory $DietRowCopyWith(DietRow value, $Res Function(DietRow) _then) = _$DietRowCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(name: 'trainer_id') String? trainerId, String? status,@JsonKey(name: 'diet_id') String? dietId,@JsonKey(name: 'diet_name') String? dietName,@JsonKey(name: 'diet_status') DietStatus? dietStatus,@JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut) DateTime? dietStart,@JsonKey(name: 'kcal_target') int? kcalTarget,@JsonKey(name: 'meals_per_day') int mealsPerDay,@JsonKey(name: 'adherence_7d', fromJson: _numOrNull) double? adherence,@JsonKey(name: 'missed_7d') int missed7d,@JsonKey(name: 'logged_today') int loggedToday,@JsonKey(name: 'last_logged_at') DateTime? lastLoggedAt,@JsonKey(name: 'has_conditions') bool hasConditions
});




}
/// @nodoc
class _$DietRowCopyWithImpl<$Res>
    implements $DietRowCopyWith<$Res> {
  _$DietRowCopyWithImpl(this._self, this._then);

  final DietRow _self;
  final $Res Function(DietRow) _then;

/// Create a copy of DietRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? name = null,Object? memberCode = null,Object? photoPath = freezed,Object? trainerId = freezed,Object? status = freezed,Object? dietId = freezed,Object? dietName = freezed,Object? dietStatus = freezed,Object? dietStart = freezed,Object? kcalTarget = freezed,Object? mealsPerDay = null,Object? adherence = freezed,Object? missed7d = null,Object? loggedToday = null,Object? lastLoggedAt = freezed,Object? hasConditions = null,}) {
  return _then(DietRow(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,dietId: freezed == dietId ? _self.dietId : dietId // ignore: cast_nullable_to_non_nullable
as String?,dietName: freezed == dietName ? _self.dietName : dietName // ignore: cast_nullable_to_non_nullable
as String?,dietStatus: freezed == dietStatus ? _self.dietStatus : dietStatus // ignore: cast_nullable_to_non_nullable
as DietStatus?,dietStart: freezed == dietStart ? _self.dietStart : dietStart // ignore: cast_nullable_to_non_nullable
as DateTime?,kcalTarget: freezed == kcalTarget ? _self.kcalTarget : kcalTarget // ignore: cast_nullable_to_non_nullable
as int?,mealsPerDay: null == mealsPerDay ? _self.mealsPerDay : mealsPerDay // ignore: cast_nullable_to_non_nullable
as int,adherence: freezed == adherence ? _self.adherence : adherence // ignore: cast_nullable_to_non_nullable
as double?,missed7d: null == missed7d ? _self.missed7d : missed7d // ignore: cast_nullable_to_non_nullable
as int,loggedToday: null == loggedToday ? _self.loggedToday : loggedToday // ignore: cast_nullable_to_non_nullable
as int,lastLoggedAt: freezed == lastLoggedAt ? _self.lastLoggedAt : lastLoggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,hasConditions: null == hasConditions ? _self.hasConditions : hasConditions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DietRow].
extension DietRowPatterns on DietRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietRow value)  $default,){
final _that = this;
switch (_that) {
case _DietRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietRow value)?  $default,){
final _that = this;
switch (_that) {
case _DietRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(name: 'trainer_id')  String? trainerId,  String? status, @JsonKey(name: 'diet_id')  String? dietId, @JsonKey(name: 'diet_name')  String? dietName, @JsonKey(name: 'diet_status')  DietStatus? dietStatus, @JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut)  DateTime? dietStart, @JsonKey(name: 'kcal_target')  int? kcalTarget, @JsonKey(name: 'meals_per_day')  int mealsPerDay, @JsonKey(name: 'adherence_7d', fromJson: _numOrNull)  double? adherence, @JsonKey(name: 'missed_7d')  int missed7d, @JsonKey(name: 'logged_today')  int loggedToday, @JsonKey(name: 'last_logged_at')  DateTime? lastLoggedAt, @JsonKey(name: 'has_conditions')  bool hasConditions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietRow() when $default != null:
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.trainerId,_that.status,_that.dietId,_that.dietName,_that.dietStatus,_that.dietStart,_that.kcalTarget,_that.mealsPerDay,_that.adherence,_that.missed7d,_that.loggedToday,_that.lastLoggedAt,_that.hasConditions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(name: 'trainer_id')  String? trainerId,  String? status, @JsonKey(name: 'diet_id')  String? dietId, @JsonKey(name: 'diet_name')  String? dietName, @JsonKey(name: 'diet_status')  DietStatus? dietStatus, @JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut)  DateTime? dietStart, @JsonKey(name: 'kcal_target')  int? kcalTarget, @JsonKey(name: 'meals_per_day')  int mealsPerDay, @JsonKey(name: 'adherence_7d', fromJson: _numOrNull)  double? adherence, @JsonKey(name: 'missed_7d')  int missed7d, @JsonKey(name: 'logged_today')  int loggedToday, @JsonKey(name: 'last_logged_at')  DateTime? lastLoggedAt, @JsonKey(name: 'has_conditions')  bool hasConditions)  $default,) {final _that = this;
switch (_that) {
case _DietRow():
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.trainerId,_that.status,_that.dietId,_that.dietName,_that.dietStatus,_that.dietStart,_that.kcalTarget,_that.mealsPerDay,_that.adherence,_that.missed7d,_that.loggedToday,_that.lastLoggedAt,_that.hasConditions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'member_id')  String memberId,  String name, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'photo_url')  String? photoPath, @JsonKey(name: 'trainer_id')  String? trainerId,  String? status, @JsonKey(name: 'diet_id')  String? dietId, @JsonKey(name: 'diet_name')  String? dietName, @JsonKey(name: 'diet_status')  DietStatus? dietStatus, @JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut)  DateTime? dietStart, @JsonKey(name: 'kcal_target')  int? kcalTarget, @JsonKey(name: 'meals_per_day')  int mealsPerDay, @JsonKey(name: 'adherence_7d', fromJson: _numOrNull)  double? adherence, @JsonKey(name: 'missed_7d')  int missed7d, @JsonKey(name: 'logged_today')  int loggedToday, @JsonKey(name: 'last_logged_at')  DateTime? lastLoggedAt, @JsonKey(name: 'has_conditions')  bool hasConditions)?  $default,) {final _that = this;
switch (_that) {
case _DietRow() when $default != null:
return $default(_that.memberId,_that.name,_that.memberCode,_that.photoPath,_that.trainerId,_that.status,_that.dietId,_that.dietName,_that.dietStatus,_that.dietStart,_that.kcalTarget,_that.mealsPerDay,_that.adherence,_that.missed7d,_that.loggedToday,_that.lastLoggedAt,_that.hasConditions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DietRow implements DietRow {
  const _DietRow({@JsonKey(name: 'member_id') required this.memberId, required this.name, @JsonKey(name: 'member_code') required this.memberCode, @JsonKey(name: 'photo_url') this.photoPath, @JsonKey(name: 'trainer_id') this.trainerId, this.status, @JsonKey(name: 'diet_id') this.dietId, @JsonKey(name: 'diet_name') this.dietName, @JsonKey(name: 'diet_status') this.dietStatus, @JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut) this.dietStart, @JsonKey(name: 'kcal_target') this.kcalTarget, @JsonKey(name: 'meals_per_day') this.mealsPerDay = 0, @JsonKey(name: 'adherence_7d', fromJson: _numOrNull) this.adherence, @JsonKey(name: 'missed_7d') this.missed7d = 0, @JsonKey(name: 'logged_today') this.loggedToday = 0, @JsonKey(name: 'last_logged_at') this.lastLoggedAt, @JsonKey(name: 'has_conditions') this.hasConditions = false});
  factory _DietRow.fromJson(Map<String, dynamic> json) => _$DietRowFromJson(json);

@override@JsonKey(name: 'member_id') final  String memberId;
@override final  String name;
@override@JsonKey(name: 'member_code') final  String memberCode;
@override@JsonKey(name: 'photo_url') final  String? photoPath;
@override@JsonKey(name: 'trainer_id') final  String? trainerId;
@override final  String? status;
@override@JsonKey(name: 'diet_id') final  String? dietId;
@override@JsonKey(name: 'diet_name') final  String? dietName;
@override@JsonKey(name: 'diet_status') final  DietStatus? dietStatus;
@override@JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut) final  DateTime? dietStart;
@override@JsonKey(name: 'kcal_target') final  int? kcalTarget;
@override@JsonKey(name: 'meals_per_day') final  int mealsPerDay;
@override@JsonKey(name: 'adherence_7d', fromJson: _numOrNull) final  double? adherence;
@override@JsonKey(name: 'missed_7d') final  int missed7d;
@override@JsonKey(name: 'logged_today') final  int loggedToday;
@override@JsonKey(name: 'last_logged_at') final  DateTime? lastLoggedAt;
@override@JsonKey(name: 'has_conditions') final  bool hasConditions;

/// Create a copy of DietRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietRowCopyWith<_DietRow> get copyWith => __$DietRowCopyWithImpl<_DietRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DietRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietRow&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.name, name) || other.name == name)&&(identical(other.memberCode, memberCode) || other.memberCode == memberCode)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.dietId, dietId) || other.dietId == dietId)&&(identical(other.dietName, dietName) || other.dietName == dietName)&&(identical(other.dietStatus, dietStatus) || other.dietStatus == dietStatus)&&(identical(other.dietStart, dietStart) || other.dietStart == dietStart)&&(identical(other.kcalTarget, kcalTarget) || other.kcalTarget == kcalTarget)&&(identical(other.mealsPerDay, mealsPerDay) || other.mealsPerDay == mealsPerDay)&&(identical(other.adherence, adherence) || other.adherence == adherence)&&(identical(other.missed7d, missed7d) || other.missed7d == missed7d)&&(identical(other.loggedToday, loggedToday) || other.loggedToday == loggedToday)&&(identical(other.lastLoggedAt, lastLoggedAt) || other.lastLoggedAt == lastLoggedAt)&&(identical(other.hasConditions, hasConditions) || other.hasConditions == hasConditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,memberId,name,memberCode,photoPath,trainerId,status,dietId,dietName,dietStatus,dietStart,kcalTarget,mealsPerDay,adherence,missed7d,loggedToday,lastLoggedAt,hasConditions);
}

@override
String toString() {
    return 'DietRow(memberId: $memberId, name: $name, memberCode: $memberCode, photoPath: $photoPath, trainerId: $trainerId, status: $status, dietId: $dietId, dietName: $dietName, dietStatus: $dietStatus, dietStart: $dietStart, kcalTarget: $kcalTarget, mealsPerDay: $mealsPerDay, adherence: $adherence, missed7d: $missed7d, loggedToday: $loggedToday, lastLoggedAt: $lastLoggedAt, hasConditions: $hasConditions)';
}


}

/// @nodoc
abstract mixin class _$DietRowCopyWith<$Res> implements $DietRowCopyWith<$Res> {
  factory _$DietRowCopyWith(_DietRow value, $Res Function(_DietRow) _then) = __$DietRowCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'member_id') String memberId, String name,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'photo_url') String? photoPath,@JsonKey(name: 'trainer_id') String? trainerId, String? status,@JsonKey(name: 'diet_id') String? dietId,@JsonKey(name: 'diet_name') String? dietName,@JsonKey(name: 'diet_status') DietStatus? dietStatus,@JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut) DateTime? dietStart,@JsonKey(name: 'kcal_target') int? kcalTarget,@JsonKey(name: 'meals_per_day') int mealsPerDay,@JsonKey(name: 'adherence_7d', fromJson: _numOrNull) double? adherence,@JsonKey(name: 'missed_7d') int missed7d,@JsonKey(name: 'logged_today') int loggedToday,@JsonKey(name: 'last_logged_at') DateTime? lastLoggedAt,@JsonKey(name: 'has_conditions') bool hasConditions
});




}
/// @nodoc
class __$DietRowCopyWithImpl<$Res>
    implements _$DietRowCopyWith<$Res> {
  __$DietRowCopyWithImpl(this._self, this._then);

  final _DietRow _self;
  final $Res Function(_DietRow) _then;

/// Create a copy of DietRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? name = null,Object? memberCode = null,Object? photoPath = freezed,Object? trainerId = freezed,Object? status = freezed,Object? dietId = freezed,Object? dietName = freezed,Object? dietStatus = freezed,Object? dietStart = freezed,Object? kcalTarget = freezed,Object? mealsPerDay = null,Object? adherence = freezed,Object? missed7d = null,Object? loggedToday = null,Object? lastLoggedAt = freezed,Object? hasConditions = null,}) {
  return _then(_DietRow(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,dietId: freezed == dietId ? _self.dietId : dietId // ignore: cast_nullable_to_non_nullable
as String?,dietName: freezed == dietName ? _self.dietName : dietName // ignore: cast_nullable_to_non_nullable
as String?,dietStatus: freezed == dietStatus ? _self.dietStatus : dietStatus // ignore: cast_nullable_to_non_nullable
as DietStatus?,dietStart: freezed == dietStart ? _self.dietStart : dietStart // ignore: cast_nullable_to_non_nullable
as DateTime?,kcalTarget: freezed == kcalTarget ? _self.kcalTarget : kcalTarget // ignore: cast_nullable_to_non_nullable
as int?,mealsPerDay: null == mealsPerDay ? _self.mealsPerDay : mealsPerDay // ignore: cast_nullable_to_non_nullable
as int,adherence: freezed == adherence ? _self.adherence : adherence // ignore: cast_nullable_to_non_nullable
as double?,missed7d: null == missed7d ? _self.missed7d : missed7d // ignore: cast_nullable_to_non_nullable
as int,loggedToday: null == loggedToday ? _self.loggedToday : loggedToday // ignore: cast_nullable_to_non_nullable
as int,lastLoggedAt: freezed == lastLoggedAt ? _self.lastLoggedAt : lastLoggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,hasConditions: null == hasConditions ? _self.hasConditions : hasConditions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
