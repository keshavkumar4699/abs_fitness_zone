import 'package:freezed_annotation/freezed_annotation.dart';

part 'food.freezed.dart';
part 'food.g.dart';

double _num(Object? v) => v == null ? 0 : (v as num).toDouble();

/// Food groups (6.1), in the order the library lists them.
const kFoodCategories = [
  'grains',
  'pulses',
  'vegetables',
  'fruits',
  'dairy',
  'eggs',
  'meat_fish',
  'nuts_seeds',
  'snacks',
  'sweets',
  'drinks',
  'fats_oils',
  'condiments',
  'supplements',
];

/// Serving units people use: 1 katori, 1 roti, 1 glass, 100 g…
const kServingUnits = [
  'katori',
  'roti',
  'piece',
  'glass',
  'cup',
  'bowl',
  'plate',
  'slice',
  'tbsp',
  'tsp',
  'scoop',
  'handful',
  'g',
  'ml',
];

const kVegTypes = ['vegan', 'veg', 'egg', 'non_veg'];
const kAllergens = ['dairy', 'gluten', 'nuts', 'peanut', 'soy', 'egg', 'fish', 'shellfish', 'sesame'];

/// One thing to buy for one serving (6.12): 30 g atta, 1 egg, 250 ml milk.
@freezed
abstract class GroceryPart with _$GroceryPart {
  const factory GroceryPart({
    required String item,
    @JsonKey(fromJson: _num) required double qty,
    @Default('g') String unit,
  }) = _GroceryPart;

  factory GroceryPart.fromJson(Map<String, dynamic> json) => _$GroceryPartFromJson(json);
}

/// Calories and macros, per serving or summed.
class Macros {
  const Macros(this.kcal, this.protein, this.carbs, this.fat, [this.fibre = 0]);

  static const zero = Macros(0, 0, 0, 0);

  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final double fibre;

  Macros operator +(Macros o) =>
      Macros(kcal + o.kcal, protein + o.protein, carbs + o.carbs, fat + o.fat, fibre + o.fibre);
  Macros operator *(num f) => Macros(kcal * f, protein * f, carbs * f, fat * f, fibre * f);

  @override
  bool operator ==(Object other) =>
      other is Macros &&
      other.kcal == kcal &&
      other.protein == protein &&
      other.carbs == carbs &&
      other.fat == fat &&
      other.fibre == fibre;

  @override
  int get hashCode => Object.hash(kcal, protein, carbs, fat, fibre);

  @override
  String toString() =>
      'Macros(${kcal.round()} kcal, P ${protein.toStringAsFixed(1)}, C ${carbs.toStringAsFixed(1)}, F ${fat.toStringAsFixed(1)})';
}

@freezed
abstract class Food with _$Food {
  const Food._();

  const factory Food({
    required String id,
    @JsonKey(name: 'seed_key') String? seedKey,
    required String name,
    @JsonKey(name: 'local_name') String? localName,
    required String category,
    @JsonKey(name: 'serving_unit') required String servingUnit,
    @JsonKey(name: 'serving_g', fromJson: _num) required double servingG,
    @JsonKey(name: 'qty_step', fromJson: _num) @Default(0.5) double qtyStep,
    @JsonKey(fromJson: _num) required double kcal,
    @JsonKey(name: 'protein_g', fromJson: _num) @Default(0) double protein,
    @JsonKey(name: 'carbs_g', fromJson: _num) @Default(0) double carbs,
    @JsonKey(name: 'fat_g', fromJson: _num) @Default(0) double fat,
    @JsonKey(name: 'fibre_g', fromJson: _num) @Default(0) double fibre,
    @JsonKey(name: 'veg_type') required String vegType,
    @JsonKey(name: 'jain_ok') @Default(false) bool jainOk,
    @Default(<String>[]) List<String> allergens,
    @Default(<GroceryPart>[]) List<GroceryPart> grocery,
    @Default('custom') String source,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'archived_at') DateTime? archivedAt,
  }) = _Food;

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  bool get isCustom => source == 'custom';
  bool get isReviewed => reviewedAt != null;
  bool get isArchived => archivedAt != null;

  /// Weighed foods are planned in grams (25 g steps), the rest in servings.
  bool get isWeighed => servingUnit == 'g' || servingUnit == 'ml';

  Macros get macros => Macros(kcal, protein, carbs, fat, fibre);

  /// The editable fields, as the foods table takes them.
  Map<String, dynamic> toRow() => {
    'name': name.trim(),
    'local_name': localName?.trim().isEmpty ?? true ? null : localName!.trim(),
    'category': category,
    'serving_unit': servingUnit,
    'serving_g': servingG,
    'qty_step': qtyStep,
    'kcal': kcal,
    'protein_g': protein,
    'carbs_g': carbs,
    'fat_g': fat,
    'fibre_g': fibre,
    'veg_type': vegType,
    'jain_ok': jainOk,
    'allergens': allergens,
    'grocery': [for (final g in grocery) g.toJson()],
  };
}

