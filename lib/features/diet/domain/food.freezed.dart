// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroceryPart {

 String get item;@JsonKey(fromJson: _num) double get qty; String get unit;
/// Create a copy of GroceryPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroceryPartCopyWith<GroceryPart> get copyWith => _$GroceryPartCopyWithImpl<GroceryPart>(this as GroceryPart, _$identity);

  /// Serializes this GroceryPart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GroceryPart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroceryPart&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unit, _this.unit) || other.unit == _this.unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GroceryPart;
  return Object.hash(runtimeType,_this.item,_this.qty,_this.unit);
}

@override
String toString() {
  final _this = this as GroceryPart;
  return 'GroceryPart(item: ${_this.item}, qty: ${_this.qty}, unit: ${_this.unit})';
}


}

/// @nodoc
abstract mixin class $GroceryPartCopyWith<$Res>  {
  factory $GroceryPartCopyWith(GroceryPart value, $Res Function(GroceryPart) _then) = _$GroceryPartCopyWithImpl;
@useResult
$Res call({
 String item,@JsonKey(fromJson: _num) double qty, String unit
});




}
/// @nodoc
class _$GroceryPartCopyWithImpl<$Res>
    implements $GroceryPartCopyWith<$Res> {
  _$GroceryPartCopyWithImpl(this._self, this._then);

  final GroceryPart _self;
  final $Res Function(GroceryPart) _then;

/// Create a copy of GroceryPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,Object? qty = null,Object? unit = null,}) {
  return _then(GroceryPart(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroceryPart].
extension GroceryPartPatterns on GroceryPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroceryPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroceryPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroceryPart value)  $default,){
final _that = this;
switch (_that) {
case _GroceryPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroceryPart value)?  $default,){
final _that = this;
switch (_that) {
case _GroceryPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String item, @JsonKey(fromJson: _num)  double qty,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroceryPart() when $default != null:
return $default(_that.item,_that.qty,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String item, @JsonKey(fromJson: _num)  double qty,  String unit)  $default,) {final _that = this;
switch (_that) {
case _GroceryPart():
return $default(_that.item,_that.qty,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String item, @JsonKey(fromJson: _num)  double qty,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _GroceryPart() when $default != null:
return $default(_that.item,_that.qty,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroceryPart implements GroceryPart {
  const _GroceryPart({required this.item, @JsonKey(fromJson: _num) required this.qty, this.unit = 'g'});
  factory _GroceryPart.fromJson(Map<String, dynamic> json) => _$GroceryPartFromJson(json);

@override final  String item;
@override@JsonKey(fromJson: _num) final  double qty;
@override@JsonKey() final  String unit;

/// Create a copy of GroceryPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroceryPartCopyWith<_GroceryPart> get copyWith => __$GroceryPartCopyWithImpl<_GroceryPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroceryPartToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroceryPart&&(identical(other.item, item) || other.item == item)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,item,qty,unit);
}

@override
String toString() {
    return 'GroceryPart(item: $item, qty: $qty, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$GroceryPartCopyWith<$Res> implements $GroceryPartCopyWith<$Res> {
  factory _$GroceryPartCopyWith(_GroceryPart value, $Res Function(_GroceryPart) _then) = __$GroceryPartCopyWithImpl;
@override @useResult
$Res call({
 String item,@JsonKey(fromJson: _num) double qty, String unit
});




}
/// @nodoc
class __$GroceryPartCopyWithImpl<$Res>
    implements _$GroceryPartCopyWith<$Res> {
  __$GroceryPartCopyWithImpl(this._self, this._then);

  final _GroceryPart _self;
  final $Res Function(_GroceryPart) _then;

/// Create a copy of GroceryPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,Object? qty = null,Object? unit = null,}) {
  return _then(_GroceryPart(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Food {

 String get id;@JsonKey(name: 'seed_key') String? get seedKey; String get name;@JsonKey(name: 'local_name') String? get localName; String get category;@JsonKey(name: 'serving_unit') String get servingUnit;@JsonKey(name: 'serving_g', fromJson: _num) double get servingG;@JsonKey(name: 'qty_step', fromJson: _num) double get qtyStep;@JsonKey(fromJson: _num) double get kcal;@JsonKey(name: 'protein_g', fromJson: _num) double get protein;@JsonKey(name: 'carbs_g', fromJson: _num) double get carbs;@JsonKey(name: 'fat_g', fromJson: _num) double get fat;@JsonKey(name: 'fibre_g', fromJson: _num) double get fibre;@JsonKey(name: 'veg_type') String get vegType;@JsonKey(name: 'jain_ok') bool get jainOk; List<String> get allergens; List<GroceryPart> get grocery; String get source;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'reviewed_at') DateTime? get reviewedAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'archived_at') DateTime? get archivedAt;
/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCopyWith<Food> get copyWith => _$FoodCopyWithImpl<Food>(this as Food, _$identity);

  /// Serializes this Food to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Food;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Food&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.seedKey, _this.seedKey) || other.seedKey == _this.seedKey)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.localName, _this.localName) || other.localName == _this.localName)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.servingUnit, _this.servingUnit) || other.servingUnit == _this.servingUnit)&&(identical(other.servingG, _this.servingG) || other.servingG == _this.servingG)&&(identical(other.qtyStep, _this.qtyStep) || other.qtyStep == _this.qtyStep)&&(identical(other.kcal, _this.kcal) || other.kcal == _this.kcal)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carbs, _this.carbs) || other.carbs == _this.carbs)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&(identical(other.fibre, _this.fibre) || other.fibre == _this.fibre)&&(identical(other.vegType, _this.vegType) || other.vegType == _this.vegType)&&(identical(other.jainOk, _this.jainOk) || other.jainOk == _this.jainOk)&&const DeepCollectionEquality().equals(other.allergens, _this.allergens)&&const DeepCollectionEquality().equals(other.grocery, _this.grocery)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.reviewedAt, _this.reviewedAt) || other.reviewedAt == _this.reviewedAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Food;
  return Object.hashAll([runtimeType,_this.id,_this.seedKey,_this.name,_this.localName,_this.category,_this.servingUnit,_this.servingG,_this.qtyStep,_this.kcal,_this.protein,_this.carbs,_this.fat,_this.fibre,_this.vegType,_this.jainOk,const DeepCollectionEquality().hash(_this.allergens),const DeepCollectionEquality().hash(_this.grocery),_this.source,_this.createdBy,_this.reviewedAt,_this.updatedAt,_this.archivedAt]);
}

@override
String toString() {
  final _this = this as Food;
  return 'Food(id: ${_this.id}, seedKey: ${_this.seedKey}, name: ${_this.name}, localName: ${_this.localName}, category: ${_this.category}, servingUnit: ${_this.servingUnit}, servingG: ${_this.servingG}, qtyStep: ${_this.qtyStep}, kcal: ${_this.kcal}, protein: ${_this.protein}, carbs: ${_this.carbs}, fat: ${_this.fat}, fibre: ${_this.fibre}, vegType: ${_this.vegType}, jainOk: ${_this.jainOk}, allergens: ${_this.allergens}, grocery: ${_this.grocery}, source: ${_this.source}, createdBy: ${_this.createdBy}, reviewedAt: ${_this.reviewedAt}, updatedAt: ${_this.updatedAt}, archivedAt: ${_this.archivedAt})';
}


}

/// @nodoc
abstract mixin class $FoodCopyWith<$Res>  {
  factory $FoodCopyWith(Food value, $Res Function(Food) _then) = _$FoodCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'seed_key') String? seedKey, String name,@JsonKey(name: 'local_name') String? localName, String category,@JsonKey(name: 'serving_unit') String servingUnit,@JsonKey(name: 'serving_g', fromJson: _num) double servingG,@JsonKey(name: 'qty_step', fromJson: _num) double qtyStep,@JsonKey(fromJson: _num) double kcal,@JsonKey(name: 'protein_g', fromJson: _num) double protein,@JsonKey(name: 'carbs_g', fromJson: _num) double carbs,@JsonKey(name: 'fat_g', fromJson: _num) double fat,@JsonKey(name: 'fibre_g', fromJson: _num) double fibre,@JsonKey(name: 'veg_type') String vegType,@JsonKey(name: 'jain_ok') bool jainOk, List<String> allergens, List<GroceryPart> grocery, String source,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'archived_at') DateTime? archivedAt
});




}
/// @nodoc
class _$FoodCopyWithImpl<$Res>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._self, this._then);

  final Food _self;
  final $Res Function(Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seedKey = freezed,Object? name = null,Object? localName = freezed,Object? category = null,Object? servingUnit = null,Object? servingG = null,Object? qtyStep = null,Object? kcal = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? fibre = null,Object? vegType = null,Object? jainOk = null,Object? allergens = null,Object? grocery = null,Object? source = null,Object? createdBy = freezed,Object? reviewedAt = freezed,Object? updatedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(Food(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seedKey: freezed == seedKey ? _self.seedKey : seedKey // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,localName: freezed == localName ? _self.localName : localName // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,servingUnit: null == servingUnit ? _self.servingUnit : servingUnit // ignore: cast_nullable_to_non_nullable
as String,servingG: null == servingG ? _self.servingG : servingG // ignore: cast_nullable_to_non_nullable
as double,qtyStep: null == qtyStep ? _self.qtyStep : qtyStep // ignore: cast_nullable_to_non_nullable
as double,kcal: null == kcal ? _self.kcal : kcal // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,fibre: null == fibre ? _self.fibre : fibre // ignore: cast_nullable_to_non_nullable
as double,vegType: null == vegType ? _self.vegType : vegType // ignore: cast_nullable_to_non_nullable
as String,jainOk: null == jainOk ? _self.jainOk : jainOk // ignore: cast_nullable_to_non_nullable
as bool,allergens: null == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>,grocery: null == grocery ? _self.grocery : grocery // ignore: cast_nullable_to_non_nullable
as List<GroceryPart>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Food].
extension FoodPatterns on Food {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Food value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Food() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Food value)  $default,){
final _that = this;
switch (_that) {
case _Food():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Food value)?  $default,){
final _that = this;
switch (_that) {
case _Food() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'seed_key')  String? seedKey,  String name, @JsonKey(name: 'local_name')  String? localName,  String category, @JsonKey(name: 'serving_unit')  String servingUnit, @JsonKey(name: 'serving_g', fromJson: _num)  double servingG, @JsonKey(name: 'qty_step', fromJson: _num)  double qtyStep, @JsonKey(fromJson: _num)  double kcal, @JsonKey(name: 'protein_g', fromJson: _num)  double protein, @JsonKey(name: 'carbs_g', fromJson: _num)  double carbs, @JsonKey(name: 'fat_g', fromJson: _num)  double fat, @JsonKey(name: 'fibre_g', fromJson: _num)  double fibre, @JsonKey(name: 'veg_type')  String vegType, @JsonKey(name: 'jain_ok')  bool jainOk,  List<String> allergens,  List<GroceryPart> grocery,  String source, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'archived_at')  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.seedKey,_that.name,_that.localName,_that.category,_that.servingUnit,_that.servingG,_that.qtyStep,_that.kcal,_that.protein,_that.carbs,_that.fat,_that.fibre,_that.vegType,_that.jainOk,_that.allergens,_that.grocery,_that.source,_that.createdBy,_that.reviewedAt,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'seed_key')  String? seedKey,  String name, @JsonKey(name: 'local_name')  String? localName,  String category, @JsonKey(name: 'serving_unit')  String servingUnit, @JsonKey(name: 'serving_g', fromJson: _num)  double servingG, @JsonKey(name: 'qty_step', fromJson: _num)  double qtyStep, @JsonKey(fromJson: _num)  double kcal, @JsonKey(name: 'protein_g', fromJson: _num)  double protein, @JsonKey(name: 'carbs_g', fromJson: _num)  double carbs, @JsonKey(name: 'fat_g', fromJson: _num)  double fat, @JsonKey(name: 'fibre_g', fromJson: _num)  double fibre, @JsonKey(name: 'veg_type')  String vegType, @JsonKey(name: 'jain_ok')  bool jainOk,  List<String> allergens,  List<GroceryPart> grocery,  String source, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'archived_at')  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Food():
return $default(_that.id,_that.seedKey,_that.name,_that.localName,_that.category,_that.servingUnit,_that.servingG,_that.qtyStep,_that.kcal,_that.protein,_that.carbs,_that.fat,_that.fibre,_that.vegType,_that.jainOk,_that.allergens,_that.grocery,_that.source,_that.createdBy,_that.reviewedAt,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'seed_key')  String? seedKey,  String name, @JsonKey(name: 'local_name')  String? localName,  String category, @JsonKey(name: 'serving_unit')  String servingUnit, @JsonKey(name: 'serving_g', fromJson: _num)  double servingG, @JsonKey(name: 'qty_step', fromJson: _num)  double qtyStep, @JsonKey(fromJson: _num)  double kcal, @JsonKey(name: 'protein_g', fromJson: _num)  double protein, @JsonKey(name: 'carbs_g', fromJson: _num)  double carbs, @JsonKey(name: 'fat_g', fromJson: _num)  double fat, @JsonKey(name: 'fibre_g', fromJson: _num)  double fibre, @JsonKey(name: 'veg_type')  String vegType, @JsonKey(name: 'jain_ok')  bool jainOk,  List<String> allergens,  List<GroceryPart> grocery,  String source, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'archived_at')  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.seedKey,_that.name,_that.localName,_that.category,_that.servingUnit,_that.servingG,_that.qtyStep,_that.kcal,_that.protein,_that.carbs,_that.fat,_that.fibre,_that.vegType,_that.jainOk,_that.allergens,_that.grocery,_that.source,_that.createdBy,_that.reviewedAt,_that.updatedAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Food extends Food {
  const _Food({required this.id, @JsonKey(name: 'seed_key') this.seedKey, required this.name, @JsonKey(name: 'local_name') this.localName, required this.category, @JsonKey(name: 'serving_unit') required this.servingUnit, @JsonKey(name: 'serving_g', fromJson: _num) required this.servingG, @JsonKey(name: 'qty_step', fromJson: _num) this.qtyStep = 0.5, @JsonKey(fromJson: _num) required this.kcal, @JsonKey(name: 'protein_g', fromJson: _num) this.protein = 0, @JsonKey(name: 'carbs_g', fromJson: _num) this.carbs = 0, @JsonKey(name: 'fat_g', fromJson: _num) this.fat = 0, @JsonKey(name: 'fibre_g', fromJson: _num) this.fibre = 0, @JsonKey(name: 'veg_type') required this.vegType, @JsonKey(name: 'jain_ok') this.jainOk = false,  List<String> allergens = const <String>[],  List<GroceryPart> grocery = const <GroceryPart>[], this.source = 'custom', @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'reviewed_at') this.reviewedAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'archived_at') this.archivedAt}): _allergens = allergens,_grocery = grocery,super._();
  factory _Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

