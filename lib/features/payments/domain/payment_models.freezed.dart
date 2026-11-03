// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceItem {

 String get id; int get position; String get kind; String get description; int get qty;@JsonKey(name: 'unit_paise') int get unitPaise;@JsonKey(name: 'gross_paise') int get grossPaise;@JsonKey(name: 'discount_paise') int get discountPaise;@JsonKey(name: 'net_paise') int get netPaise;@JsonKey(name: 'gst_rate') num get gstRate;@JsonKey(name: 'taxable_paise') int get taxablePaise;@JsonKey(name: 'gst_paise') int get gstPaise;
/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceItemCopyWith<InvoiceItem> get copyWith => _$InvoiceItemCopyWithImpl<InvoiceItem>(this as InvoiceItem, _$identity);

  /// Serializes this InvoiceItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InvoiceItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.qty, _this.qty) || other.qty == _this.qty)&&(identical(other.unitPaise, _this.unitPaise) || other.unitPaise == _this.unitPaise)&&(identical(other.grossPaise, _this.grossPaise) || other.grossPaise == _this.grossPaise)&&(identical(other.discountPaise, _this.discountPaise) || other.discountPaise == _this.discountPaise)&&(identical(other.netPaise, _this.netPaise) || other.netPaise == _this.netPaise)&&(identical(other.gstRate, _this.gstRate) || other.gstRate == _this.gstRate)&&(identical(other.taxablePaise, _this.taxablePaise) || other.taxablePaise == _this.taxablePaise)&&(identical(other.gstPaise, _this.gstPaise) || other.gstPaise == _this.gstPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InvoiceItem;
  return Object.hash(runtimeType,_this.id,_this.position,_this.kind,_this.description,_this.qty,_this.unitPaise,_this.grossPaise,_this.discountPaise,_this.netPaise,_this.gstRate,_this.taxablePaise,_this.gstPaise);
}

@override
String toString() {
  final _this = this as InvoiceItem;
  return 'InvoiceItem(id: ${_this.id}, position: ${_this.position}, kind: ${_this.kind}, description: ${_this.description}, qty: ${_this.qty}, unitPaise: ${_this.unitPaise}, grossPaise: ${_this.grossPaise}, discountPaise: ${_this.discountPaise}, netPaise: ${_this.netPaise}, gstRate: ${_this.gstRate}, taxablePaise: ${_this.taxablePaise}, gstPaise: ${_this.gstPaise})';
}


}

/// @nodoc
abstract mixin class $InvoiceItemCopyWith<$Res>  {
  factory $InvoiceItemCopyWith(InvoiceItem value, $Res Function(InvoiceItem) _then) = _$InvoiceItemCopyWithImpl;
@useResult
$Res call({
 String id, int position, String kind, String description, int qty,@JsonKey(name: 'unit_paise') int unitPaise,@JsonKey(name: 'gross_paise') int grossPaise,@JsonKey(name: 'discount_paise') int discountPaise,@JsonKey(name: 'net_paise') int netPaise,@JsonKey(name: 'gst_rate') num gstRate,@JsonKey(name: 'taxable_paise') int taxablePaise,@JsonKey(name: 'gst_paise') int gstPaise
});




}
/// @nodoc
class _$InvoiceItemCopyWithImpl<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  _$InvoiceItemCopyWithImpl(this._self, this._then);

  final InvoiceItem _self;
  final $Res Function(InvoiceItem) _then;

/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? position = null,Object? kind = null,Object? description = null,Object? qty = null,Object? unitPaise = null,Object? grossPaise = null,Object? discountPaise = null,Object? netPaise = null,Object? gstRate = null,Object? taxablePaise = null,Object? gstPaise = null,}) {
  return _then(InvoiceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,unitPaise: null == unitPaise ? _self.unitPaise : unitPaise // ignore: cast_nullable_to_non_nullable
as int,grossPaise: null == grossPaise ? _self.grossPaise : grossPaise // ignore: cast_nullable_to_non_nullable
as int,discountPaise: null == discountPaise ? _self.discountPaise : discountPaise // ignore: cast_nullable_to_non_nullable
as int,netPaise: null == netPaise ? _self.netPaise : netPaise // ignore: cast_nullable_to_non_nullable
as int,gstRate: null == gstRate ? _self.gstRate : gstRate // ignore: cast_nullable_to_non_nullable
as num,taxablePaise: null == taxablePaise ? _self.taxablePaise : taxablePaise // ignore: cast_nullable_to_non_nullable
as int,gstPaise: null == gstPaise ? _self.gstPaise : gstPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceItem].
extension InvoiceItemPatterns on InvoiceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceItem value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceItem value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int position,  String kind,  String description,  int qty, @JsonKey(name: 'unit_paise')  int unitPaise, @JsonKey(name: 'gross_paise')  int grossPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'net_paise')  int netPaise, @JsonKey(name: 'gst_rate')  num gstRate, @JsonKey(name: 'taxable_paise')  int taxablePaise, @JsonKey(name: 'gst_paise')  int gstPaise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
return $default(_that.id,_that.position,_that.kind,_that.description,_that.qty,_that.unitPaise,_that.grossPaise,_that.discountPaise,_that.netPaise,_that.gstRate,_that.taxablePaise,_that.gstPaise);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int position,  String kind,  String description,  int qty, @JsonKey(name: 'unit_paise')  int unitPaise, @JsonKey(name: 'gross_paise')  int grossPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'net_paise')  int netPaise, @JsonKey(name: 'gst_rate')  num gstRate, @JsonKey(name: 'taxable_paise')  int taxablePaise, @JsonKey(name: 'gst_paise')  int gstPaise)  $default,) {final _that = this;
switch (_that) {
case _InvoiceItem():
return $default(_that.id,_that.position,_that.kind,_that.description,_that.qty,_that.unitPaise,_that.grossPaise,_that.discountPaise,_that.netPaise,_that.gstRate,_that.taxablePaise,_that.gstPaise);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int position,  String kind,  String description,  int qty, @JsonKey(name: 'unit_paise')  int unitPaise, @JsonKey(name: 'gross_paise')  int grossPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'net_paise')  int netPaise, @JsonKey(name: 'gst_rate')  num gstRate, @JsonKey(name: 'taxable_paise')  int taxablePaise, @JsonKey(name: 'gst_paise')  int gstPaise)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
return $default(_that.id,_that.position,_that.kind,_that.description,_that.qty,_that.unitPaise,_that.grossPaise,_that.discountPaise,_that.netPaise,_that.gstRate,_that.taxablePaise,_that.gstPaise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceItem implements InvoiceItem {
  const _InvoiceItem({required this.id, required this.position, this.kind = 'other', required this.description, this.qty = 1, @JsonKey(name: 'unit_paise') required this.unitPaise, @JsonKey(name: 'gross_paise') required this.grossPaise, @JsonKey(name: 'discount_paise') this.discountPaise = 0, @JsonKey(name: 'net_paise') required this.netPaise, @JsonKey(name: 'gst_rate') this.gstRate = 0, @JsonKey(name: 'taxable_paise') this.taxablePaise = 0, @JsonKey(name: 'gst_paise') this.gstPaise = 0});
  factory _InvoiceItem.fromJson(Map<String, dynamic> json) => _$InvoiceItemFromJson(json);

@override final  String id;
@override final  int position;
@override@JsonKey() final  String kind;
@override final  String description;
@override@JsonKey() final  int qty;
@override@JsonKey(name: 'unit_paise') final  int unitPaise;
@override@JsonKey(name: 'gross_paise') final  int grossPaise;
@override@JsonKey(name: 'discount_paise') final  int discountPaise;
@override@JsonKey(name: 'net_paise') final  int netPaise;
@override@JsonKey(name: 'gst_rate') final  num gstRate;
@override@JsonKey(name: 'taxable_paise') final  int taxablePaise;
@override@JsonKey(name: 'gst_paise') final  int gstPaise;

/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceItemCopyWith<_InvoiceItem> get copyWith => __$InvoiceItemCopyWithImpl<_InvoiceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.description, description) || other.description == description)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPaise, unitPaise) || other.unitPaise == unitPaise)&&(identical(other.grossPaise, grossPaise) || other.grossPaise == grossPaise)&&(identical(other.discountPaise, discountPaise) || other.discountPaise == discountPaise)&&(identical(other.netPaise, netPaise) || other.netPaise == netPaise)&&(identical(other.gstRate, gstRate) || other.gstRate == gstRate)&&(identical(other.taxablePaise, taxablePaise) || other.taxablePaise == taxablePaise)&&(identical(other.gstPaise, gstPaise) || other.gstPaise == gstPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position,kind,description,qty,unitPaise,grossPaise,discountPaise,netPaise,gstRate,taxablePaise,gstPaise);
}

@override
String toString() {
    return 'InvoiceItem(id: $id, position: $position, kind: $kind, description: $description, qty: $qty, unitPaise: $unitPaise, grossPaise: $grossPaise, discountPaise: $discountPaise, netPaise: $netPaise, gstRate: $gstRate, taxablePaise: $taxablePaise, gstPaise: $gstPaise)';
}


}

/// @nodoc
abstract mixin class _$InvoiceItemCopyWith<$Res> implements $InvoiceItemCopyWith<$Res> {
  factory _$InvoiceItemCopyWith(_InvoiceItem value, $Res Function(_InvoiceItem) _then) = __$InvoiceItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int position, String kind, String description, int qty,@JsonKey(name: 'unit_paise') int unitPaise,@JsonKey(name: 'gross_paise') int grossPaise,@JsonKey(name: 'discount_paise') int discountPaise,@JsonKey(name: 'net_paise') int netPaise,@JsonKey(name: 'gst_rate') num gstRate,@JsonKey(name: 'taxable_paise') int taxablePaise,@JsonKey(name: 'gst_paise') int gstPaise
});




}
/// @nodoc
class __$InvoiceItemCopyWithImpl<$Res>
    implements _$InvoiceItemCopyWith<$Res> {
  __$InvoiceItemCopyWithImpl(this._self, this._then);

  final _InvoiceItem _self;
  final $Res Function(_InvoiceItem) _then;

/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? kind = null,Object? description = null,Object? qty = null,Object? unitPaise = null,Object? grossPaise = null,Object? discountPaise = null,Object? netPaise = null,Object? gstRate = null,Object? taxablePaise = null,Object? gstPaise = null,}) {
  return _then(_InvoiceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,unitPaise: null == unitPaise ? _self.unitPaise : unitPaise // ignore: cast_nullable_to_non_nullable
as int,grossPaise: null == grossPaise ? _self.grossPaise : grossPaise // ignore: cast_nullable_to_non_nullable
as int,discountPaise: null == discountPaise ? _self.discountPaise : discountPaise // ignore: cast_nullable_to_non_nullable
as int,netPaise: null == netPaise ? _self.netPaise : netPaise // ignore: cast_nullable_to_non_nullable
as int,gstRate: null == gstRate ? _self.gstRate : gstRate // ignore: cast_nullable_to_non_nullable
as num,taxablePaise: null == taxablePaise ? _self.taxablePaise : taxablePaise // ignore: cast_nullable_to_non_nullable
as int,gstPaise: null == gstPaise ? _self.gstPaise : gstPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Instalment {

 String get id; int get seq;@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) DateTime? get dueDate;@JsonKey(name: 'amount_paise') int get amountPaise; String get status;
/// Create a copy of Instalment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstalmentCopyWith<Instalment> get copyWith => _$InstalmentCopyWithImpl<Instalment>(this as Instalment, _$identity);

  /// Serializes this Instalment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Instalment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Instalment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.amountPaise, _this.amountPaise) || other.amountPaise == _this.amountPaise)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Instalment;
  return Object.hash(runtimeType,_this.id,_this.seq,_this.dueDate,_this.amountPaise,_this.status);
}

@override
String toString() {
  final _this = this as Instalment;
  return 'Instalment(id: ${_this.id}, seq: ${_this.seq}, dueDate: ${_this.dueDate}, amountPaise: ${_this.amountPaise}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $InstalmentCopyWith<$Res>  {
  factory $InstalmentCopyWith(Instalment value, $Res Function(Instalment) _then) = _$InstalmentCopyWithImpl;
@useResult
$Res call({
 String id, int seq,@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) DateTime? dueDate,@JsonKey(name: 'amount_paise') int amountPaise, String status
});




}
/// @nodoc
class _$InstalmentCopyWithImpl<$Res>
    implements $InstalmentCopyWith<$Res> {
  _$InstalmentCopyWithImpl(this._self, this._then);

  final Instalment _self;
  final $Res Function(Instalment) _then;

/// Create a copy of Instalment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seq = null,Object? dueDate = freezed,Object? amountPaise = null,Object? status = null,}) {
  return _then(Instalment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Instalment].
extension InstalmentPatterns on Instalment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Instalment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Instalment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Instalment value)  $default,){
final _that = this;
switch (_that) {
case _Instalment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Instalment value)?  $default,){
final _that = this;
switch (_that) {
case _Instalment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int seq, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut)  DateTime? dueDate, @JsonKey(name: 'amount_paise')  int amountPaise,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Instalment() when $default != null:
return $default(_that.id,_that.seq,_that.dueDate,_that.amountPaise,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int seq, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut)  DateTime? dueDate, @JsonKey(name: 'amount_paise')  int amountPaise,  String status)  $default,) {final _that = this;
switch (_that) {
case _Instalment():
return $default(_that.id,_that.seq,_that.dueDate,_that.amountPaise,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int seq, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut)  DateTime? dueDate, @JsonKey(name: 'amount_paise')  int amountPaise,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Instalment() when $default != null:
return $default(_that.id,_that.seq,_that.dueDate,_that.amountPaise,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Instalment implements Instalment {
  const _Instalment({required this.id, required this.seq, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) required this.dueDate, @JsonKey(name: 'amount_paise') required this.amountPaise, this.status = 'due'});
  factory _Instalment.fromJson(Map<String, dynamic> json) => _$InstalmentFromJson(json);

@override final  String id;
@override final  int seq;
@override@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) final  DateTime? dueDate;
@override@JsonKey(name: 'amount_paise') final  int amountPaise;
@override@JsonKey() final  String status;

/// Create a copy of Instalment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstalmentCopyWith<_Instalment> get copyWith => __$InstalmentCopyWithImpl<_Instalment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstalmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Instalment&&(identical(other.id, id) || other.id == id)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.amountPaise, amountPaise) || other.amountPaise == amountPaise)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,seq,dueDate,amountPaise,status);
}

@override
String toString() {
    return 'Instalment(id: $id, seq: $seq, dueDate: $dueDate, amountPaise: $amountPaise, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InstalmentCopyWith<$Res> implements $InstalmentCopyWith<$Res> {
  factory _$InstalmentCopyWith(_Instalment value, $Res Function(_Instalment) _then) = __$InstalmentCopyWithImpl;
@override @useResult
$Res call({
 String id, int seq,@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) DateTime? dueDate,@JsonKey(name: 'amount_paise') int amountPaise, String status
});




}
/// @nodoc
class __$InstalmentCopyWithImpl<$Res>
    implements _$InstalmentCopyWith<$Res> {
  __$InstalmentCopyWithImpl(this._self, this._then);

  final _Instalment _self;
  final $Res Function(_Instalment) _then;

/// Create a copy of Instalment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seq = null,Object? dueDate = freezed,Object? amountPaise = null,Object? status = null,}) {
  return _then(_Instalment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Payment {

 String get id;@JsonKey(name: 'receipt_no') String? get receiptNo;@JsonKey(name: 'invoice_id') String? get invoiceId;@JsonKey(name: 'member_id') String? get memberId;@JsonKey(name: 'member_name') String get memberName;@JsonKey(name: 'amount_paise') int get amountPaise;@JsonKey(name: 'applied_paise') int get appliedPaise;@JsonKey(name: 'refunded_paise') int get refundedPaise; PaymentMode get mode; String? get utr;@JsonKey(name: 'paid_at') DateTime get paidAt;@JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut) DateTime? get paidOn;@JsonKey(name: 'collected_by') String? get collectedBy; PaymentStatus get status; String? get note;@JsonKey(name: 'voided_reason') String? get voidedReason;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Payment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.receiptNo, _this.receiptNo) || other.receiptNo == _this.receiptNo)&&(identical(other.invoiceId, _this.invoiceId) || other.invoiceId == _this.invoiceId)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.amountPaise, _this.amountPaise) || other.amountPaise == _this.amountPaise)&&(identical(other.appliedPaise, _this.appliedPaise) || other.appliedPaise == _this.appliedPaise)&&(identical(other.refundedPaise, _this.refundedPaise) || other.refundedPaise == _this.refundedPaise)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.utr, _this.utr) || other.utr == _this.utr)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt)&&(identical(other.paidOn, _this.paidOn) || other.paidOn == _this.paidOn)&&(identical(other.collectedBy, _this.collectedBy) || other.collectedBy == _this.collectedBy)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.voidedReason, _this.voidedReason) || other.voidedReason == _this.voidedReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Payment;
  return Object.hash(runtimeType,_this.id,_this.receiptNo,_this.invoiceId,_this.memberId,_this.memberName,_this.amountPaise,_this.appliedPaise,_this.refundedPaise,_this.mode,_this.utr,_this.paidAt,_this.paidOn,_this.collectedBy,_this.status,_this.note,_this.voidedReason);
}

