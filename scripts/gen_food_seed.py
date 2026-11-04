#!/usr/bin/env python3
"""Generates supabase/migrations/20261107000001_m4_food_seed.sql from the
gym's food list in supabase/seed/foods.csv plus the starter diet templates
below. Re-run after changing either; the output is committed.

    python3 scripts/gen_food_seed.py            # write the migration
    python3 scripts/gen_food_seed.py --report   # show template totals

The food values are typical home-style recipes and portions. The spec (6.1)
asks the gym's dietitian or trainer to review them before launch: the app
shows every seeded food as "not reviewed" until someone checks it.
"""
import csv
import pathlib
import sys
import uuid

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC = ROOT / "supabase/seed/foods.csv"
OUT = ROOT / "supabase/migrations/20261107000001_m4_food_seed.sql"
# The same starter templates as JSON, for the app's tests.
OUT_JSON = ROOT / "supabase/seed/diet_templates.json"

# Seeded ids are stable (uuid5 of the key) so templates, tests and later
# migrations can refer to a food by key.
NS = uuid.UUID("6f1d4c2e-6a5b-4f7e-9c1a-0a85f0d1b4e7")

CATEGORIES = {"grains", "pulses", "vegetables", "fruits", "dairy", "eggs", "meat_fish", "nuts_seeds", "snacks",
              "sweets", "drinks", "fats_oils", "condiments", "supplements"}
UNITS = {"g", "ml", "katori", "roti", "piece", "glass", "cup", "bowl", "plate", "slice", "tbsp", "tsp", "scoop",
         "handful"}
VEG = {"vegan", "veg", "egg", "non_veg"}
ALLERGENS = {"dairy", "gluten", "nuts", "peanut", "soy", "egg", "fish", "shellfish", "sesame"}


def food_id(key):
    return str(uuid.uuid5(NS, key))


def load_foods():
    rows = list(csv.DictReader(SRC.open(encoding="utf-8")))
    foods = {}
    for r in rows:
        k = r["key"]
        assert k not in foods, f"duplicate key {k}"
        assert r["category"] in CATEGORIES, (k, r["category"])
        assert r["unit"] in UNITS, (k, r["unit"])
        assert r["veg_type"] in VEG, (k, r["veg_type"])
        allergens = [a for a in r["allergens"].split(";") if a]
        assert set(allergens) <= ALLERGENS, (k, allergens)
        kcal, p, c, f = (float(r[x]) for x in ("kcal", "protein_g", "carbs_g", "fat_g"))
        assert abs(4 * p + 4 * c + 9 * f - kcal) <= max(0.15 * kcal, 8), f"{k}: kcal doesn't match macros"
        grocery = []
        for part in filter(None, r["grocery"].split(";")):
            name, amount = part.rsplit(":", 1)
            unit = "pc" if amount.endswith("pc") else "ml" if amount.endswith("ml") else "g"
            grocery.append({"item": name.strip(), "qty": float(amount.rstrip("pcml")), "unit": unit})
        foods[k] = dict(r, allergens=allergens, grocery=grocery, kcal=kcal, p=p, c=c, f=f,
                        fibre=float(r["fibre_g"]), jain=r["jain_ok"] == "1")
    return foods


# ---------------------------------------------------------------------------
# Starter templates (6.6): name, description, goal, diet_pref, macro preset,
# supplements, meals [(slot, time, notes, items[(key, qty)], alternatives)].
# ---------------------------------------------------------------------------
def meal(slot, time, items, alts=(), notes=None):
    return dict(slot=slot, time=time, items=items, alts=list(alts), notes=notes)