@override final  String id;
@override@JsonKey(name: 'seed_key') final  String? seedKey;
@override final  String name;
@override@JsonKey(name: 'local_name') final  String? localName;
@override final  String category;
@override@JsonKey(name: 'serving_unit') final  String servingUnit;
@override@JsonKey(name: 'serving_g', fromJson: _num) final  double servingG;
@override@JsonKey(name: 'qty_step', fromJson: _num) final  double qtyStep;
@override@JsonKey(fromJson: _num) final  double kcal;
@override@JsonKey(name: 'protein_g', fromJson: _num) final  double protein;
@override@JsonKey(name: 'carbs_g', fromJson: _num) final  double carbs;
@override@JsonKey(name: 'fat_g', fromJson: _num) final  double fat;
@override@JsonKey(name: 'fibre_g', fromJson: _num) final  double fibre;
@override@JsonKey(name: 'veg_type') final  String vegType;
@override@JsonKey(name: 'jain_ok') final  bool jainOk;
 final  List<String> _allergens;
@override@JsonKey() List<String> get allergens {
  if (_allergens is EqualUnmodifiableListView) return _allergens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergens);
}

 final  List<GroceryPart> _grocery;
@override@JsonKey() List<GroceryPart> get grocery {
  if (_grocery is EqualUnmodifiableListView) return _grocery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grocery);
}