@override
String toString() {
  final _this = this as Payment;
  return 'Payment(id: ${_this.id}, receiptNo: ${_this.receiptNo}, invoiceId: ${_this.invoiceId}, memberId: ${_this.memberId}, memberName: ${_this.memberName}, amountPaise: ${_this.amountPaise}, appliedPaise: ${_this.appliedPaise}, refundedPaise: ${_this.refundedPaise}, mode: ${_this.mode}, utr: ${_this.utr}, paidAt: ${_this.paidAt}, paidOn: ${_this.paidOn}, collectedBy: ${_this.collectedBy}, status: ${_this.status}, note: ${_this.note}, voidedReason: ${_this.voidedReason})';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'receipt_no') String? receiptNo,@JsonKey(name: 'invoice_id') String? invoiceId,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'amount_paise') int amountPaise,@JsonKey(name: 'applied_paise') int appliedPaise,@JsonKey(name: 'refunded_paise') int refundedPaise, PaymentMode mode, String? utr,@JsonKey(name: 'paid_at') DateTime paidAt,@JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut) DateTime? paidOn,@JsonKey(name: 'collected_by') String? collectedBy, PaymentStatus status, String? note,@JsonKey(name: 'voided_reason') String? voidedReason
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? receiptNo = freezed,Object? invoiceId = freezed,Object? memberId = freezed,Object? memberName = null,Object? amountPaise = null,Object? appliedPaise = null,Object? refundedPaise = null,Object? mode = null,Object? utr = freezed,Object? paidAt = null,Object? paidOn = freezed,Object? collectedBy = freezed,Object? status = null,Object? note = freezed,Object? voidedReason = freezed,}) {
  return _then(Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: freezed == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,appliedPaise: null == appliedPaise ? _self.appliedPaise : appliedPaise // ignore: cast_nullable_to_non_nullable
as int,refundedPaise: null == refundedPaise ? _self.refundedPaise : refundedPaise // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode,utr: freezed == utr ? _self.utr : utr // ignore: cast_nullable_to_non_nullable
as String?,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidOn: freezed == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as DateTime?,collectedBy: freezed == collectedBy ? _self.collectedBy : collectedBy // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,voidedReason: freezed == voidedReason ? _self.voidedReason : voidedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'receipt_no')  String? receiptNo, @JsonKey(name: 'invoice_id')  String? invoiceId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'applied_paise')  int appliedPaise, @JsonKey(name: 'refunded_paise')  int refundedPaise,  PaymentMode mode,  String? utr, @JsonKey(name: 'paid_at')  DateTime paidAt, @JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut)  DateTime? paidOn, @JsonKey(name: 'collected_by')  String? collectedBy,  PaymentStatus status,  String? note, @JsonKey(name: 'voided_reason')  String? voidedReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.receiptNo,_that.invoiceId,_that.memberId,_that.memberName,_that.amountPaise,_that.appliedPaise,_that.refundedPaise,_that.mode,_that.utr,_that.paidAt,_that.paidOn,_that.collectedBy,_that.status,_that.note,_that.voidedReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'receipt_no')  String? receiptNo, @JsonKey(name: 'invoice_id')  String? invoiceId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'applied_paise')  int appliedPaise, @JsonKey(name: 'refunded_paise')  int refundedPaise,  PaymentMode mode,  String? utr, @JsonKey(name: 'paid_at')  DateTime paidAt, @JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut)  DateTime? paidOn, @JsonKey(name: 'collected_by')  String? collectedBy,  PaymentStatus status,  String? note, @JsonKey(name: 'voided_reason')  String? voidedReason)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.receiptNo,_that.invoiceId,_that.memberId,_that.memberName,_that.amountPaise,_that.appliedPaise,_that.refundedPaise,_that.mode,_that.utr,_that.paidAt,_that.paidOn,_that.collectedBy,_that.status,_that.note,_that.voidedReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'receipt_no')  String? receiptNo, @JsonKey(name: 'invoice_id')  String? invoiceId, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'applied_paise')  int appliedPaise, @JsonKey(name: 'refunded_paise')  int refundedPaise,  PaymentMode mode,  String? utr, @JsonKey(name: 'paid_at')  DateTime paidAt, @JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut)  DateTime? paidOn, @JsonKey(name: 'collected_by')  String? collectedBy,  PaymentStatus status,  String? note, @JsonKey(name: 'voided_reason')  String? voidedReason)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.receiptNo,_that.invoiceId,_that.memberId,_that.memberName,_that.amountPaise,_that.appliedPaise,_that.refundedPaise,_that.mode,_that.utr,_that.paidAt,_that.paidOn,_that.collectedBy,_that.status,_that.note,_that.voidedReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment extends Payment {
  const _Payment({required this.id, @JsonKey(name: 'receipt_no') this.receiptNo, @JsonKey(name: 'invoice_id') this.invoiceId, @JsonKey(name: 'member_id') this.memberId, @JsonKey(name: 'member_name') required this.memberName, @JsonKey(name: 'amount_paise') required this.amountPaise, @JsonKey(name: 'applied_paise') this.appliedPaise = 0, @JsonKey(name: 'refunded_paise') this.refundedPaise = 0, required this.mode, this.utr, @JsonKey(name: 'paid_at') required this.paidAt, @JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut) this.paidOn, @JsonKey(name: 'collected_by') this.collectedBy, this.status = PaymentStatus.confirmed, this.note, @JsonKey(name: 'voided_reason') this.voidedReason}): super._();
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String id;
@override@JsonKey(name: 'receipt_no') final  String? receiptNo;
@override@JsonKey(name: 'invoice_id') final  String? invoiceId;
@override@JsonKey(name: 'member_id') final  String? memberId;
@override@JsonKey(name: 'member_name') final  String memberName;
@override@JsonKey(name: 'amount_paise') final  int amountPaise;
@override@JsonKey(name: 'applied_paise') final  int appliedPaise;
@override@JsonKey(name: 'refunded_paise') final  int refundedPaise;
@override final  PaymentMode mode;
@override final  String? utr;
@override@JsonKey(name: 'paid_at') final  DateTime paidAt;
@override@JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut) final  DateTime? paidOn;
@override@JsonKey(name: 'collected_by') final  String? collectedBy;
@override@JsonKey() final  PaymentStatus status;
@override final  String? note;
@override@JsonKey(name: 'voided_reason') final  String? voidedReason;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.amountPaise, amountPaise) || other.amountPaise == amountPaise)&&(identical(other.appliedPaise, appliedPaise) || other.appliedPaise == appliedPaise)&&(identical(other.refundedPaise, refundedPaise) || other.refundedPaise == refundedPaise)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.utr, utr) || other.utr == utr)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.collectedBy, collectedBy) || other.collectedBy == collectedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.voidedReason, voidedReason) || other.voidedReason == voidedReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,receiptNo,invoiceId,memberId,memberName,amountPaise,appliedPaise,refundedPaise,mode,utr,paidAt,paidOn,collectedBy,status,note,voidedReason);
}

@override
String toString() {
    return 'Payment(id: $id, receiptNo: $receiptNo, invoiceId: $invoiceId, memberId: $memberId, memberName: $memberName, amountPaise: $amountPaise, appliedPaise: $appliedPaise, refundedPaise: $refundedPaise, mode: $mode, utr: $utr, paidAt: $paidAt, paidOn: $paidOn, collectedBy: $collectedBy, status: $status, note: $note, voidedReason: $voidedReason)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'receipt_no') String? receiptNo,@JsonKey(name: 'invoice_id') String? invoiceId,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'amount_paise') int amountPaise,@JsonKey(name: 'applied_paise') int appliedPaise,@JsonKey(name: 'refunded_paise') int refundedPaise, PaymentMode mode, String? utr,@JsonKey(name: 'paid_at') DateTime paidAt,@JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut) DateTime? paidOn,@JsonKey(name: 'collected_by') String? collectedBy, PaymentStatus status, String? note,@JsonKey(name: 'voided_reason') String? voidedReason
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? receiptNo = freezed,Object? invoiceId = freezed,Object? memberId = freezed,Object? memberName = null,Object? amountPaise = null,Object? appliedPaise = null,Object? refundedPaise = null,Object? mode = null,Object? utr = freezed,Object? paidAt = null,Object? paidOn = freezed,Object? collectedBy = freezed,Object? status = null,Object? note = freezed,Object? voidedReason = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: freezed == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String?,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,appliedPaise: null == appliedPaise ? _self.appliedPaise : appliedPaise // ignore: cast_nullable_to_non_nullable
as int,refundedPaise: null == refundedPaise ? _self.refundedPaise : refundedPaise // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode,utr: freezed == utr ? _self.utr : utr // ignore: cast_nullable_to_non_nullable
as String?,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidOn: freezed == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as DateTime?,collectedBy: freezed == collectedBy ? _self.collectedBy : collectedBy // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,voidedReason: freezed == voidedReason ? _self.voidedReason : voidedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Invoice {

 String get id;@JsonKey(name: 'invoice_no') String get invoiceNo;@JsonKey(name: 'member_id') String? get memberId;@JsonKey(name: 'member_name') String get memberName;@JsonKey(name: 'member_code') String get memberCode;@JsonKey(name: 'member_phone') String? get memberPhone;@JsonKey(name: 'membership_id') String? get membershipId;@JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut) DateTime? get issueDate;@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) DateTime? get dueDate;@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) DateTime? get nextDueDate;@JsonKey(name: 'subtotal_paise') int get subtotalPaise;@JsonKey(name: 'discount_paise') int get discountPaise;@JsonKey(name: 'discount_reason') String? get discountReason;@JsonKey(name: 'taxable_paise') int get taxablePaise;@JsonKey(name: 'cgst_paise') int get cgstPaise;@JsonKey(name: 'sgst_paise') int get sgstPaise;@JsonKey(name: 'total_paise') int get totalPaise;@JsonKey(name: 'paid_paise') int get paidPaise;@JsonKey(name: 'balance_paise') int get balancePaise; InvoiceStatus get status;@JsonKey(name: 'overdue_days') int get overdueDays;@JsonKey(name: 'gateway_link_url') String? get gatewayLinkUrl;@JsonKey(name: 'voided_reason') String? get voidedReason;@JsonKey(name: 'invoice_items') List<InvoiceItem> get items; List<Instalment> get instalments; List<Payment> get payments;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Invoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.invoiceNo, _this.invoiceNo) || other.invoiceNo == _this.invoiceNo)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.memberCode, _this.memberCode) || other.memberCode == _this.memberCode)&&(identical(other.memberPhone, _this.memberPhone) || other.memberPhone == _this.memberPhone)&&(identical(other.membershipId, _this.membershipId) || other.membershipId == _this.membershipId)&&(identical(other.issueDate, _this.issueDate) || other.issueDate == _this.issueDate)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.nextDueDate, _this.nextDueDate) || other.nextDueDate == _this.nextDueDate)&&(identical(other.subtotalPaise, _this.subtotalPaise) || other.subtotalPaise == _this.subtotalPaise)&&(identical(other.discountPaise, _this.discountPaise) || other.discountPaise == _this.discountPaise)&&(identical(other.discountReason, _this.discountReason) || other.discountReason == _this.discountReason)&&(identical(other.taxablePaise, _this.taxablePaise) || other.taxablePaise == _this.taxablePaise)&&(identical(other.cgstPaise, _this.cgstPaise) || other.cgstPaise == _this.cgstPaise)&&(identical(other.sgstPaise, _this.sgstPaise) || other.sgstPaise == _this.sgstPaise)&&(identical(other.totalPaise, _this.totalPaise) || other.totalPaise == _this.totalPaise)&&(identical(other.paidPaise, _this.paidPaise) || other.paidPaise == _this.paidPaise)&&(identical(other.balancePaise, _this.balancePaise) || other.balancePaise == _this.balancePaise)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.overdueDays, _this.overdueDays) || other.overdueDays == _this.overdueDays)&&(identical(other.gatewayLinkUrl, _this.gatewayLinkUrl) || other.gatewayLinkUrl == _this.gatewayLinkUrl)&&(identical(other.voidedReason, _this.voidedReason) || other.voidedReason == _this.voidedReason)&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.instalments, _this.instalments)&&const DeepCollectionEquality().equals(other.payments, _this.payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Invoice;
  return Object.hashAll([runtimeType,_this.id,_this.invoiceNo,_this.memberId,_this.memberName,_this.memberCode,_this.memberPhone,_this.membershipId,_this.issueDate,_this.dueDate,_this.nextDueDate,_this.subtotalPaise,_this.discountPaise,_this.discountReason,_this.taxablePaise,_this.cgstPaise,_this.sgstPaise,_this.totalPaise,_this.paidPaise,_this.balancePaise,_this.status,_this.overdueDays,_this.gatewayLinkUrl,_this.voidedReason,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.instalments),const DeepCollectionEquality().hash(_this.payments)]);
}

