#!/usr/bin/env python3
"""Adds USDA FoodData Central items (public domain) to the food database (F6
6.1, "supplemented by USDA FoodData Central items").

1. Download a FoodData Central CSV release (SR Legacy or Foundation Foods)
   from https://fdc.nal.usda.gov/download-datasets and unzip it.
2. List the foods you want, one FDC id per line, in a text file (find ids by
   searching on the FoodData Central site). A line can add a short name after
   the id: "171287 Chicken breast, roasted".
3. Run the script; it writes SQL you paste into the Supabase SQL editor (or
   save as a migration):

       python3 scripts/import_usda_foods.py ~/Downloads/FoodData_Central_sr_legacy_csv ids.txt > usda_foods.sql

Every food is per 100 g, weighed in 25 g steps, tagged source 'usda' with its
FDC id, and left "not reviewed" so the gym's dietitian checks it (and its veg
type, Jain suitability and allergens, which USDA doesn't give and the script
only guesses from the food group).

    python3 scripts/import_usda_foods.py --self-test
"""
import csv
import io
import json
import pathlib
import sys
import uuid

# FoodData Central nutrient ids. Energy is 1008 (kcal); Foundation Foods may
# only have the Atwater energies 2047 / 2048.
ENERGY, ENERGY_ATWATER, ENERGY_SPECIFIC = "1008", "2047", "2048"
PROTEIN, FAT, CARBS, FIBRE = "1003", "1004", "1005", "1079"
NS = uuid.UUID("6f1d4c2e-6a5b-4f7e-9c1a-0a85f0d1b4e7")

GROUPS = [  # (words in the USDA food group, our category, veg type, allergens)
    ("poultry", "meat_fish", "non_veg", []),
    ("beef", "meat_fish", "non_veg", []),
    ("pork", "meat_fish", "non_veg", []),
    ("lamb", "meat_fish", "non_veg", []),
    ("sausages", "meat_fish", "non_veg", []),
    ("finfish", "meat_fish", "non_veg", ["fish"]),
    ("dairy and egg", "dairy", "veg", ["dairy"]),
    ("nut and seed", "nuts_seeds", "vegan", ["nuts"]),
    ("legume", "pulses", "vegan", []),
    ("cereal grains", "grains", "vegan", ["gluten"]),
    ("baked", "grains", "veg", ["gluten"]),
    ("breakfast cereals", "grains", "vegan", ["gluten"]),
    ("vegetables", "vegetables", "vegan", []),
    ("fruits", "fruits", "vegan", []),
    ("fats and oils", "fats_oils", "vegan", []),
    ("beverages", "drinks", "vegan", []),
    ("sweets", "sweets", "veg", []),
    ("snacks", "snacks", "vegan", []),
    ("spices", "condiments", "vegan", []),
]


def classify(group, description):
    g, d = group.lower(), description.lower()
    for words, category, veg, allergens in GROUPS:
        if words in g:
            allergens = list(allergens)
            if category == "dairy" and "egg" in d and "eggplant" not in d:
                category, veg, allergens = "eggs", "egg", ["egg"]
            if "peanut" in d:
                allergens = [a for a in allergens if a != "nuts"] + ["peanut"]
            if any(w in d for w in ("shrimp", "prawn", "crab", "lobster")):
                allergens = ["shellfish"]
            return category, veg, allergens
    return "snacks", "vegan", []


def read_csv(folder, name):
    path = pathlib.Path(folder) / name
    with path.open(encoding="utf-8") as f:
        return list(csv.DictReader(f))


def load(folder):
    foods = {r["fdc_id"]: r for r in read_csv(folder, "food.csv")}
    groups = {}
    try:
        groups = {r["id"]: r["description"] for r in read_csv(folder, "food_category.csv")}
    except FileNotFoundError:
        pass
    nutrients = {}
    for r in read_csv(folder, "food_nutrient.csv"):
        nutrients.setdefault(r["fdc_id"], {})[r["nutrient_id"]] = float(r["amount"] or 0)
    return foods, groups, nutrients


def q(v):
    return "null" if v is None else "'" + str(v).replace("'", "''") + "'"


def rows(foods, groups, nutrients, wanted):
    out = []
    for fdc_id, name in wanted:
        food = foods.get(fdc_id)
        if food is None:
            print(f"-- skipped {fdc_id}: not in this download", file=sys.stderr)
            continue
        n = nutrients.get(fdc_id, {})
        kcal = n.get(ENERGY) or n.get(ENERGY_ATWATER) or n.get(ENERGY_SPECIFIC)
        if kcal is None:
            print(f"-- skipped {fdc_id}: no energy value", file=sys.stderr)
            continue
        description = food["description"]
        category, veg, allergens = classify(groups.get(food.get("food_category_id", ""), ""), description)
        label = (name or description)[:80]
        out.append(dict(
            id=str(uuid.uuid5(NS, "usda-" + fdc_id)), key="usda-" + fdc_id, name=label, category=category,
            kcal=round(kcal, 1), protein=round(n.get(PROTEIN, 0), 1), carbs=round(n.get(CARBS, 0), 1),
            fat=round(n.get(FAT, 0), 1), fibre=round(n.get(FIBRE, 0), 1), veg=veg, allergens=allergens,
            grocery=[{"item": label, "qty": 100, "unit": "g"}], ref=fdc_id))
    return out