TEMPLATES = [
    dict(
        name="Veg fat loss 1,500 kcal", goal="fat_loss", pref="veg", preset="high_protein", kcal=1500,
        description="High-protein vegetarian plan with paneer, dal and curd. Plenty of vegetables to stay full.",
        supplements=["Multivitamin"],
        meals=[
            meal("early_morning", "06:30", [("lemon-water", 1), ("almonds", 1)]),
            meal("breakfast", "08:30", [("moong-chilla", 2), ("green-chutney", 1)],
                 alts=[[("oats-milk", 1)], [("besan-chilla", 2)]]),
            meal("mid_morning", "11:00", [("papaya", 1)], alts=[[("guava", 1)]]),
            meal("lunch", "13:30", [("roti", 1.5), ("moong-dal", 1), ("mixed-veg", 1), ("green-salad", 1)],
                 alts=[[("brown-rice", 1), ("rajma", 1), ("green-salad", 1), ("curd", 0.5)]], notes="Salad first, then the rest."),
            meal("evening_snack", "17:00", [("chai-no-sugar", 1), ("roasted-chana", 1)],
                 alts=[[("buttermilk", 1), ("makhana", 1)]]),
            meal("dinner", "20:30", [("low-fat-paneer", 1), ("sauteed-veg", 1), ("roti", 1)],
                 alts=[[("soya-curry", 1), ("roti", 1.5), ("green-salad", 1)]]),
            meal("bedtime", "22:00", [("double-toned-milk", 0.5)]),
        ],
    ),
    dict(
        name="Eggetarian fat loss 1,800 kcal", goal="fat_loss", pref="eggetarian", preset="high_protein", kcal=1800,
        description="Eggs, dal and curd for protein, with whole grains and fruit.",
        supplements=["Multivitamin"],
        meals=[
            meal("early_morning", "06:30", [("lemon-water", 1), ("almonds", 1)]),
            meal("breakfast", "08:30", [("egg-white-omelette", 1), ("boiled-egg", 1), ("brown-bread", 2)],
                 alts=[[("egg-bhurji", 1), ("multigrain-roti", 1)], [("oats-milk", 1), ("boiled-egg", 1)]]),
            meal("mid_morning", "11:00", [("apple", 1)], alts=[[("pear", 1)]]),
            meal("lunch", "13:30", [("roti", 2), ("toor-dal", 1), ("mixed-veg", 1), ("curd", 1)],
                 alts=[[("brown-rice", 1), ("chole", 1), ("curd", 1), ("roti", 1)]]),
            meal("pre_workout", "17:30", [("banana", 1), ("black-coffee", 1)]),
            meal("post_workout", "19:30", [("boiled-egg", 2), ("buttermilk", 1)],
                 alts=[[("hung-curd", 1), ("roasted-chana", 1)]]),
            meal("dinner", "21:00", [("egg-curry", 1), ("roti", 1), ("green-salad", 1)],
                 alts=[[("palak-paneer", 1), ("roti", 1.5)]]),
        ],
    ),
    dict(
        name="Veg balanced 2,000 kcal", goal="maintenance", pref="veg", preset="balanced", kcal=2000,
        description="Everyday home food in the right amounts: roti, rice, dal, sabzi and curd.",
        supplements=[],
        meals=[
            meal("early_morning", "06:30", [("chai", 1), ("almonds", 1)]),
            meal("breakfast", "08:30", [("poha", 1), ("curd", 1)],
                 alts=[[("idli", 4), ("sambar", 1)], [("upma", 1), ("curd", 1)]]),
            meal("mid_morning", "11:00", [("banana", 1)], alts=[[("apple", 1)]]),
            meal("lunch", "13:30", [("roti", 2), ("white-rice", 0.5), ("toor-dal", 1), ("bhindi", 1),
                                     ("cucumber-raita", 1)],
                 alts=[[("rajma-chawal", 1), ("roti", 1), ("cucumber-raita", 1), ("green-salad", 1)]]),
            meal("evening_snack", "17:00", [("chai", 1), ("dhokla", 3)],
                 alts=[[("buttermilk", 1), ("roasted-peanuts", 1)]]),
            meal("dinner", "20:30", [("roti", 2), ("matar-paneer", 1), ("green-salad", 1)],
                 alts=[[("khichdi", 1.5), ("curd", 1), ("papad", 1)]]),
        ],
    ),
    dict(
        name="Non-veg muscle gain 2,500 kcal", goal="muscle_gain", pref="non_veg", preset="high_protein", kcal=2500,
        description="Chicken, eggs and fish with rice and roti, timed around training.",
        supplements=["Whey protein", "Creatine", "Multivitamin"],
        meals=[
            meal("early_morning", "06:30", [("banana", 1), ("almonds", 1)]),
            meal("breakfast", "08:30", [("omelette", 1), ("brown-bread", 2), ("toned-milk", 1)],
                 alts=[[("oats-milk", 1), ("boiled-egg", 3)], [("paneer-paratha", 1), ("curd", 1), ("boiled-egg", 1)]]),
            meal("mid_morning", "11:00", [("roasted-peanuts", 0.5), ("apple", 1)]),
            meal("lunch", "13:30", [("white-rice", 1), ("roti", 2), ("chicken-curry", 1), ("curd", 1),
                                     ("green-salad", 1)],
                 alts=[[("chicken-biryani", 1), ("cucumber-raita", 1), ("boiled-egg", 2)],
                       [("roti", 3), ("white-rice", 0.5), ("fish-curry", 1), ("curd", 1), ("green-salad", 1)]]),
            meal("pre_workout", "17:00", [("banana", 1), ("black-coffee", 1)]),
            meal("post_workout", "19:00", [("whey", 1), ("toned-milk", 1)], notes="Within an hour of training."),
            meal("dinner", "21:00", [("chicken-breast", 1.5), ("roti", 2), ("sauteed-veg", 1)],
                 alts=[[("egg-curry", 1), ("white-rice", 1), ("boiled-egg", 1)]]),
        ],
    ),
    dict(
        name="Jain balanced 1,800 kcal", goal="maintenance", pref="jain", preset="balanced", kcal=1800,
        description="No onion, garlic or root vegetables. Dal, paneer and seasonal sabzi.",
        supplements=[],
        meals=[
            meal("early_morning", "06:30", [("lemon-water", 1), ("almonds", 1)]),
            meal("breakfast", "08:30", [("methi-thepla", 2), ("curd", 1)],
                 alts=[[("idli", 4), ("coconut-chutney", 2)], [("oats-milk", 1), ("banana", 1)]]),
            meal("mid_morning", "11:00", [("papaya", 1)], alts=[[("pomegranate", 1)]]),
            meal("lunch", "13:30", [("roti", 2), ("moong-dal", 1), ("lauki", 1), ("curd", 1)],
                 alts=[[("white-rice", 1), ("kadhi", 1), ("cabbage", 1), ("roti", 1)]]),
            meal("evening_snack", "17:00", [("chai", 1), ("khakhra", 2)],
                 alts=[[("buttermilk", 1), ("makhana", 1), ("roasted-peanuts", 0.5)]]),
            meal("dinner", "19:30", [("roti", 2), ("paneer", 0.75), ("beans", 1)],
                 notes="Many Jain members eat before sunset; move the time if so.",
                 alts=[[("khichdi", 1.5), ("curd", 1), ("papad", 1)]]),
        ],
    ),
    dict(
        name="Vegan high protein 2,200 kcal", goal="muscle_gain", pref="vegan", preset="high_protein", kcal=2200,
        description="Soya, tofu, dals and peanuts for protein, with no dairy or eggs.",
        supplements=["Creatine", "Vitamin B12"],
        meals=[
            meal("early_morning", "06:30", [("soy-milk", 1), ("almonds", 1)]),
            meal("breakfast", "08:30", [("besan-chilla", 2), ("green-chutney", 1), ("peanut-butter", 1)],
                 alts=[[("oats-water", 1), ("peanut-butter", 1), ("banana", 1), ("soy-milk", 0.5)]]),
            meal("mid_morning", "11:00", [("sprouts-salad", 1), ("orange", 1)]),
            meal("lunch", "13:30", [("roti", 2), ("brown-rice", 0.5), ("chole", 1), ("mixed-veg", 1)],
                 alts=[[("rajma-chawal", 1), ("roti", 1), ("mixed-veg", 0.5), ("green-salad", 1)]]),
            meal("post_workout", "18:30", [("plant-protein", 1), ("banana", 1)]),
            meal("dinner", "20:30", [("tofu", 1.5), ("soya-curry", 1), ("roti", 2)],
                 alts=[[("dal-chawal", 1), ("soya-chunks", 1), ("tofu", 1)]]),
        ],
    ),
]