@override
String toString() {
  final _this = this as Invoice;
  return 'Invoice(id: ${_this.id}, invoiceNo: ${_this.invoiceNo}, memberId: ${_this.memberId}, memberName: ${_this.memberName}, memberCode: ${_this.memberCode}, memberPhone: ${_this.memberPhone}, membershipId: ${_this.membershipId}, issueDate: ${_this.issueDate}, dueDate: ${_this.dueDate}, nextDueDate: ${_this.nextDueDate}, subtotalPaise: ${_this.subtotalPaise}, discountPaise: ${_this.discountPaise}, discountReason: ${_this.discountReason}, taxablePaise: ${_this.taxablePaise}, cgstPaise: ${_this.cgstPaise}, sgstPaise: ${_this.sgstPaise}, totalPaise: ${_this.totalPaise}, paidPaise: ${_this.paidPaise}, balancePaise: ${_this.balancePaise}, status: ${_this.status}, overdueDays: ${_this.overdueDays}, gatewayLinkUrl: ${_this.gatewayLinkUrl}, voidedReason: ${_this.voidedReason}, items: ${_this.items}, instalments: ${_this.instalments}, payments: ${_this.payments})';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'invoice_no') String invoiceNo,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'member_phone') String? memberPhone,@JsonKey(name: 'membership_id') String? membershipId,@JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut) DateTime? issueDate,@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) DateTime? dueDate,@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) DateTime? nextDueDate,@JsonKey(name: 'subtotal_paise') int subtotalPaise,@JsonKey(name: 'discount_paise') int discountPaise,@JsonKey(name: 'discount_reason') String? discountReason,@JsonKey(name: 'taxable_paise') int taxablePaise,@JsonKey(name: 'cgst_paise') int cgstPaise,@JsonKey(name: 'sgst_paise') int sgstPaise,@JsonKey(name: 'total_paise') int totalPaise,@JsonKey(name: 'paid_paise') int paidPaise,@JsonKey(name: 'balance_paise') int balancePaise, InvoiceStatus status,@JsonKey(name: 'overdue_days') int overdueDays,@JsonKey(name: 'gateway_link_url') String? gatewayLinkUrl,@JsonKey(name: 'voided_reason') String? voidedReason,@JsonKey(name: 'invoice_items') List<InvoiceItem> items, List<Instalment> instalments, List<Payment> payments
});




}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? invoiceNo = null,Object? memberId = freezed,Object? memberName = null,Object? memberCode = null,Object? memberPhone = freezed,Object? membershipId = freezed,Object? issueDate = freezed,Object? dueDate = freezed,Object? nextDueDate = freezed,Object? subtotalPaise = null,Object? discountPaise = null,Object? discountReason = freezed,Object? taxablePaise = null,Object? cgstPaise = null,Object? sgstPaise = null,Object? totalPaise = null,Object? paidPaise = null,Object? balancePaise = null,Object? status = null,Object? overdueDays = null,Object? gatewayLinkUrl = freezed,Object? voidedReason = freezed,Object? items = null,Object? instalments = null,Object? payments = null,}) {
  return _then(Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceNo: null == invoiceNo ? _self.invoiceNo : invoiceNo // ignore: cast_nullable_to_non_nullable
as String,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,memberPhone: freezed == memberPhone ? _self.memberPhone : memberPhone // ignore: cast_nullable_to_non_nullable
as String?,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotalPaise: null == subtotalPaise ? _self.subtotalPaise : subtotalPaise // ignore: cast_nullable_to_non_nullable
as int,discountPaise: null == discountPaise ? _self.discountPaise : discountPaise // ignore: cast_nullable_to_non_nullable
as int,discountReason: freezed == discountReason ? _self.discountReason : discountReason // ignore: cast_nullable_to_non_nullable
as String?,taxablePaise: null == taxablePaise ? _self.taxablePaise : taxablePaise // ignore: cast_nullable_to_non_nullable
as int,cgstPaise: null == cgstPaise ? _self.cgstPaise : cgstPaise // ignore: cast_nullable_to_non_nullable
as int,sgstPaise: null == sgstPaise ? _self.sgstPaise : sgstPaise // ignore: cast_nullable_to_non_nullable
as int,totalPaise: null == totalPaise ? _self.totalPaise : totalPaise // ignore: cast_nullable_to_non_nullable
as int,paidPaise: null == paidPaise ? _self.paidPaise : paidPaise // ignore: cast_nullable_to_non_nullable
as int,balancePaise: null == balancePaise ? _self.balancePaise : balancePaise // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,overdueDays: null == overdueDays ? _self.overdueDays : overdueDays // ignore: cast_nullable_to_non_nullable
as int,gatewayLinkUrl: freezed == gatewayLinkUrl ? _self.gatewayLinkUrl : gatewayLinkUrl // ignore: cast_nullable_to_non_nullable
as String?,voidedReason: freezed == voidedReason ? _self.voidedReason : voidedReason // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItem>,instalments: null == instalments ? _self.instalments : instalments // ignore: cast_nullable_to_non_nullable
as List<Instalment>,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,
  ));
}

}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'invoice_no')  String invoiceNo, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'member_phone')  String? memberPhone, @JsonKey(name: 'membership_id')  String? membershipId, @JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut)  DateTime? issueDate, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut)  DateTime? dueDate, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut)  DateTime? nextDueDate, @JsonKey(name: 'subtotal_paise')  int subtotalPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'discount_reason')  String? discountReason, @JsonKey(name: 'taxable_paise')  int taxablePaise, @JsonKey(name: 'cgst_paise')  int cgstPaise, @JsonKey(name: 'sgst_paise')  int sgstPaise, @JsonKey(name: 'total_paise')  int totalPaise, @JsonKey(name: 'paid_paise')  int paidPaise, @JsonKey(name: 'balance_paise')  int balancePaise,  InvoiceStatus status, @JsonKey(name: 'overdue_days')  int overdueDays, @JsonKey(name: 'gateway_link_url')  String? gatewayLinkUrl, @JsonKey(name: 'voided_reason')  String? voidedReason, @JsonKey(name: 'invoice_items')  List<InvoiceItem> items,  List<Instalment> instalments,  List<Payment> payments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.invoiceNo,_that.memberId,_that.memberName,_that.memberCode,_that.memberPhone,_that.membershipId,_that.issueDate,_that.dueDate,_that.nextDueDate,_that.subtotalPaise,_that.discountPaise,_that.discountReason,_that.taxablePaise,_that.cgstPaise,_that.sgstPaise,_that.totalPaise,_that.paidPaise,_that.balancePaise,_that.status,_that.overdueDays,_that.gatewayLinkUrl,_that.voidedReason,_that.items,_that.instalments,_that.payments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'invoice_no')  String invoiceNo, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'member_phone')  String? memberPhone, @JsonKey(name: 'membership_id')  String? membershipId, @JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut)  DateTime? issueDate, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut)  DateTime? dueDate, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut)  DateTime? nextDueDate, @JsonKey(name: 'subtotal_paise')  int subtotalPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'discount_reason')  String? discountReason, @JsonKey(name: 'taxable_paise')  int taxablePaise, @JsonKey(name: 'cgst_paise')  int cgstPaise, @JsonKey(name: 'sgst_paise')  int sgstPaise, @JsonKey(name: 'total_paise')  int totalPaise, @JsonKey(name: 'paid_paise')  int paidPaise, @JsonKey(name: 'balance_paise')  int balancePaise,  InvoiceStatus status, @JsonKey(name: 'overdue_days')  int overdueDays, @JsonKey(name: 'gateway_link_url')  String? gatewayLinkUrl, @JsonKey(name: 'voided_reason')  String? voidedReason, @JsonKey(name: 'invoice_items')  List<InvoiceItem> items,  List<Instalment> instalments,  List<Payment> payments)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.invoiceNo,_that.memberId,_that.memberName,_that.memberCode,_that.memberPhone,_that.membershipId,_that.issueDate,_that.dueDate,_that.nextDueDate,_that.subtotalPaise,_that.discountPaise,_that.discountReason,_that.taxablePaise,_that.cgstPaise,_that.sgstPaise,_that.totalPaise,_that.paidPaise,_that.balancePaise,_that.status,_that.overdueDays,_that.gatewayLinkUrl,_that.voidedReason,_that.items,_that.instalments,_that.payments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'invoice_no')  String invoiceNo, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'member_code')  String memberCode, @JsonKey(name: 'member_phone')  String? memberPhone, @JsonKey(name: 'membership_id')  String? membershipId, @JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut)  DateTime? issueDate, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut)  DateTime? dueDate, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut)  DateTime? nextDueDate, @JsonKey(name: 'subtotal_paise')  int subtotalPaise, @JsonKey(name: 'discount_paise')  int discountPaise, @JsonKey(name: 'discount_reason')  String? discountReason, @JsonKey(name: 'taxable_paise')  int taxablePaise, @JsonKey(name: 'cgst_paise')  int cgstPaise, @JsonKey(name: 'sgst_paise')  int sgstPaise, @JsonKey(name: 'total_paise')  int totalPaise, @JsonKey(name: 'paid_paise')  int paidPaise, @JsonKey(name: 'balance_paise')  int balancePaise,  InvoiceStatus status, @JsonKey(name: 'overdue_days')  int overdueDays, @JsonKey(name: 'gateway_link_url')  String? gatewayLinkUrl, @JsonKey(name: 'voided_reason')  String? voidedReason, @JsonKey(name: 'invoice_items')  List<InvoiceItem> items,  List<Instalment> instalments,  List<Payment> payments)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.invoiceNo,_that.memberId,_that.memberName,_that.memberCode,_that.memberPhone,_that.membershipId,_that.issueDate,_that.dueDate,_that.nextDueDate,_that.subtotalPaise,_that.discountPaise,_that.discountReason,_that.taxablePaise,_that.cgstPaise,_that.sgstPaise,_that.totalPaise,_that.paidPaise,_that.balancePaise,_that.status,_that.overdueDays,_that.gatewayLinkUrl,_that.voidedReason,_that.items,_that.instalments,_that.payments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invoice extends Invoice {
  const _Invoice({required this.id, @JsonKey(name: 'invoice_no') required this.invoiceNo, @JsonKey(name: 'member_id') this.memberId, @JsonKey(name: 'member_name') required this.memberName, @JsonKey(name: 'member_code') required this.memberCode, @JsonKey(name: 'member_phone') this.memberPhone, @JsonKey(name: 'membership_id') this.membershipId, @JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut) required this.issueDate, @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) required this.dueDate, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) required this.nextDueDate, @JsonKey(name: 'subtotal_paise') this.subtotalPaise = 0, @JsonKey(name: 'discount_paise') this.discountPaise = 0, @JsonKey(name: 'discount_reason') this.discountReason, @JsonKey(name: 'taxable_paise') this.taxablePaise = 0, @JsonKey(name: 'cgst_paise') this.cgstPaise = 0, @JsonKey(name: 'sgst_paise') this.sgstPaise = 0, @JsonKey(name: 'total_paise') this.totalPaise = 0, @JsonKey(name: 'paid_paise') this.paidPaise = 0, @JsonKey(name: 'balance_paise') this.balancePaise = 0, this.status = InvoiceStatus.unpaid, @JsonKey(name: 'overdue_days') this.overdueDays = 0, @JsonKey(name: 'gateway_link_url') this.gatewayLinkUrl, @JsonKey(name: 'voided_reason') this.voidedReason, @JsonKey(name: 'invoice_items')  List<InvoiceItem> items = const [],  List<Instalment> instalments = const [],  List<Payment> payments = const []}): _items = items,_instalments = instalments,_payments = payments,super._();
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override final  String id;
@override@JsonKey(name: 'invoice_no') final  String invoiceNo;
@override@JsonKey(name: 'member_id') final  String? memberId;
@override@JsonKey(name: 'member_name') final  String memberName;
@override@JsonKey(name: 'member_code') final  String memberCode;
@override@JsonKey(name: 'member_phone') final  String? memberPhone;
@override@JsonKey(name: 'membership_id') final  String? membershipId;
@override@JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut) final  DateTime? issueDate;
@override@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) final  DateTime? dueDate;
@override@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) final  DateTime? nextDueDate;
@override@JsonKey(name: 'subtotal_paise') final  int subtotalPaise;
@override@JsonKey(name: 'discount_paise') final  int discountPaise;
@override@JsonKey(name: 'discount_reason') final  String? discountReason;
@override@JsonKey(name: 'taxable_paise') final  int taxablePaise;
@override@JsonKey(name: 'cgst_paise') final  int cgstPaise;
@override@JsonKey(name: 'sgst_paise') final  int sgstPaise;
@override@JsonKey(name: 'total_paise') final  int totalPaise;
@override@JsonKey(name: 'paid_paise') final  int paidPaise;
@override@JsonKey(name: 'balance_paise') final  int balancePaise;
@override@JsonKey() final  InvoiceStatus status;
@override@JsonKey(name: 'overdue_days') final  int overdueDays;
@override@JsonKey(name: 'gateway_link_url') final  String? gatewayLinkUrl;
@override@JsonKey(name: 'voided_reason') final  String? voidedReason;
 final  List<InvoiceItem> _items;