def to_sql(items):
    lines = [
        "-- USDA FoodData Central items (public domain), made by scripts/import_usda_foods.py.",
        "-- Values per 100 g. Review each one in the app (Training → Diet → Foods → Not reviewed).",
        "insert into public.foods (id, seed_key, name, category, serving_unit, serving_g, qty_step, kcal, protein_g,",
        "                          carbs_g, fat_g, fibre_g, veg_type, jain_ok, allergens, grocery, source, source_ref) values",
    ]
    values = []
    for x in items:
        allergens = "'{}'::text[]" if not x["allergens"] else "array[" + ", ".join(q(a) for a in x["allergens"]) + "]::text[]"
        grocery = q(json.dumps(x["grocery"], separators=(",", ":"))) + "::jsonb"
        values.append(
            f"  ({q(x['id'])}, {q(x['key'])}, {q(x['name'])}, {q(x['category'])}, 'g', 100, 0.25, {x['kcal']}, "
            f"{x['protein']}, {x['carbs']}, {x['fat']}, {x['fibre']}, {q(x['veg'])}, false, {allergens}, {grocery}, "
            f"'usda', {q(x['ref'])})")
    lines.append(",\n".join(values))
    lines.append("on conflict (seed_key) do nothing;")
    return "\n".join(lines) + "\n"


def parse_ids(text):
    wanted = []
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        fdc_id, _, name = line.partition(" ")
        wanted.append((fdc_id, name.strip() or None))
    return wanted


def self_test():
    import tempfile
    with tempfile.TemporaryDirectory() as d:
        p = pathlib.Path(d)
        (p / "food.csv").write_text(
            '"fdc_id","data_type","description","food_category_id","publication_date"\n'
            '"171077","sr_legacy_food","Chicken, broilers or fryers, breast, meat only, cooked, roasted","5","2019-04-01"\n'
            '"173424","sr_legacy_food","Egg, whole, cooked, hard-boiled","1","2019-04-01"\n'
            '"172430","sr_legacy_food","Peanut butter, smooth style, without salt","12","2019-04-01"\n',
            encoding="utf-8")
        (p / "food_category.csv").write_text(
            '"id","code","description"\n"1","0100","Dairy and Egg Products"\n"5","0500","Poultry Products"\n'
            '"12","1200","Nut and Seed Products"\n', encoding="utf-8")
        (p / "food_nutrient.csv").write_text(
            '"id","fdc_id","nutrient_id","amount"\n'
            '"1","171077","1008","165"\n"2","171077","1003","31.02"\n"3","171077","1004","3.57"\n"4","171077","1005","0"\n'
            '"5","173424","1008","155"\n"6","173424","1003","12.58"\n"7","173424","1004","10.61"\n"8","173424","1005","1.12"\n'
            '"9","172430","2047","597"\n"10","172430","1003","22.21"\n"11","172430","1004","51.36"\n'
            '"12","172430","1005","22.31"\n"13","172430","1079","5"\n', encoding="utf-8")
        items = rows(*load(p), parse_ids("171077 Chicken breast, roasted\n173424\n# a comment\n172430\n999999\n"))
    assert [x["category"] for x in items] == ["meat_fish", "eggs", "nuts_seeds"], items
    assert [x["veg"] for x in items] == ["non_veg", "egg", "vegan"]
    assert items[0]["name"] == "Chicken breast, roasted" and items[0]["kcal"] == 165 and items[0]["protein"] == 31.0
    assert items[1]["allergens"] == ["egg"] and items[2]["allergens"] == ["peanut"]
    assert items[2]["kcal"] == 597 and items[2]["fibre"] == 5
    sql = to_sql(items)
    assert sql.count("'usda'") == 3 and "on conflict (seed_key) do nothing" in sql
    assert "'Chicken breast, roasted'" in sql and "'171077'" in sql
    print("self-test passed")


def main():
    if "--self-test" in sys.argv:
        self_test()
        return
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        sys.exit(2)
    folder, ids_file = sys.argv[1], sys.argv[2]
    wanted = parse_ids(pathlib.Path(ids_file).read_text(encoding="utf-8"))
    items = rows(*load(folder), wanted)
    if not items:
        sys.exit("no foods found")
    sys.stdout.write(to_sql(items))
    print(f"-- {len(items)} foods", file=sys.stderr)


if __name__ == "__main__":
    main()