@override@JsonKey() final  String source;
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'reviewed_at') final  DateTime? reviewedAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'archived_at') final  DateTime? archivedAt;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCopyWith<_Food> get copyWith => __$FoodCopyWithImpl<_Food>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Food&&(identical(other.id, id) || other.id == id)&&(identical(other.seedKey, seedKey) || other.seedKey == seedKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.localName, localName) || other.localName == localName)&&(identical(other.category, category) || other.category == category)&&(identical(other.servingUnit, servingUnit) || other.servingUnit == servingUnit)&&(identical(other.servingG, servingG) || other.servingG == servingG)&&(identical(other.qtyStep, qtyStep) || other.qtyStep == qtyStep)&&(identical(other.kcal, kcal) || other.kcal == kcal)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.fibre, fibre) || other.fibre == fibre)&&(identical(other.vegType, vegType) || other.vegType == vegType)&&(identical(other.jainOk, jainOk) || other.jainOk == jainOk)&&const DeepCollectionEquality().equals(other.allergens, _allergens)&&const DeepCollectionEquality().equals(other.grocery, _grocery)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,seedKey,name,localName,category,servingUnit,servingG,qtyStep,kcal,protein,carbs,fat,fibre,vegType,jainOk,const DeepCollectionEquality().hash(_allergens),const DeepCollectionEquality().hash(_grocery),source,createdBy,reviewedAt,updatedAt,archivedAt]);
}