@override@JsonKey(name: 'invoice_items') List<InvoiceItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<Instalment> _instalments;
@override@JsonKey() List<Instalment> get instalments {
  if (_instalments is EqualUnmodifiableListView) return _instalments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instalments);
}

 final  List<Payment> _payments;
@override@JsonKey() List<Payment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}


/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNo, invoiceNo) || other.invoiceNo == invoiceNo)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.memberCode, memberCode) || other.memberCode == memberCode)&&(identical(other.memberPhone, memberPhone) || other.memberPhone == memberPhone)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.subtotalPaise, subtotalPaise) || other.subtotalPaise == subtotalPaise)&&(identical(other.discountPaise, discountPaise) || other.discountPaise == discountPaise)&&(identical(other.discountReason, discountReason) || other.discountReason == discountReason)&&(identical(other.taxablePaise, taxablePaise) || other.taxablePaise == taxablePaise)&&(identical(other.cgstPaise, cgstPaise) || other.cgstPaise == cgstPaise)&&(identical(other.sgstPaise, sgstPaise) || other.sgstPaise == sgstPaise)&&(identical(other.totalPaise, totalPaise) || other.totalPaise == totalPaise)&&(identical(other.paidPaise, paidPaise) || other.paidPaise == paidPaise)&&(identical(other.balancePaise, balancePaise) || other.balancePaise == balancePaise)&&(identical(other.status, status) || other.status == status)&&(identical(other.overdueDays, overdueDays) || other.overdueDays == overdueDays)&&(identical(other.gatewayLinkUrl, gatewayLinkUrl) || other.gatewayLinkUrl == gatewayLinkUrl)&&(identical(other.voidedReason, voidedReason) || other.voidedReason == voidedReason)&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.instalments, _instalments)&&const DeepCollectionEquality().equals(other.payments, _payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,invoiceNo,memberId,memberName,memberCode,memberPhone,membershipId,issueDate,dueDate,nextDueDate,subtotalPaise,discountPaise,discountReason,taxablePaise,cgstPaise,sgstPaise,totalPaise,paidPaise,balancePaise,status,overdueDays,gatewayLinkUrl,voidedReason,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_instalments),const DeepCollectionEquality().hash(_payments)]);
}

@override
String toString() {
    return 'Invoice(id: $id, invoiceNo: $invoiceNo, memberId: $memberId, memberName: $memberName, memberCode: $memberCode, memberPhone: $memberPhone, membershipId: $membershipId, issueDate: $issueDate, dueDate: $dueDate, nextDueDate: $nextDueDate, subtotalPaise: $subtotalPaise, discountPaise: $discountPaise, discountReason: $discountReason, taxablePaise: $taxablePaise, cgstPaise: $cgstPaise, sgstPaise: $sgstPaise, totalPaise: $totalPaise, paidPaise: $paidPaise, balancePaise: $balancePaise, status: $status, overdueDays: $overdueDays, gatewayLinkUrl: $gatewayLinkUrl, voidedReason: $voidedReason, items: $items, instalments: $instalments, payments: $payments)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'invoice_no') String invoiceNo,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'member_code') String memberCode,@JsonKey(name: 'member_phone') String? memberPhone,@JsonKey(name: 'membership_id') String? membershipId,@JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut) DateTime? issueDate,@JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) DateTime? dueDate,@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) DateTime? nextDueDate,@JsonKey(name: 'subtotal_paise') int subtotalPaise,@JsonKey(name: 'discount_paise') int discountPaise,@JsonKey(name: 'discount_reason') String? discountReason,@JsonKey(name: 'taxable_paise') int taxablePaise,@JsonKey(name: 'cgst_paise') int cgstPaise,@JsonKey(name: 'sgst_paise') int sgstPaise,@JsonKey(name: 'total_paise') int totalPaise,@JsonKey(name: 'paid_paise') int paidPaise,@JsonKey(name: 'balance_paise') int balancePaise, InvoiceStatus status,@JsonKey(name: 'overdue_days') int overdueDays,@JsonKey(name: 'gateway_link_url') String? gatewayLinkUrl,@JsonKey(name: 'voided_reason') String? voidedReason,@JsonKey(name: 'invoice_items') List<InvoiceItem> items, List<Instalment> instalments, List<Payment> payments
});




}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? invoiceNo = null,Object? memberId = freezed,Object? memberName = null,Object? memberCode = null,Object? memberPhone = freezed,Object? membershipId = freezed,Object? issueDate = freezed,Object? dueDate = freezed,Object? nextDueDate = freezed,Object? subtotalPaise = null,Object? discountPaise = null,Object? discountReason = freezed,Object? taxablePaise = null,Object? cgstPaise = null,Object? sgstPaise = null,Object? totalPaise = null,Object? paidPaise = null,Object? balancePaise = null,Object? status = null,Object? overdueDays = null,Object? gatewayLinkUrl = freezed,Object? voidedReason = freezed,Object? items = null,Object? instalments = null,Object? payments = null,}) {
  return _then(_Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceNo: null == invoiceNo ? _self.invoiceNo : invoiceNo // ignore: cast_nullable_to_non_nullable
as String,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberCode: null == memberCode ? _self.memberCode : memberCode // ignore: cast_nullable_to_non_nullable
as String,memberPhone: freezed == memberPhone ? _self.memberPhone : memberPhone // ignore: cast_nullable_to_non_nullable
as String?,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotalPaise: null == subtotalPaise ? _self.subtotalPaise : subtotalPaise // ignore: cast_nullable_to_non_nullable
as int,discountPaise: null == discountPaise ? _self.discountPaise : discountPaise // ignore: cast_nullable_to_non_nullable
as int,discountReason: freezed == discountReason ? _self.discountReason : discountReason // ignore: cast_nullable_to_non_nullable
as String?,taxablePaise: null == taxablePaise ? _self.taxablePaise : taxablePaise // ignore: cast_nullable_to_non_nullable
as int,cgstPaise: null == cgstPaise ? _self.cgstPaise : cgstPaise // ignore: cast_nullable_to_non_nullable
as int,sgstPaise: null == sgstPaise ? _self.sgstPaise : sgstPaise // ignore: cast_nullable_to_non_nullable
as int,totalPaise: null == totalPaise ? _self.totalPaise : totalPaise // ignore: cast_nullable_to_non_nullable
as int,paidPaise: null == paidPaise ? _self.paidPaise : paidPaise // ignore: cast_nullable_to_non_nullable
as int,balancePaise: null == balancePaise ? _self.balancePaise : balancePaise // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,overdueDays: null == overdueDays ? _self.overdueDays : overdueDays // ignore: cast_nullable_to_non_nullable
as int,gatewayLinkUrl: freezed == gatewayLinkUrl ? _self.gatewayLinkUrl : gatewayLinkUrl // ignore: cast_nullable_to_non_nullable
as String?,voidedReason: freezed == voidedReason ? _self.voidedReason : voidedReason // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItem>,instalments: null == instalments ? _self._instalments : instalments // ignore: cast_nullable_to_non_nullable
as List<Instalment>,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,
  ));
}


}


/// @nodoc
mixin _$PaymentResult {

@JsonKey(name: 'payment_id') String get paymentId;@JsonKey(name: 'receipt_no') String? get receiptNo;@JsonKey(name: 'amount_paise') int get amountPaise;@JsonKey(name: 'applied_paise') int get appliedPaise;@JsonKey(name: 'credit_paise') int get creditPaise;@JsonKey(name: 'balance_paise') int get balancePaise;
/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentResultCopyWith<PaymentResult> get copyWith => _$PaymentResultCopyWithImpl<PaymentResult>(this as PaymentResult, _$identity);

  /// Serializes this PaymentResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentResult&&(identical(other.paymentId, _this.paymentId) || other.paymentId == _this.paymentId)&&(identical(other.receiptNo, _this.receiptNo) || other.receiptNo == _this.receiptNo)&&(identical(other.amountPaise, _this.amountPaise) || other.amountPaise == _this.amountPaise)&&(identical(other.appliedPaise, _this.appliedPaise) || other.appliedPaise == _this.appliedPaise)&&(identical(other.creditPaise, _this.creditPaise) || other.creditPaise == _this.creditPaise)&&(identical(other.balancePaise, _this.balancePaise) || other.balancePaise == _this.balancePaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentResult;
  return Object.hash(runtimeType,_this.paymentId,_this.receiptNo,_this.amountPaise,_this.appliedPaise,_this.creditPaise,_this.balancePaise);
}

@override
String toString() {
  final _this = this as PaymentResult;
  return 'PaymentResult(paymentId: ${_this.paymentId}, receiptNo: ${_this.receiptNo}, amountPaise: ${_this.amountPaise}, appliedPaise: ${_this.appliedPaise}, creditPaise: ${_this.creditPaise}, balancePaise: ${_this.balancePaise})';
}


}

/// @nodoc
abstract mixin class $PaymentResultCopyWith<$Res>  {
  factory $PaymentResultCopyWith(PaymentResult value, $Res Function(PaymentResult) _then) = _$PaymentResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'payment_id') String paymentId,@JsonKey(name: 'receipt_no') String? receiptNo,@JsonKey(name: 'amount_paise') int amountPaise,@JsonKey(name: 'applied_paise') int appliedPaise,@JsonKey(name: 'credit_paise') int creditPaise,@JsonKey(name: 'balance_paise') int balancePaise
});




}
/// @nodoc
class _$PaymentResultCopyWithImpl<$Res>
    implements $PaymentResultCopyWith<$Res> {
  _$PaymentResultCopyWithImpl(this._self, this._then);

  final PaymentResult _self;
  final $Res Function(PaymentResult) _then;

/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentId = null,Object? receiptNo = freezed,Object? amountPaise = null,Object? appliedPaise = null,Object? creditPaise = null,Object? balancePaise = null,}) {
  return _then(PaymentResult(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,receiptNo: freezed == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String?,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,appliedPaise: null == appliedPaise ? _self.appliedPaise : appliedPaise // ignore: cast_nullable_to_non_nullable
as int,creditPaise: null == creditPaise ? _self.creditPaise : creditPaise // ignore: cast_nullable_to_non_nullable
as int,balancePaise: null == balancePaise ? _self.balancePaise : balancePaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentResult].
extension PaymentResultPatterns on PaymentResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentResult value)  $default,){
final _that = this;
switch (_that) {
case _PaymentResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentResult value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'payment_id')  String paymentId, @JsonKey(name: 'receipt_no')  String? receiptNo, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'applied_paise')  int appliedPaise, @JsonKey(name: 'credit_paise')  int creditPaise, @JsonKey(name: 'balance_paise')  int balancePaise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
return $default(_that.paymentId,_that.receiptNo,_that.amountPaise,_that.appliedPaise,_that.creditPaise,_that.balancePaise);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'payment_id')  String paymentId, @JsonKey(name: 'receipt_no')  String? receiptNo, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'applied_paise')  int appliedPaise, @JsonKey(name: 'credit_paise')  int creditPaise, @JsonKey(name: 'balance_paise')  int balancePaise)  $default,) {final _that = this;
switch (_that) {
case _PaymentResult():
return $default(_that.paymentId,_that.receiptNo,_that.amountPaise,_that.appliedPaise,_that.creditPaise,_that.balancePaise);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'payment_id')  String paymentId, @JsonKey(name: 'receipt_no')  String? receiptNo, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'applied_paise')  int appliedPaise, @JsonKey(name: 'credit_paise')  int creditPaise, @JsonKey(name: 'balance_paise')  int balancePaise)?  $default,) {final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
return $default(_that.paymentId,_that.receiptNo,_that.amountPaise,_that.appliedPaise,_that.creditPaise,_that.balancePaise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentResult implements PaymentResult {
  const _PaymentResult({@JsonKey(name: 'payment_id') required this.paymentId, @JsonKey(name: 'receipt_no') this.receiptNo, @JsonKey(name: 'amount_paise') required this.amountPaise, @JsonKey(name: 'applied_paise') this.appliedPaise = 0, @JsonKey(name: 'credit_paise') this.creditPaise = 0, @JsonKey(name: 'balance_paise') this.balancePaise = 0});
  factory _PaymentResult.fromJson(Map<String, dynamic> json) => _$PaymentResultFromJson(json);

@override@JsonKey(name: 'payment_id') final  String paymentId;
@override@JsonKey(name: 'receipt_no') final  String? receiptNo;
@override@JsonKey(name: 'amount_paise') final  int amountPaise;
@override@JsonKey(name: 'applied_paise') final  int appliedPaise;
@override@JsonKey(name: 'credit_paise') final  int creditPaise;
@override@JsonKey(name: 'balance_paise') final  int balancePaise;

/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentResultCopyWith<_PaymentResult> get copyWith => __$PaymentResultCopyWithImpl<_PaymentResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentResult&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.amountPaise, amountPaise) || other.amountPaise == amountPaise)&&(identical(other.appliedPaise, appliedPaise) || other.appliedPaise == appliedPaise)&&(identical(other.creditPaise, creditPaise) || other.creditPaise == creditPaise)&&(identical(other.balancePaise, balancePaise) || other.balancePaise == balancePaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,paymentId,receiptNo,amountPaise,appliedPaise,creditPaise,balancePaise);
}