/// The food database, indexed for instant search (works offline).
class FoodIndex {
  FoodIndex(List<Food> all)
    : all = List.unmodifiable(all.where((f) => !f.isArchived).toList()..sort((a, b) => a.name.compareTo(b.name))),
      byId = {for (final f in all) f.id: f} {
    for (final f in this.all) {
      _names[f.id] = _fold(f.name);
      if (f.localName != null) _local[f.id] = f.localName!.toLowerCase();
    }
  }

  /// Active foods, A–Z.
  final List<Food> all;

  /// Every food, including removed ones (old plans may use them).
  final Map<String, Food> byId;
  final _names = <String, String>{};
  final _local = <String, String>{};

  static final _nonWord = RegExp(r'[^a-z0-9]+');
  static String _fold(String s) => s.toLowerCase().replaceAll(_nonWord, ' ').trim();

  Food? operator [](String id) => byId[id];
  int get length => all.length;
  int get unreviewed => all.where((f) => !f.isReviewed).length;

  /// Filters and ranks: name starts with the query, then a word starts with
  /// it, then it appears anywhere (English or Hindi name).
  List<Food> query({
    String search = '',
    String? category,
    String? dietPref,
    bool unreviewedOnly = false,
    bool customOnly = false,
  }) {
    final q = _fold(search);
    final qLocal = search.trim().toLowerCase();
    final ranked = <(int, Food)>[];
    for (final f in all) {
      if (category != null && f.category != category) continue;
      if (dietPref != null && !fitsPreference(f, dietPref)) continue;
      if (unreviewedOnly && f.isReviewed) continue;
      if (customOnly && !f.isCustom) continue;
      var rank = 3;
      if (q.isNotEmpty || qLocal.isNotEmpty) {
        final name = _names[f.id]!;
        final local = _local[f.id];
        if (q.isNotEmpty && name.startsWith(q)) {
          rank = 0;
        } else if (q.isNotEmpty && name.contains(' $q')) {
          rank = 1;
        } else if ((q.isNotEmpty && name.contains(q)) ||
            (local != null && qLocal.isNotEmpty && local.contains(qLocal))) {
          rank = 2;
        } else {
          continue;
        }
      }
      ranked.add((rank, f));
    }
    ranked.sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.name.compareTo(b.$2.name));
    return [for (final r in ranked) r.$2];
  }
}

/// Does a food suit a diet preference (6.4)?
bool fitsPreference(Food f, String? pref) => switch (pref) {
  'veg' => f.vegType == 'vegan' || f.vegType == 'veg',
  'eggetarian' => f.vegType != 'non_veg',
  'vegan' => f.vegType == 'vegan',
  'jain' => (f.vegType == 'vegan' || f.vegType == 'veg') && f.jainOk,
  _ => true,
};