@override
String toString() {
    return 'Food(id: $id, seedKey: $seedKey, name: $name, localName: $localName, category: $category, servingUnit: $servingUnit, servingG: $servingG, qtyStep: $qtyStep, kcal: $kcal, protein: $protein, carbs: $carbs, fat: $fat, fibre: $fibre, vegType: $vegType, jainOk: $jainOk, allergens: $allergens, grocery: $grocery, source: $source, createdBy: $createdBy, reviewedAt: $reviewedAt, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$FoodCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$FoodCopyWith(_Food value, $Res Function(_Food) _then) = __$FoodCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'seed_key') String? seedKey, String name,@JsonKey(name: 'local_name') String? localName, String category,@JsonKey(name: 'serving_unit') String servingUnit,@JsonKey(name: 'serving_g', fromJson: _num) double servingG,@JsonKey(name: 'qty_step', fromJson: _num) double qtyStep,@JsonKey(fromJson: _num) double kcal,@JsonKey(name: 'protein_g', fromJson: _num) double protein,@JsonKey(name: 'carbs_g', fromJson: _num) double carbs,@JsonKey(name: 'fat_g', fromJson: _num) double fat,@JsonKey(name: 'fibre_g', fromJson: _num) double fibre,@JsonKey(name: 'veg_type') String vegType,@JsonKey(name: 'jain_ok') bool jainOk, List<String> allergens, List<GroceryPart> grocery, String source,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'archived_at') DateTime? archivedAt
});




}
/// @nodoc
class __$FoodCopyWithImpl<$Res>
    implements _$FoodCopyWith<$Res> {
  __$FoodCopyWithImpl(this._self, this._then);

  final _Food _self;
  final $Res Function(_Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seedKey = freezed,Object? name = null,Object? localName = freezed,Object? category = null,Object? servingUnit = null,Object? servingG = null,Object? qtyStep = null,Object? kcal = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? fibre = null,Object? vegType = null,Object? jainOk = null,Object? allergens = null,Object? grocery = null,Object? source = null,Object? createdBy = freezed,Object? reviewedAt = freezed,Object? updatedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(_Food(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seedKey: freezed == seedKey ? _self.seedKey : seedKey // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,localName: freezed == localName ? _self.localName : localName // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,servingUnit: null == servingUnit ? _self.servingUnit : servingUnit // ignore: cast_nullable_to_non_nullable
as String,servingG: null == servingG ? _self.servingG : servingG // ignore: cast_nullable_to_non_nullable
as double,qtyStep: null == qtyStep ? _self.qtyStep : qtyStep // ignore: cast_nullable_to_non_nullable
as double,kcal: null == kcal ? _self.kcal : kcal // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,fibre: null == fibre ? _self.fibre : fibre // ignore: cast_nullable_to_non_nullable
as double,vegType: null == vegType ? _self.vegType : vegType // ignore: cast_nullable_to_non_nullable
as String,jainOk: null == jainOk ? _self.jainOk : jainOk // ignore: cast_nullable_to_non_nullable
as bool,allergens: null == allergens ? _self._allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>,grocery: null == grocery ? _self._grocery : grocery // ignore: cast_nullable_to_non_nullable
as List<GroceryPart>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