@override
String toString() {
    return 'PaymentResult(paymentId: $paymentId, receiptNo: $receiptNo, amountPaise: $amountPaise, appliedPaise: $appliedPaise, creditPaise: $creditPaise, balancePaise: $balancePaise)';
}


}

/// @nodoc
abstract mixin class _$PaymentResultCopyWith<$Res> implements $PaymentResultCopyWith<$Res> {
  factory _$PaymentResultCopyWith(_PaymentResult value, $Res Function(_PaymentResult) _then) = __$PaymentResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'payment_id') String paymentId,@JsonKey(name: 'receipt_no') String? receiptNo,@JsonKey(name: 'amount_paise') int amountPaise,@JsonKey(name: 'applied_paise') int appliedPaise,@JsonKey(name: 'credit_paise') int creditPaise,@JsonKey(name: 'balance_paise') int balancePaise
});




}
/// @nodoc
class __$PaymentResultCopyWithImpl<$Res>
    implements _$PaymentResultCopyWith<$Res> {
  __$PaymentResultCopyWithImpl(this._self, this._then);

  final _PaymentResult _self;
  final $Res Function(_PaymentResult) _then;

/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentId = null,Object? receiptNo = freezed,Object? amountPaise = null,Object? appliedPaise = null,Object? creditPaise = null,Object? balancePaise = null,}) {
  return _then(_PaymentResult(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,receiptNo: freezed == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String?,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,appliedPaise: null == appliedPaise ? _self.appliedPaise : appliedPaise // ignore: cast_nullable_to_non_nullable
as int,creditPaise: null == creditPaise ? _self.creditPaise : creditPaise // ignore: cast_nullable_to_non_nullable
as int,balancePaise: null == balancePaise ? _self.balancePaise : balancePaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DaySummary {

@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day; int get cash; int get upi; int get card; int get bank; int get online; int get credit; int get total; int get count; bool get closed;@JsonKey(name: 'closed_at') DateTime? get closedAt;@JsonKey(name: 'counted_cash') int? get countedCash; int? get difference;
/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DaySummaryCopyWith<DaySummary> get copyWith => _$DaySummaryCopyWithImpl<DaySummary>(this as DaySummary, _$identity);

  /// Serializes this DaySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DaySummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaySummary&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.cash, _this.cash) || other.cash == _this.cash)&&(identical(other.upi, _this.upi) || other.upi == _this.upi)&&(identical(other.card, _this.card) || other.card == _this.card)&&(identical(other.bank, _this.bank) || other.bank == _this.bank)&&(identical(other.online, _this.online) || other.online == _this.online)&&(identical(other.credit, _this.credit) || other.credit == _this.credit)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.closed, _this.closed) || other.closed == _this.closed)&&(identical(other.closedAt, _this.closedAt) || other.closedAt == _this.closedAt)&&(identical(other.countedCash, _this.countedCash) || other.countedCash == _this.countedCash)&&(identical(other.difference, _this.difference) || other.difference == _this.difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DaySummary;
  return Object.hash(runtimeType,_this.day,_this.cash,_this.upi,_this.card,_this.bank,_this.online,_this.credit,_this.total,_this.count,_this.closed,_this.closedAt,_this.countedCash,_this.difference);
}

@override
String toString() {
  final _this = this as DaySummary;
  return 'DaySummary(day: ${_this.day}, cash: ${_this.cash}, upi: ${_this.upi}, card: ${_this.card}, bank: ${_this.bank}, online: ${_this.online}, credit: ${_this.credit}, total: ${_this.total}, count: ${_this.count}, closed: ${_this.closed}, closedAt: ${_this.closedAt}, countedCash: ${_this.countedCash}, difference: ${_this.difference})';
}


}

/// @nodoc
abstract mixin class $DaySummaryCopyWith<$Res>  {
  factory $DaySummaryCopyWith(DaySummary value, $Res Function(DaySummary) _then) = _$DaySummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, int cash, int upi, int card, int bank, int online, int credit, int total, int count, bool closed,@JsonKey(name: 'closed_at') DateTime? closedAt,@JsonKey(name: 'counted_cash') int? countedCash, int? difference
});




}
/// @nodoc
class _$DaySummaryCopyWithImpl<$Res>
    implements $DaySummaryCopyWith<$Res> {
  _$DaySummaryCopyWithImpl(this._self, this._then);

  final DaySummary _self;
  final $Res Function(DaySummary) _then;

/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = freezed,Object? cash = null,Object? upi = null,Object? card = null,Object? bank = null,Object? online = null,Object? credit = null,Object? total = null,Object? count = null,Object? closed = null,Object? closedAt = freezed,Object? countedCash = freezed,Object? difference = freezed,}) {
  return _then(DaySummary(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as int,upi: null == upi ? _self.upi : upi // ignore: cast_nullable_to_non_nullable
as int,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as int,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as int,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as int,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,countedCash: freezed == countedCash ? _self.countedCash : countedCash // ignore: cast_nullable_to_non_nullable
as int?,difference: freezed == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DaySummary].
extension DaySummaryPatterns on DaySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DaySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DaySummary value)  $default,){
final _that = this;
switch (_that) {
case _DaySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DaySummary value)?  $default,){
final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int cash,  int upi,  int card,  int bank,  int online,  int credit,  int total,  int count,  bool closed, @JsonKey(name: 'closed_at')  DateTime? closedAt, @JsonKey(name: 'counted_cash')  int? countedCash,  int? difference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
return $default(_that.day,_that.cash,_that.upi,_that.card,_that.bank,_that.online,_that.credit,_that.total,_that.count,_that.closed,_that.closedAt,_that.countedCash,_that.difference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int cash,  int upi,  int card,  int bank,  int online,  int credit,  int total,  int count,  bool closed, @JsonKey(name: 'closed_at')  DateTime? closedAt, @JsonKey(name: 'counted_cash')  int? countedCash,  int? difference)  $default,) {final _that = this;
switch (_that) {
case _DaySummary():
return $default(_that.day,_that.cash,_that.upi,_that.card,_that.bank,_that.online,_that.credit,_that.total,_that.count,_that.closed,_that.closedAt,_that.countedCash,_that.difference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int cash,  int upi,  int card,  int bank,  int online,  int credit,  int total,  int count,  bool closed, @JsonKey(name: 'closed_at')  DateTime? closedAt, @JsonKey(name: 'counted_cash')  int? countedCash,  int? difference)?  $default,) {final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
return $default(_that.day,_that.cash,_that.upi,_that.card,_that.bank,_that.online,_that.credit,_that.total,_that.count,_that.closed,_that.closedAt,_that.countedCash,_that.difference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DaySummary implements DaySummary {
  const _DaySummary({@JsonKey(fromJson: _date, toJson: _dateOut) this.day, this.cash = 0, this.upi = 0, this.card = 0, this.bank = 0, this.online = 0, this.credit = 0, this.total = 0, this.count = 0, this.closed = false, @JsonKey(name: 'closed_at') this.closedAt, @JsonKey(name: 'counted_cash') this.countedCash, this.difference});
  factory _DaySummary.fromJson(Map<String, dynamic> json) => _$DaySummaryFromJson(json);

@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override@JsonKey() final  int cash;
@override@JsonKey() final  int upi;
@override@JsonKey() final  int card;
@override@JsonKey() final  int bank;
@override@JsonKey() final  int online;
@override@JsonKey() final  int credit;
@override@JsonKey() final  int total;
@override@JsonKey() final  int count;
@override@JsonKey() final  bool closed;
@override@JsonKey(name: 'closed_at') final  DateTime? closedAt;
@override@JsonKey(name: 'counted_cash') final  int? countedCash;
@override final  int? difference;

/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DaySummaryCopyWith<_DaySummary> get copyWith => __$DaySummaryCopyWithImpl<_DaySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DaySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaySummary&&(identical(other.day, day) || other.day == day)&&(identical(other.cash, cash) || other.cash == cash)&&(identical(other.upi, upi) || other.upi == upi)&&(identical(other.card, card) || other.card == card)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.online, online) || other.online == online)&&(identical(other.credit, credit) || other.credit == credit)&&(identical(other.total, total) || other.total == total)&&(identical(other.count, count) || other.count == count)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.countedCash, countedCash) || other.countedCash == countedCash)&&(identical(other.difference, difference) || other.difference == difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,cash,upi,card,bank,online,credit,total,count,closed,closedAt,countedCash,difference);
}

@override
String toString() {
    return 'DaySummary(day: $day, cash: $cash, upi: $upi, card: $card, bank: $bank, online: $online, credit: $credit, total: $total, count: $count, closed: $closed, closedAt: $closedAt, countedCash: $countedCash, difference: $difference)';
}


}