PREF_OK = {
    "veg": lambda f: f["veg_type"] in ("vegan", "veg"),
    "eggetarian": lambda f: f["veg_type"] in ("vegan", "veg", "egg"),
    "non_veg": lambda f: True,
    "vegan": lambda f: f["veg_type"] == "vegan",
    "jain": lambda f: f["veg_type"] in ("vegan", "veg") and f["jain"],
}


def totals(foods, items):
    t = [0.0, 0.0, 0.0, 0.0]
    for k, qty in items:
        f = foods[k]
        t = [t[0] + f["kcal"] * qty, t[1] + f["p"] * qty, t[2] + f["c"] * qty, t[3] + f["f"] * qty]
    return t


def check_templates(foods, report=False):
    for t in TEMPLATES:
        day = [0.0, 0.0, 0.0, 0.0]
        for m in t["meals"]:
            mt = totals(foods, m["items"])
            day = [a + b for a, b in zip(day, mt)]
            for k, _ in m["items"] + [x for alt in m["alts"] for x in alt]:
                assert k in foods, (t["name"], k)
                assert PREF_OK[t["pref"]](foods[k]), f'{t["name"]}: {k} is not {t["pref"]}'
            assert len(m["alts"]) <= 2
            if report:
                alts = " | ".join(f"{totals(foods, a)[0]:.0f}" for a in m["alts"])
                print(f'  {m["slot"]:14} {mt[0]:6.0f} kcal P{mt[1]:5.1f}  alts: {alts}')
        if report:
            print(f'{t["name"]}: {day[0]:.0f} kcal  P {day[1]:.0f} g  C {day[2]:.0f} g  F {day[3]:.0f} g\n')
        assert abs(day[0] - t["kcal"]) <= t["kcal"] * 0.05, f'{t["name"]}: {day[0]:.0f} kcal'
        t["totals"] = day


