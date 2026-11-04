// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroceryPart _$GroceryPartFromJson(Map<String, dynamic> json) =>
    _GroceryPart(item: json['item'] as String, qty: _num(json['qty']), unit: json['unit'] as String? ?? 'g');

Map<String, dynamic> _$GroceryPartToJson(_GroceryPart instance) => <String, dynamic>{
  'item': instance.item,
  'qty': instance.qty,
  'unit': instance.unit,
};

_Food _$FoodFromJson(Map<String, dynamic> json) => _Food(
  id: json['id'] as String,
  seedKey: json['seed_key'] as String?,
  name: json['name'] as String,
  localName: json['local_name'] as String?,
  category: json['category'] as String,
  servingUnit: json['serving_unit'] as String,
  servingG: _num(json['serving_g']),
  qtyStep: json['qty_step'] == null ? 0.5 : _num(json['qty_step']),
  kcal: _num(json['kcal']),
  protein: json['protein_g'] == null ? 0 : _num(json['protein_g']),
  carbs: json['carbs_g'] == null ? 0 : _num(json['carbs_g']),
  fat: json['fat_g'] == null ? 0 : _num(json['fat_g']),
  fibre: json['fibre_g'] == null ? 0 : _num(json['fibre_g']),
  vegType: json['veg_type'] as String,
  jainOk: json['jain_ok'] as bool? ?? false,
  allergens: (json['allergens'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  grocery:
      (json['grocery'] as List<dynamic>?)?.map((e) => GroceryPart.fromJson(e as Map<String, dynamic>)).toList() ??
      const <GroceryPart>[],
  source: json['source'] as String? ?? 'custom',
  createdBy: json['created_by'] as String?,
  reviewedAt: json['reviewed_at'] == null ? null : DateTime.parse(json['reviewed_at'] as String),
  updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
  archivedAt: json['archived_at'] == null ? null : DateTime.parse(json['archived_at'] as String),
);

Map<String, dynamic> _$FoodToJson(_Food instance) => <String, dynamic>{
  'id': instance.id,
  'seed_key': instance.seedKey,
  'name': instance.name,
  'local_name': instance.localName,
  'category': instance.category,
  'serving_unit': instance.servingUnit,
  'serving_g': instance.servingG,
  'qty_step': instance.qtyStep,
  'kcal': instance.kcal,
  'protein_g': instance.protein,
  'carbs_g': instance.carbs,
  'fat_g': instance.fat,
  'fibre_g': instance.fibre,
  'veg_type': instance.vegType,
  'jain_ok': instance.jainOk,
  'allergens': instance.allergens,
  'grocery': instance.grocery.map((e) => e.toJson()).toList(),
  'source': instance.source,
  'created_by': instance.createdBy,
  'reviewed_at': instance.reviewedAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'archived_at': instance.archivedAt?.toIso8601String(),
};