/// @nodoc
abstract mixin class _$DaySummaryCopyWith<$Res> implements $DaySummaryCopyWith<$Res> {
  factory _$DaySummaryCopyWith(_DaySummary value, $Res Function(_DaySummary) _then) = __$DaySummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, int cash, int upi, int card, int bank, int online, int credit, int total, int count, bool closed,@JsonKey(name: 'closed_at') DateTime? closedAt,@JsonKey(name: 'counted_cash') int? countedCash, int? difference
});




}
/// @nodoc
class __$DaySummaryCopyWithImpl<$Res>
    implements _$DaySummaryCopyWith<$Res> {
  __$DaySummaryCopyWithImpl(this._self, this._then);

  final _DaySummary _self;
  final $Res Function(_DaySummary) _then;

/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = freezed,Object? cash = null,Object? upi = null,Object? card = null,Object? bank = null,Object? online = null,Object? credit = null,Object? total = null,Object? count = null,Object? closed = null,Object? closedAt = freezed,Object? countedCash = freezed,Object? difference = freezed,}) {
  return _then(_DaySummary(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as int,upi: null == upi ? _self.upi : upi // ignore: cast_nullable_to_non_nullable
as int,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as int,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as int,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as int,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,countedCash: freezed == countedCash ? _self.countedCash : countedCash // ignore: cast_nullable_to_non_nullable
as int?,difference: freezed == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DayClose {

 String get id;@JsonKey(name: 'staff_id') String get staffId;@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day;@JsonKey(name: 'total_paise') int get totalPaise;@JsonKey(name: 'cash_paise') int get cashPaise;@JsonKey(name: 'counted_cash_paise') int get countedCashPaise;@JsonKey(name: 'difference_paise') int get differencePaise;@JsonKey(name: 'payments_count') int get paymentsCount; String? get note;@JsonKey(name: 'closed_at') DateTime get closedAt;@JsonKey(name: 'reopened_at') DateTime? get reopenedAt;@JsonKey(name: 'staff_name') String? get staffName;
/// Create a copy of DayClose
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayCloseCopyWith<DayClose> get copyWith => _$DayCloseCopyWithImpl<DayClose>(this as DayClose, _$identity);

  /// Serializes this DayClose to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DayClose;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayClose&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.staffId, _this.staffId) || other.staffId == _this.staffId)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.totalPaise, _this.totalPaise) || other.totalPaise == _this.totalPaise)&&(identical(other.cashPaise, _this.cashPaise) || other.cashPaise == _this.cashPaise)&&(identical(other.countedCashPaise, _this.countedCashPaise) || other.countedCashPaise == _this.countedCashPaise)&&(identical(other.differencePaise, _this.differencePaise) || other.differencePaise == _this.differencePaise)&&(identical(other.paymentsCount, _this.paymentsCount) || other.paymentsCount == _this.paymentsCount)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.closedAt, _this.closedAt) || other.closedAt == _this.closedAt)&&(identical(other.reopenedAt, _this.reopenedAt) || other.reopenedAt == _this.reopenedAt)&&(identical(other.staffName, _this.staffName) || other.staffName == _this.staffName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DayClose;
  return Object.hash(runtimeType,_this.id,_this.staffId,_this.day,_this.totalPaise,_this.cashPaise,_this.countedCashPaise,_this.differencePaise,_this.paymentsCount,_this.note,_this.closedAt,_this.reopenedAt,_this.staffName);
}

@override
String toString() {
  final _this = this as DayClose;
  return 'DayClose(id: ${_this.id}, staffId: ${_this.staffId}, day: ${_this.day}, totalPaise: ${_this.totalPaise}, cashPaise: ${_this.cashPaise}, countedCashPaise: ${_this.countedCashPaise}, differencePaise: ${_this.differencePaise}, paymentsCount: ${_this.paymentsCount}, note: ${_this.note}, closedAt: ${_this.closedAt}, reopenedAt: ${_this.reopenedAt}, staffName: ${_this.staffName})';
}


}

/// @nodoc
abstract mixin class $DayCloseCopyWith<$Res>  {
  factory $DayCloseCopyWith(DayClose value, $Res Function(DayClose) _then) = _$DayCloseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'staff_id') String staffId,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'total_paise') int totalPaise,@JsonKey(name: 'cash_paise') int cashPaise,@JsonKey(name: 'counted_cash_paise') int countedCashPaise,@JsonKey(name: 'difference_paise') int differencePaise,@JsonKey(name: 'payments_count') int paymentsCount, String? note,@JsonKey(name: 'closed_at') DateTime closedAt,@JsonKey(name: 'reopened_at') DateTime? reopenedAt,@JsonKey(name: 'staff_name') String? staffName
});




}
/// @nodoc
class _$DayCloseCopyWithImpl<$Res>
    implements $DayCloseCopyWith<$Res> {
  _$DayCloseCopyWithImpl(this._self, this._then);

  final DayClose _self;
  final $Res Function(DayClose) _then;

/// Create a copy of DayClose
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? staffId = null,Object? day = freezed,Object? totalPaise = null,Object? cashPaise = null,Object? countedCashPaise = null,Object? differencePaise = null,Object? paymentsCount = null,Object? note = freezed,Object? closedAt = null,Object? reopenedAt = freezed,Object? staffName = freezed,}) {
  return _then(DayClose(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,staffId: null == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,totalPaise: null == totalPaise ? _self.totalPaise : totalPaise // ignore: cast_nullable_to_non_nullable
as int,cashPaise: null == cashPaise ? _self.cashPaise : cashPaise // ignore: cast_nullable_to_non_nullable
as int,countedCashPaise: null == countedCashPaise ? _self.countedCashPaise : countedCashPaise // ignore: cast_nullable_to_non_nullable
as int,differencePaise: null == differencePaise ? _self.differencePaise : differencePaise // ignore: cast_nullable_to_non_nullable
as int,paymentsCount: null == paymentsCount ? _self.paymentsCount : paymentsCount // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,closedAt: null == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reopenedAt: freezed == reopenedAt ? _self.reopenedAt : reopenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,staffName: freezed == staffName ? _self.staffName : staffName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DayClose].
extension DayClosePatterns on DayClose {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayClose value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayClose() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayClose value)  $default,){
final _that = this;
switch (_that) {
case _DayClose():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayClose value)?  $default,){
final _that = this;
switch (_that) {
case _DayClose() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'staff_id')  String staffId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'total_paise')  int totalPaise, @JsonKey(name: 'cash_paise')  int cashPaise, @JsonKey(name: 'counted_cash_paise')  int countedCashPaise, @JsonKey(name: 'difference_paise')  int differencePaise, @JsonKey(name: 'payments_count')  int paymentsCount,  String? note, @JsonKey(name: 'closed_at')  DateTime closedAt, @JsonKey(name: 'reopened_at')  DateTime? reopenedAt, @JsonKey(name: 'staff_name')  String? staffName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayClose() when $default != null:
return $default(_that.id,_that.staffId,_that.day,_that.totalPaise,_that.cashPaise,_that.countedCashPaise,_that.differencePaise,_that.paymentsCount,_that.note,_that.closedAt,_that.reopenedAt,_that.staffName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'staff_id')  String staffId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'total_paise')  int totalPaise, @JsonKey(name: 'cash_paise')  int cashPaise, @JsonKey(name: 'counted_cash_paise')  int countedCashPaise, @JsonKey(name: 'difference_paise')  int differencePaise, @JsonKey(name: 'payments_count')  int paymentsCount,  String? note, @JsonKey(name: 'closed_at')  DateTime closedAt, @JsonKey(name: 'reopened_at')  DateTime? reopenedAt, @JsonKey(name: 'staff_name')  String? staffName)  $default,) {final _that = this;
switch (_that) {
case _DayClose():
return $default(_that.id,_that.staffId,_that.day,_that.totalPaise,_that.cashPaise,_that.countedCashPaise,_that.differencePaise,_that.paymentsCount,_that.note,_that.closedAt,_that.reopenedAt,_that.staffName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'staff_id')  String staffId, @JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day, @JsonKey(name: 'total_paise')  int totalPaise, @JsonKey(name: 'cash_paise')  int cashPaise, @JsonKey(name: 'counted_cash_paise')  int countedCashPaise, @JsonKey(name: 'difference_paise')  int differencePaise, @JsonKey(name: 'payments_count')  int paymentsCount,  String? note, @JsonKey(name: 'closed_at')  DateTime closedAt, @JsonKey(name: 'reopened_at')  DateTime? reopenedAt, @JsonKey(name: 'staff_name')  String? staffName)?  $default,) {final _that = this;
switch (_that) {
case _DayClose() when $default != null:
return $default(_that.id,_that.staffId,_that.day,_that.totalPaise,_that.cashPaise,_that.countedCashPaise,_that.differencePaise,_that.paymentsCount,_that.note,_that.closedAt,_that.reopenedAt,_that.staffName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayClose extends DayClose {
  const _DayClose({required this.id, @JsonKey(name: 'staff_id') required this.staffId, @JsonKey(fromJson: _date, toJson: _dateOut) required this.day, @JsonKey(name: 'total_paise') this.totalPaise = 0, @JsonKey(name: 'cash_paise') this.cashPaise = 0, @JsonKey(name: 'counted_cash_paise') this.countedCashPaise = 0, @JsonKey(name: 'difference_paise') this.differencePaise = 0, @JsonKey(name: 'payments_count') this.paymentsCount = 0, this.note, @JsonKey(name: 'closed_at') required this.closedAt, @JsonKey(name: 'reopened_at') this.reopenedAt, @JsonKey(name: 'staff_name') this.staffName}): super._();
  factory _DayClose.fromJson(Map<String, dynamic> json) => _$DayCloseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'staff_id') final  String staffId;
@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override@JsonKey(name: 'total_paise') final  int totalPaise;
@override@JsonKey(name: 'cash_paise') final  int cashPaise;
@override@JsonKey(name: 'counted_cash_paise') final  int countedCashPaise;
@override@JsonKey(name: 'difference_paise') final  int differencePaise;
@override@JsonKey(name: 'payments_count') final  int paymentsCount;
@override final  String? note;
@override@JsonKey(name: 'closed_at') final  DateTime closedAt;
@override@JsonKey(name: 'reopened_at') final  DateTime? reopenedAt;
@override@JsonKey(name: 'staff_name') final  String? staffName;

/// Create a copy of DayClose
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayCloseCopyWith<_DayClose> get copyWith => __$DayCloseCopyWithImpl<_DayClose>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayCloseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayClose&&(identical(other.id, id) || other.id == id)&&(identical(other.staffId, staffId) || other.staffId == staffId)&&(identical(other.day, day) || other.day == day)&&(identical(other.totalPaise, totalPaise) || other.totalPaise == totalPaise)&&(identical(other.cashPaise, cashPaise) || other.cashPaise == cashPaise)&&(identical(other.countedCashPaise, countedCashPaise) || other.countedCashPaise == countedCashPaise)&&(identical(other.differencePaise, differencePaise) || other.differencePaise == differencePaise)&&(identical(other.paymentsCount, paymentsCount) || other.paymentsCount == paymentsCount)&&(identical(other.note, note) || other.note == note)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.reopenedAt, reopenedAt) || other.reopenedAt == reopenedAt)&&(identical(other.staffName, staffName) || other.staffName == staffName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,staffId,day,totalPaise,cashPaise,countedCashPaise,differencePaise,paymentsCount,note,closedAt,reopenedAt,staffName);
}

@override
String toString() {
    return 'DayClose(id: $id, staffId: $staffId, day: $day, totalPaise: $totalPaise, cashPaise: $cashPaise, countedCashPaise: $countedCashPaise, differencePaise: $differencePaise, paymentsCount: $paymentsCount, note: $note, closedAt: $closedAt, reopenedAt: $reopenedAt, staffName: $staffName)';
}


}