def q(v):
    if v is None:
        return "null"
    return "'" + str(v).replace("'", "''") + "'"


def num(v):
    return f"{v:g}"


def arr(values):
    if not values:
        return "'{}'::text[]"
    return "array[" + ", ".join(q(v) for v in values) + "]::text[]"


def grocery_json(g):
    import json
    return q(json.dumps(g, ensure_ascii=False, separators=(",", ":"))) + "::jsonb"


def main():
    foods = load_foods()
    report = "--report" in sys.argv
    check_templates(foods, report)
    if report:
        return
    out = [
        "-- GENERATED by scripts/gen_food_seed.py from supabase/seed/foods.csv.",
        "-- Seeds the food database (F6 6.1) and the gym's starter diet templates",
        "-- (6.6). Values are typical recipes and portions, to be reviewed by the",
        "-- gym's dietitian or trainer before launch (reviewed_at stays null until",
        "-- then). Safe to re-run: existing rows are left alone.",
        "",
        "insert into public.foods (id, seed_key, name, local_name, category, serving_unit, serving_g, qty_step, kcal,",
        "                          protein_g, carbs_g, fat_g, fibre_g, veg_type, jain_ok, allergens, grocery, source) values",
    ]
    rows = []
    for k, f in foods.items():
        rows.append(
            f"  ({q(food_id(k))}, {q(k)}, {q(f['name'])}, {q(f['local_name'])}, {q(f['category'])}, {q(f['unit'])}, "
            f"{num(float(f['serving_g']))}, {num(float(f['step']))}, {num(f['kcal'])}, {num(f['p'])}, {num(f['c'])}, "
            f"{num(f['f'])}, {num(f['fibre'])}, {q(f['veg_type'])}, {'true' if f['jain'] else 'false'}, "
            f"{arr(f['allergens'])}, {grocery_json(f['grocery'])}, 'gym_seed')"
        )
    out.append(",\n".join(rows))
    out.append("on conflict (seed_key) do nothing;")
    out.append("")
    out.append("-- Starter templates (6.6), only when the library has none yet.")
    out.append("do $$")
    out.append("declare")
    out.append("  v_t uuid;")
    out.append("  v_m uuid;")
    out.append("begin")
    out.append("  if exists (select 1 from public.diet_templates where is_starter) then return; end if;")
    for t in TEMPLATES:
        p, c, f = (round(x / 5) * 5 for x in t["totals"][1:])
        out.append(
            f"  insert into public.diet_templates (name, description, goal, diet_pref, kcal_target, protein_g, carbs_g,"
            f" fat_g, macro_preset, supplements, is_gym_template, is_starter)\n"
            f"  values ({q(t['name'])}, {q(t['description'])}, {q(t['goal'])}, {q(t['pref'])}, {t['kcal']}, {p}, {c}, {f},"
            f" {q(t['preset'])}, {arr(t['supplements'])}, true, true) returning id into v_t;"
        )
        for pos, m in enumerate(t["meals"], start=1):
            out.append(
                f"  insert into public.diet_meals (template_id, meal_slot, time_of_day, position, notes)"
                f" values (v_t, {q(m['slot'])}, {q(m['time'])}, {pos}, {q(m['notes'])}) returning id into v_m;"
            )
            values = []
            for group, items in enumerate([m["items"]] + m["alts"]):
                for ipos, (k, qty) in enumerate(items, start=1):
                    values.append(f"(v_m, {q(food_id(k))}, {num(qty)}, {group}, {ipos})")
            out.append(
                "  insert into public.diet_meal_items (meal_id, food_id, qty, alt_group, position) values "
                + ", ".join(values) + ";"
            )
    out.append("end $$;")
    OUT.write_text("\n".join(out) + "\n", encoding="utf-8")
    templates = [
        dict(name=t["name"], description=t["description"], goal=t["goal"], diet_pref=t["pref"], kcal_target=t["kcal"],
             protein_g=round(t["totals"][1] / 5) * 5, carbs_g=round(t["totals"][2] / 5) * 5,
             fat_g=round(t["totals"][3] / 5) * 5, macro_preset=t["preset"], supplements=t["supplements"],
             meals=[dict(meal_slot=m["slot"], time_of_day=m["time"], notes=m["notes"],
                         items=[dict(food=k, qty=qty, alt_group=g)
                                for g, items in enumerate([m["items"]] + m["alts"]) for k, qty in items])
                    for m in t["meals"]])
        for t in TEMPLATES
    ]
    import json
    OUT_JSON.write_text(json.dumps(templates, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    print(f"wrote {OUT.relative_to(ROOT)}: {len(foods)} foods, {len(TEMPLATES)} templates")


if __name__ == "__main__":
    main()