/// @nodoc
abstract mixin class _$DayCloseCopyWith<$Res> implements $DayCloseCopyWith<$Res> {
  factory _$DayCloseCopyWith(_DayClose value, $Res Function(_DayClose) _then) = __$DayCloseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'staff_id') String staffId,@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,@JsonKey(name: 'total_paise') int totalPaise,@JsonKey(name: 'cash_paise') int cashPaise,@JsonKey(name: 'counted_cash_paise') int countedCashPaise,@JsonKey(name: 'difference_paise') int differencePaise,@JsonKey(name: 'payments_count') int paymentsCount, String? note,@JsonKey(name: 'closed_at') DateTime closedAt,@JsonKey(name: 'reopened_at') DateTime? reopenedAt,@JsonKey(name: 'staff_name') String? staffName
});




}
/// @nodoc
class __$DayCloseCopyWithImpl<$Res>
    implements _$DayCloseCopyWith<$Res> {
  __$DayCloseCopyWithImpl(this._self, this._then);

  final _DayClose _self;
  final $Res Function(_DayClose) _then;

/// Create a copy of DayClose
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? staffId = null,Object? day = freezed,Object? totalPaise = null,Object? cashPaise = null,Object? countedCashPaise = null,Object? differencePaise = null,Object? paymentsCount = null,Object? note = freezed,Object? closedAt = null,Object? reopenedAt = freezed,Object? staffName = freezed,}) {
  return _then(_DayClose(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,staffId: null == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,totalPaise: null == totalPaise ? _self.totalPaise : totalPaise // ignore: cast_nullable_to_non_nullable
as int,cashPaise: null == cashPaise ? _self.cashPaise : cashPaise // ignore: cast_nullable_to_non_nullable
as int,countedCashPaise: null == countedCashPaise ? _self.countedCashPaise : countedCashPaise // ignore: cast_nullable_to_non_nullable
as int,differencePaise: null == differencePaise ? _self.differencePaise : differencePaise // ignore: cast_nullable_to_non_nullable
as int,paymentsCount: null == paymentsCount ? _self.paymentsCount : paymentsCount // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,closedAt: null == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reopenedAt: freezed == reopenedAt ? _self.reopenedAt : reopenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,staffName: freezed == staffName ? _self.staffName : staffName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DuesSummary {

@JsonKey(name: 'overdue_count') int get overdueCount;@JsonKey(name: 'overdue_paise') int get overduePaise;@JsonKey(name: 'due_count') int get dueCount;@JsonKey(name: 'due_paise') int get duePaise;@JsonKey(name: 'pending_claims') int get pendingClaims;
/// Create a copy of DuesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuesSummaryCopyWith<DuesSummary> get copyWith => _$DuesSummaryCopyWithImpl<DuesSummary>(this as DuesSummary, _$identity);

  /// Serializes this DuesSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuesSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuesSummary&&(identical(other.overdueCount, _this.overdueCount) || other.overdueCount == _this.overdueCount)&&(identical(other.overduePaise, _this.overduePaise) || other.overduePaise == _this.overduePaise)&&(identical(other.dueCount, _this.dueCount) || other.dueCount == _this.dueCount)&&(identical(other.duePaise, _this.duePaise) || other.duePaise == _this.duePaise)&&(identical(other.pendingClaims, _this.pendingClaims) || other.pendingClaims == _this.pendingClaims));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuesSummary;
  return Object.hash(runtimeType,_this.overdueCount,_this.overduePaise,_this.dueCount,_this.duePaise,_this.pendingClaims);
}

@override
String toString() {
  final _this = this as DuesSummary;
  return 'DuesSummary(overdueCount: ${_this.overdueCount}, overduePaise: ${_this.overduePaise}, dueCount: ${_this.dueCount}, duePaise: ${_this.duePaise}, pendingClaims: ${_this.pendingClaims})';
}


}

/// @nodoc
abstract mixin class $DuesSummaryCopyWith<$Res>  {
  factory $DuesSummaryCopyWith(DuesSummary value, $Res Function(DuesSummary) _then) = _$DuesSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'overdue_count') int overdueCount,@JsonKey(name: 'overdue_paise') int overduePaise,@JsonKey(name: 'due_count') int dueCount,@JsonKey(name: 'due_paise') int duePaise,@JsonKey(name: 'pending_claims') int pendingClaims
});




}
/// @nodoc
class _$DuesSummaryCopyWithImpl<$Res>
    implements $DuesSummaryCopyWith<$Res> {
  _$DuesSummaryCopyWithImpl(this._self, this._then);

  final DuesSummary _self;
  final $Res Function(DuesSummary) _then;

/// Create a copy of DuesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? overdueCount = null,Object? overduePaise = null,Object? dueCount = null,Object? duePaise = null,Object? pendingClaims = null,}) {
  return _then(DuesSummary(
overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,overduePaise: null == overduePaise ? _self.overduePaise : overduePaise // ignore: cast_nullable_to_non_nullable
as int,dueCount: null == dueCount ? _self.dueCount : dueCount // ignore: cast_nullable_to_non_nullable
as int,duePaise: null == duePaise ? _self.duePaise : duePaise // ignore: cast_nullable_to_non_nullable
as int,pendingClaims: null == pendingClaims ? _self.pendingClaims : pendingClaims // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DuesSummary].
extension DuesSummaryPatterns on DuesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuesSummary value)  $default,){
final _that = this;
switch (_that) {
case _DuesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DuesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'overdue_count')  int overdueCount, @JsonKey(name: 'overdue_paise')  int overduePaise, @JsonKey(name: 'due_count')  int dueCount, @JsonKey(name: 'due_paise')  int duePaise, @JsonKey(name: 'pending_claims')  int pendingClaims)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuesSummary() when $default != null:
return $default(_that.overdueCount,_that.overduePaise,_that.dueCount,_that.duePaise,_that.pendingClaims);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'overdue_count')  int overdueCount, @JsonKey(name: 'overdue_paise')  int overduePaise, @JsonKey(name: 'due_count')  int dueCount, @JsonKey(name: 'due_paise')  int duePaise, @JsonKey(name: 'pending_claims')  int pendingClaims)  $default,) {final _that = this;
switch (_that) {
case _DuesSummary():
return $default(_that.overdueCount,_that.overduePaise,_that.dueCount,_that.duePaise,_that.pendingClaims);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'overdue_count')  int overdueCount, @JsonKey(name: 'overdue_paise')  int overduePaise, @JsonKey(name: 'due_count')  int dueCount, @JsonKey(name: 'due_paise')  int duePaise, @JsonKey(name: 'pending_claims')  int pendingClaims)?  $default,) {final _that = this;
switch (_that) {
case _DuesSummary() when $default != null:
return $default(_that.overdueCount,_that.overduePaise,_that.dueCount,_that.duePaise,_that.pendingClaims);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuesSummary implements DuesSummary {
  const _DuesSummary({@JsonKey(name: 'overdue_count') this.overdueCount = 0, @JsonKey(name: 'overdue_paise') this.overduePaise = 0, @JsonKey(name: 'due_count') this.dueCount = 0, @JsonKey(name: 'due_paise') this.duePaise = 0, @JsonKey(name: 'pending_claims') this.pendingClaims = 0});
  factory _DuesSummary.fromJson(Map<String, dynamic> json) => _$DuesSummaryFromJson(json);

@override@JsonKey(name: 'overdue_count') final  int overdueCount;
@override@JsonKey(name: 'overdue_paise') final  int overduePaise;
@override@JsonKey(name: 'due_count') final  int dueCount;
@override@JsonKey(name: 'due_paise') final  int duePaise;
@override@JsonKey(name: 'pending_claims') final  int pendingClaims;

/// Create a copy of DuesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuesSummaryCopyWith<_DuesSummary> get copyWith => __$DuesSummaryCopyWithImpl<_DuesSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuesSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuesSummary&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.overduePaise, overduePaise) || other.overduePaise == overduePaise)&&(identical(other.dueCount, dueCount) || other.dueCount == dueCount)&&(identical(other.duePaise, duePaise) || other.duePaise == duePaise)&&(identical(other.pendingClaims, pendingClaims) || other.pendingClaims == pendingClaims));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,overdueCount,overduePaise,dueCount,duePaise,pendingClaims);
}

@override
String toString() {
    return 'DuesSummary(overdueCount: $overdueCount, overduePaise: $overduePaise, dueCount: $dueCount, duePaise: $duePaise, pendingClaims: $pendingClaims)';
}


}

/// @nodoc
abstract mixin class _$DuesSummaryCopyWith<$Res> implements $DuesSummaryCopyWith<$Res> {
  factory _$DuesSummaryCopyWith(_DuesSummary value, $Res Function(_DuesSummary) _then) = __$DuesSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'overdue_count') int overdueCount,@JsonKey(name: 'overdue_paise') int overduePaise,@JsonKey(name: 'due_count') int dueCount,@JsonKey(name: 'due_paise') int duePaise,@JsonKey(name: 'pending_claims') int pendingClaims
});




}
/// @nodoc
class __$DuesSummaryCopyWithImpl<$Res>
    implements _$DuesSummaryCopyWith<$Res> {
  __$DuesSummaryCopyWithImpl(this._self, this._then);

  final _DuesSummary _self;
  final $Res Function(_DuesSummary) _then;

/// Create a copy of DuesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? overdueCount = null,Object? overduePaise = null,Object? dueCount = null,Object? duePaise = null,Object? pendingClaims = null,}) {
  return _then(_DuesSummary(
overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,overduePaise: null == overduePaise ? _self.overduePaise : overduePaise // ignore: cast_nullable_to_non_nullable
as int,dueCount: null == dueCount ? _self.dueCount : dueCount // ignore: cast_nullable_to_non_nullable
as int,duePaise: null == duePaise ? _self.duePaise : duePaise // ignore: cast_nullable_to_non_nullable
as int,pendingClaims: null == pendingClaims ? _self.pendingClaims : pendingClaims // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DayAmount {

@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? get day; int get paise;
/// Create a copy of DayAmount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayAmountCopyWith<DayAmount> get copyWith => _$DayAmountCopyWithImpl<DayAmount>(this as DayAmount, _$identity);

  /// Serializes this DayAmount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DayAmount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayAmount&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.paise, _this.paise) || other.paise == _this.paise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DayAmount;
  return Object.hash(runtimeType,_this.day,_this.paise);
}

@override
String toString() {
  final _this = this as DayAmount;
  return 'DayAmount(day: ${_this.day}, paise: ${_this.paise})';
}


}

/// @nodoc
abstract mixin class $DayAmountCopyWith<$Res>  {
  factory $DayAmountCopyWith(DayAmount value, $Res Function(DayAmount) _then) = _$DayAmountCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, int paise
});




}
/// @nodoc
class _$DayAmountCopyWithImpl<$Res>
    implements $DayAmountCopyWith<$Res> {
  _$DayAmountCopyWithImpl(this._self, this._then);

  final DayAmount _self;
  final $Res Function(DayAmount) _then;

/// Create a copy of DayAmount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = freezed,Object? paise = null,}) {
  return _then(DayAmount(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,paise: null == paise ? _self.paise : paise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DayAmount].
extension DayAmountPatterns on DayAmount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayAmount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayAmount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayAmount value)  $default,){
final _that = this;
switch (_that) {
case _DayAmount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayAmount value)?  $default,){
final _that = this;
switch (_that) {
case _DayAmount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int paise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayAmount() when $default != null:
return $default(_that.day,_that.paise);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int paise)  $default,) {final _that = this;
switch (_that) {
case _DayAmount():
return $default(_that.day,_that.paise);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _date, toJson: _dateOut)  DateTime? day,  int paise)?  $default,) {final _that = this;
switch (_that) {
case _DayAmount() when $default != null:
return $default(_that.day,_that.paise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayAmount implements DayAmount {
  const _DayAmount({@JsonKey(fromJson: _date, toJson: _dateOut) required this.day, this.paise = 0});
  factory _DayAmount.fromJson(Map<String, dynamic> json) => _$DayAmountFromJson(json);

@override@JsonKey(fromJson: _date, toJson: _dateOut) final  DateTime? day;
@override@JsonKey() final  int paise;

/// Create a copy of DayAmount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayAmountCopyWith<_DayAmount> get copyWith => __$DayAmountCopyWithImpl<_DayAmount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayAmountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayAmount&&(identical(other.day, day) || other.day == day)&&(identical(other.paise, paise) || other.paise == paise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,paise);
}

@override
String toString() {
    return 'DayAmount(day: $day, paise: $paise)';
}


}

/// @nodoc
abstract mixin class _$DayAmountCopyWith<$Res> implements $DayAmountCopyWith<$Res> {
  factory _$DayAmountCopyWith(_DayAmount value, $Res Function(_DayAmount) _then) = __$DayAmountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day, int paise
});




}
/// @nodoc
class __$DayAmountCopyWithImpl<$Res>
    implements _$DayAmountCopyWith<$Res> {
  __$DayAmountCopyWithImpl(this._self, this._then);

  final _DayAmount _self;
  final $Res Function(_DayAmount) _then;

/// Create a copy of DayAmount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = freezed,Object? paise = null,}) {
  return _then(_DayAmount(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,paise: null == paise ? _self.paise : paise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CollectionsSummary {

 int get collected;@JsonKey(name: 'by_mode') Map<String, int> get byMode;@JsonKey(name: 'by_day') List<DayAmount> get byDay; int get invoiced; int get outstanding; int get refunds; int get expenses;@JsonKey(name: 'payments_count') int get paymentsCount;
/// Create a copy of CollectionsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionsSummaryCopyWith<CollectionsSummary> get copyWith => _$CollectionsSummaryCopyWithImpl<CollectionsSummary>(this as CollectionsSummary, _$identity);

  /// Serializes this CollectionsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CollectionsSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionsSummary&&(identical(other.collected, _this.collected) || other.collected == _this.collected)&&const DeepCollectionEquality().equals(other.byMode, _this.byMode)&&const DeepCollectionEquality().equals(other.byDay, _this.byDay)&&(identical(other.invoiced, _this.invoiced) || other.invoiced == _this.invoiced)&&(identical(other.outstanding, _this.outstanding) || other.outstanding == _this.outstanding)&&(identical(other.refunds, _this.refunds) || other.refunds == _this.refunds)&&(identical(other.expenses, _this.expenses) || other.expenses == _this.expenses)&&(identical(other.paymentsCount, _this.paymentsCount) || other.paymentsCount == _this.paymentsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CollectionsSummary;
  return Object.hash(runtimeType,_this.collected,const DeepCollectionEquality().hash(_this.byMode),const DeepCollectionEquality().hash(_this.byDay),_this.invoiced,_this.outstanding,_this.refunds,_this.expenses,_this.paymentsCount);
}

@override
String toString() {
  final _this = this as CollectionsSummary;
  return 'CollectionsSummary(collected: ${_this.collected}, byMode: ${_this.byMode}, byDay: ${_this.byDay}, invoiced: ${_this.invoiced}, outstanding: ${_this.outstanding}, refunds: ${_this.refunds}, expenses: ${_this.expenses}, paymentsCount: ${_this.paymentsCount})';
}


}

/// @nodoc
abstract mixin class $CollectionsSummaryCopyWith<$Res>  {
  factory $CollectionsSummaryCopyWith(CollectionsSummary value, $Res Function(CollectionsSummary) _then) = _$CollectionsSummaryCopyWithImpl;
@useResult
$Res call({
 int collected,@JsonKey(name: 'by_mode') Map<String, int> byMode,@JsonKey(name: 'by_day') List<DayAmount> byDay, int invoiced, int outstanding, int refunds, int expenses,@JsonKey(name: 'payments_count') int paymentsCount
});




}
/// @nodoc
class _$CollectionsSummaryCopyWithImpl<$Res>
    implements $CollectionsSummaryCopyWith<$Res> {
  _$CollectionsSummaryCopyWithImpl(this._self, this._then);

  final CollectionsSummary _self;
  final $Res Function(CollectionsSummary) _then;

/// Create a copy of CollectionsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? collected = null,Object? byMode = null,Object? byDay = null,Object? invoiced = null,Object? outstanding = null,Object? refunds = null,Object? expenses = null,Object? paymentsCount = null,}) {
  return _then(CollectionsSummary(
collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,byMode: null == byMode ? _self.byMode : byMode // ignore: cast_nullable_to_non_nullable
as Map<String, int>,byDay: null == byDay ? _self.byDay : byDay // ignore: cast_nullable_to_non_nullable
as List<DayAmount>,invoiced: null == invoiced ? _self.invoiced : invoiced // ignore: cast_nullable_to_non_nullable
as int,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as int,refunds: null == refunds ? _self.refunds : refunds // ignore: cast_nullable_to_non_nullable
as int,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as int,paymentsCount: null == paymentsCount ? _self.paymentsCount : paymentsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionsSummary].
extension CollectionsSummaryPatterns on CollectionsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionsSummary value)  $default,){
final _that = this;
switch (_that) {
case _CollectionsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int collected, @JsonKey(name: 'by_mode')  Map<String, int> byMode, @JsonKey(name: 'by_day')  List<DayAmount> byDay,  int invoiced,  int outstanding,  int refunds,  int expenses, @JsonKey(name: 'payments_count')  int paymentsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionsSummary() when $default != null:
return $default(_that.collected,_that.byMode,_that.byDay,_that.invoiced,_that.outstanding,_that.refunds,_that.expenses,_that.paymentsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int collected, @JsonKey(name: 'by_mode')  Map<String, int> byMode, @JsonKey(name: 'by_day')  List<DayAmount> byDay,  int invoiced,  int outstanding,  int refunds,  int expenses, @JsonKey(name: 'payments_count')  int paymentsCount)  $default,) {final _that = this;
switch (_that) {
case _CollectionsSummary():
return $default(_that.collected,_that.byMode,_that.byDay,_that.invoiced,_that.outstanding,_that.refunds,_that.expenses,_that.paymentsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int collected, @JsonKey(name: 'by_mode')  Map<String, int> byMode, @JsonKey(name: 'by_day')  List<DayAmount> byDay,  int invoiced,  int outstanding,  int refunds,  int expenses, @JsonKey(name: 'payments_count')  int paymentsCount)?  $default,) {final _that = this;
switch (_that) {
case _CollectionsSummary() when $default != null:
return $default(_that.collected,_that.byMode,_that.byDay,_that.invoiced,_that.outstanding,_that.refunds,_that.expenses,_that.paymentsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionsSummary implements CollectionsSummary {
  const _CollectionsSummary({this.collected = 0, @JsonKey(name: 'by_mode')  Map<String, int> byMode = const <String, int>{}, @JsonKey(name: 'by_day')  List<DayAmount> byDay = const [], this.invoiced = 0, this.outstanding = 0, this.refunds = 0, this.expenses = 0, @JsonKey(name: 'payments_count') this.paymentsCount = 0}): _byMode = byMode,_byDay = byDay;
  factory _CollectionsSummary.fromJson(Map<String, dynamic> json) => _$CollectionsSummaryFromJson(json);

@override@JsonKey() final  int collected;
 final  Map<String, int> _byMode;
@override@JsonKey(name: 'by_mode') Map<String, int> get byMode {
  if (_byMode is EqualUnmodifiableMapView) return _byMode;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byMode);
}

 final  List<DayAmount> _byDay;
@override@JsonKey(name: 'by_day') List<DayAmount> get byDay {
  if (_byDay is EqualUnmodifiableListView) return _byDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byDay);
}

@override@JsonKey() final  int invoiced;
@override@JsonKey() final  int outstanding;
@override@JsonKey() final  int refunds;
@override@JsonKey() final  int expenses;
@override@JsonKey(name: 'payments_count') final  int paymentsCount;

/// Create a copy of CollectionsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionsSummaryCopyWith<_CollectionsSummary> get copyWith => __$CollectionsSummaryCopyWithImpl<_CollectionsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionsSummary&&(identical(other.collected, collected) || other.collected == collected)&&const DeepCollectionEquality().equals(other.byMode, _byMode)&&const DeepCollectionEquality().equals(other.byDay, _byDay)&&(identical(other.invoiced, invoiced) || other.invoiced == invoiced)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.refunds, refunds) || other.refunds == refunds)&&(identical(other.expenses, expenses) || other.expenses == expenses)&&(identical(other.paymentsCount, paymentsCount) || other.paymentsCount == paymentsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,collected,const DeepCollectionEquality().hash(_byMode),const DeepCollectionEquality().hash(_byDay),invoiced,outstanding,refunds,expenses,paymentsCount);
}

@override
String toString() {
    return 'CollectionsSummary(collected: $collected, byMode: $byMode, byDay: $byDay, invoiced: $invoiced, outstanding: $outstanding, refunds: $refunds, expenses: $expenses, paymentsCount: $paymentsCount)';
}


}

/// @nodoc
abstract mixin class _$CollectionsSummaryCopyWith<$Res> implements $CollectionsSummaryCopyWith<$Res> {
  factory _$CollectionsSummaryCopyWith(_CollectionsSummary value, $Res Function(_CollectionsSummary) _then) = __$CollectionsSummaryCopyWithImpl;
@override @useResult
$Res call({
 int collected,@JsonKey(name: 'by_mode') Map<String, int> byMode,@JsonKey(name: 'by_day') List<DayAmount> byDay, int invoiced, int outstanding, int refunds, int expenses,@JsonKey(name: 'payments_count') int paymentsCount
});




}
/// @nodoc
class __$CollectionsSummaryCopyWithImpl<$Res>
    implements _$CollectionsSummaryCopyWith<$Res> {
  __$CollectionsSummaryCopyWithImpl(this._self, this._then);

  final _CollectionsSummary _self;
  final $Res Function(_CollectionsSummary) _then;

/// Create a copy of CollectionsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? collected = null,Object? byMode = null,Object? byDay = null,Object? invoiced = null,Object? outstanding = null,Object? refunds = null,Object? expenses = null,Object? paymentsCount = null,}) {
  return _then(_CollectionsSummary(
collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as int,byMode: null == byMode ? _self._byMode : byMode // ignore: cast_nullable_to_non_nullable
as Map<String, int>,byDay: null == byDay ? _self._byDay : byDay // ignore: cast_nullable_to_non_nullable
as List<DayAmount>,invoiced: null == invoiced ? _self.invoiced : invoiced // ignore: cast_nullable_to_non_nullable
as int,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as int,refunds: null == refunds ? _self.refunds : refunds // ignore: cast_nullable_to_non_nullable
as int,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as int,paymentsCount: null == paymentsCount ? _self.paymentsCount : paymentsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DueReminder {

@JsonKey(name: 'invoice_id') String get invoiceId;@JsonKey(name: 'invoice_no') String get invoiceNo;@JsonKey(name: 'member_id') String? get memberId;@JsonKey(name: 'member_name') String get memberName;@JsonKey(name: 'member_phone') String? get memberPhone;@JsonKey(name: 'balance_paise') int get balancePaise;@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) DateTime? get nextDueDate;@JsonKey(name: 'days_to_due') int get daysToDue;
/// Create a copy of DueReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DueReminderCopyWith<DueReminder> get copyWith => _$DueReminderCopyWithImpl<DueReminder>(this as DueReminder, _$identity);

  /// Serializes this DueReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DueReminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DueReminder&&(identical(other.invoiceId, _this.invoiceId) || other.invoiceId == _this.invoiceId)&&(identical(other.invoiceNo, _this.invoiceNo) || other.invoiceNo == _this.invoiceNo)&&(identical(other.memberId, _this.memberId) || other.memberId == _this.memberId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.memberPhone, _this.memberPhone) || other.memberPhone == _this.memberPhone)&&(identical(other.balancePaise, _this.balancePaise) || other.balancePaise == _this.balancePaise)&&(identical(other.nextDueDate, _this.nextDueDate) || other.nextDueDate == _this.nextDueDate)&&(identical(other.daysToDue, _this.daysToDue) || other.daysToDue == _this.daysToDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DueReminder;
  return Object.hash(runtimeType,_this.invoiceId,_this.invoiceNo,_this.memberId,_this.memberName,_this.memberPhone,_this.balancePaise,_this.nextDueDate,_this.daysToDue);
}

@override
String toString() {
  final _this = this as DueReminder;
  return 'DueReminder(invoiceId: ${_this.invoiceId}, invoiceNo: ${_this.invoiceNo}, memberId: ${_this.memberId}, memberName: ${_this.memberName}, memberPhone: ${_this.memberPhone}, balancePaise: ${_this.balancePaise}, nextDueDate: ${_this.nextDueDate}, daysToDue: ${_this.daysToDue})';
}


}

/// @nodoc
abstract mixin class $DueReminderCopyWith<$Res>  {
  factory $DueReminderCopyWith(DueReminder value, $Res Function(DueReminder) _then) = _$DueReminderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'invoice_id') String invoiceId,@JsonKey(name: 'invoice_no') String invoiceNo,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'member_phone') String? memberPhone,@JsonKey(name: 'balance_paise') int balancePaise,@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) DateTime? nextDueDate,@JsonKey(name: 'days_to_due') int daysToDue
});




}
/// @nodoc
class _$DueReminderCopyWithImpl<$Res>
    implements $DueReminderCopyWith<$Res> {
  _$DueReminderCopyWithImpl(this._self, this._then);

  final DueReminder _self;
  final $Res Function(DueReminder) _then;

/// Create a copy of DueReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invoiceId = null,Object? invoiceNo = null,Object? memberId = freezed,Object? memberName = null,Object? memberPhone = freezed,Object? balancePaise = null,Object? nextDueDate = freezed,Object? daysToDue = null,}) {
  return _then(DueReminder(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,invoiceNo: null == invoiceNo ? _self.invoiceNo : invoiceNo // ignore: cast_nullable_to_non_nullable
as String,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberPhone: freezed == memberPhone ? _self.memberPhone : memberPhone // ignore: cast_nullable_to_non_nullable
as String?,balancePaise: null == balancePaise ? _self.balancePaise : balancePaise // ignore: cast_nullable_to_non_nullable
as int,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysToDue: null == daysToDue ? _self.daysToDue : daysToDue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DueReminder].
extension DueReminderPatterns on DueReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DueReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DueReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DueReminder value)  $default,){
final _that = this;
switch (_that) {
case _DueReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DueReminder value)?  $default,){
final _that = this;
switch (_that) {
case _DueReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'invoice_id')  String invoiceId, @JsonKey(name: 'invoice_no')  String invoiceNo, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'member_phone')  String? memberPhone, @JsonKey(name: 'balance_paise')  int balancePaise, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut)  DateTime? nextDueDate, @JsonKey(name: 'days_to_due')  int daysToDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DueReminder() when $default != null:
return $default(_that.invoiceId,_that.invoiceNo,_that.memberId,_that.memberName,_that.memberPhone,_that.balancePaise,_that.nextDueDate,_that.daysToDue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'invoice_id')  String invoiceId, @JsonKey(name: 'invoice_no')  String invoiceNo, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'member_phone')  String? memberPhone, @JsonKey(name: 'balance_paise')  int balancePaise, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut)  DateTime? nextDueDate, @JsonKey(name: 'days_to_due')  int daysToDue)  $default,) {final _that = this;
switch (_that) {
case _DueReminder():
return $default(_that.invoiceId,_that.invoiceNo,_that.memberId,_that.memberName,_that.memberPhone,_that.balancePaise,_that.nextDueDate,_that.daysToDue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'invoice_id')  String invoiceId, @JsonKey(name: 'invoice_no')  String invoiceNo, @JsonKey(name: 'member_id')  String? memberId, @JsonKey(name: 'member_name')  String memberName, @JsonKey(name: 'member_phone')  String? memberPhone, @JsonKey(name: 'balance_paise')  int balancePaise, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut)  DateTime? nextDueDate, @JsonKey(name: 'days_to_due')  int daysToDue)?  $default,) {final _that = this;
switch (_that) {
case _DueReminder() when $default != null:
return $default(_that.invoiceId,_that.invoiceNo,_that.memberId,_that.memberName,_that.memberPhone,_that.balancePaise,_that.nextDueDate,_that.daysToDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DueReminder implements DueReminder {
  const _DueReminder({@JsonKey(name: 'invoice_id') required this.invoiceId, @JsonKey(name: 'invoice_no') required this.invoiceNo, @JsonKey(name: 'member_id') this.memberId, @JsonKey(name: 'member_name') required this.memberName, @JsonKey(name: 'member_phone') this.memberPhone, @JsonKey(name: 'balance_paise') required this.balancePaise, @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) required this.nextDueDate, @JsonKey(name: 'days_to_due') required this.daysToDue});
  factory _DueReminder.fromJson(Map<String, dynamic> json) => _$DueReminderFromJson(json);

@override@JsonKey(name: 'invoice_id') final  String invoiceId;
@override@JsonKey(name: 'invoice_no') final  String invoiceNo;
@override@JsonKey(name: 'member_id') final  String? memberId;
@override@JsonKey(name: 'member_name') final  String memberName;
@override@JsonKey(name: 'member_phone') final  String? memberPhone;
@override@JsonKey(name: 'balance_paise') final  int balancePaise;
@override@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) final  DateTime? nextDueDate;
@override@JsonKey(name: 'days_to_due') final  int daysToDue;

/// Create a copy of DueReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DueReminderCopyWith<_DueReminder> get copyWith => __$DueReminderCopyWithImpl<_DueReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DueReminderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DueReminder&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.invoiceNo, invoiceNo) || other.invoiceNo == invoiceNo)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.memberPhone, memberPhone) || other.memberPhone == memberPhone)&&(identical(other.balancePaise, balancePaise) || other.balancePaise == balancePaise)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.daysToDue, daysToDue) || other.daysToDue == daysToDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,invoiceId,invoiceNo,memberId,memberName,memberPhone,balancePaise,nextDueDate,daysToDue);
}

@override
String toString() {
    return 'DueReminder(invoiceId: $invoiceId, invoiceNo: $invoiceNo, memberId: $memberId, memberName: $memberName, memberPhone: $memberPhone, balancePaise: $balancePaise, nextDueDate: $nextDueDate, daysToDue: $daysToDue)';
}


}

/// @nodoc
abstract mixin class _$DueReminderCopyWith<$Res> implements $DueReminderCopyWith<$Res> {
  factory _$DueReminderCopyWith(_DueReminder value, $Res Function(_DueReminder) _then) = __$DueReminderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'invoice_id') String invoiceId,@JsonKey(name: 'invoice_no') String invoiceNo,@JsonKey(name: 'member_id') String? memberId,@JsonKey(name: 'member_name') String memberName,@JsonKey(name: 'member_phone') String? memberPhone,@JsonKey(name: 'balance_paise') int balancePaise,@JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) DateTime? nextDueDate,@JsonKey(name: 'days_to_due') int daysToDue
});




}
/// @nodoc
class __$DueReminderCopyWithImpl<$Res>
    implements _$DueReminderCopyWith<$Res> {
  __$DueReminderCopyWithImpl(this._self, this._then);

  final _DueReminder _self;
  final $Res Function(_DueReminder) _then;

/// Create a copy of DueReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invoiceId = null,Object? invoiceNo = null,Object? memberId = freezed,Object? memberName = null,Object? memberPhone = freezed,Object? balancePaise = null,Object? nextDueDate = freezed,Object? daysToDue = null,}) {
  return _then(_DueReminder(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,invoiceNo: null == invoiceNo ? _self.invoiceNo : invoiceNo // ignore: cast_nullable_to_non_nullable
as String,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberPhone: freezed == memberPhone ? _self.memberPhone : memberPhone // ignore: cast_nullable_to_non_nullable
as String?,balancePaise: null == balancePaise ? _self.balancePaise : balancePaise // ignore: cast_nullable_to_non_nullable
as int,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,daysToDue: null == daysToDue ? _self.daysToDue : daysToDue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Expense {

 String? get id; String get category;@JsonKey(name: 'amount_paise') int get amountPaise;@JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut) DateTime? get spentOn; String? get note;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Expense;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.amountPaise, _this.amountPaise) || other.amountPaise == _this.amountPaise)&&(identical(other.spentOn, _this.spentOn) || other.spentOn == _this.spentOn)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Expense;
  return Object.hash(runtimeType,_this.id,_this.category,_this.amountPaise,_this.spentOn,_this.note);
}

@override
String toString() {
  final _this = this as Expense;
  return 'Expense(id: ${_this.id}, category: ${_this.category}, amountPaise: ${_this.amountPaise}, spentOn: ${_this.spentOn}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String? id, String category,@JsonKey(name: 'amount_paise') int amountPaise,@JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut) DateTime? spentOn, String? note
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? category = null,Object? amountPaise = null,Object? spentOn = freezed,Object? note = freezed,}) {
  return _then(Expense(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,spentOn: freezed == spentOn ? _self.spentOn : spentOn // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String category, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut)  DateTime? spentOn,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.category,_that.amountPaise,_that.spentOn,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String category, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut)  DateTime? spentOn,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.category,_that.amountPaise,_that.spentOn,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String category, @JsonKey(name: 'amount_paise')  int amountPaise, @JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut)  DateTime? spentOn,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.category,_that.amountPaise,_that.spentOn,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense implements Expense {
  const _Expense({this.id, required this.category, @JsonKey(name: 'amount_paise') required this.amountPaise, @JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut) required this.spentOn, this.note});
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  String? id;
@override final  String category;
@override@JsonKey(name: 'amount_paise') final  int amountPaise;
@override@JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut) final  DateTime? spentOn;
@override final  String? note;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.amountPaise, amountPaise) || other.amountPaise == amountPaise)&&(identical(other.spentOn, spentOn) || other.spentOn == spentOn)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,category,amountPaise,spentOn,note);
}

@override
String toString() {
    return 'Expense(id: $id, category: $category, amountPaise: $amountPaise, spentOn: $spentOn, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String? id, String category,@JsonKey(name: 'amount_paise') int amountPaise,@JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut) DateTime? spentOn, String? note
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? category = null,Object? amountPaise = null,Object? spentOn = freezed,Object? note = freezed,}) {
  return _then(_Expense(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amountPaise: null == amountPaise ? _self.amountPaise : amountPaise // ignore: cast_nullable_to_non_nullable
as int,spentOn: freezed == spentOn ? _self.spentOn : spentOn // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
