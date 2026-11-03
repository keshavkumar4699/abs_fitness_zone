#!/usr/bin/env python3
"""Generates supabase/migrations/20261106000001_m3_exercise_seed.sql from the
pinned free-exercise-db dataset in supabase/seed/exercises.json (public domain,
commit f00c92c7dcf1216a928a52c3706c7ce8e2f71ed5) plus the gym's starter
workout templates. Re-run after changing either; the output is committed.

    python3 scripts/gen_exercise_seed.py
"""
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC = ROOT / "supabase/seed/exercises.json"
OUT = ROOT / "supabase/migrations/20261106000001_m3_exercise_seed.sql"

DISTANCE_CARDIO = re.compile(r"treadmill|bicycling|rowing|running|jogging|walking|elliptical|trail", re.I)
NO_LOAD = {None, "body only", "bands", "exercise ball", "foam roll", "other"}


def tracking_type(x):
    """How the workout player logs this exercise (spec 4.8)."""
    cat, eq, force = x.get("category"), x.get("equipment"), x.get("force")
    if cat == "stretching" or eq == "foam roll":
        return "time"
    if cat == "cardio":
        return "distance_time" if DISTANCE_CARDIO.search(x["name"]) else "time"
    if cat == "plyometrics":
        return "reps"
    if force == "static" and eq in NO_LOAD:
        return "time"
    if eq in NO_LOAD:
        return "reps"
    return "reps_weight"


def q(v):
    if v is None:
        return "null"
    return "'" + str(v).replace("'", "''") + "'"


def arr(values):
    if not values:
        return "'{}'::text[]"
    return "array[" + ", ".join(q(v) for v in values) + "]::text[]"


# ---------------------------------------------------------------------------
# Starter templates: (name, description, goal, level, weeks, progression,
# step, days[(name, items[(source_id, block, sets, reps, reps_max, seconds,
# weight, rest, group)])])
# ---------------------------------------------------------------------------
def it(src, sets=3, reps=None, reps_max=None, secs=None, weight=None, rest=60, block="main", group=None, notes=None):
    return dict(src=src, sets=sets, reps=reps, reps_max=reps_max, secs=secs, weight=weight, rest=rest,
                block=block, group=group, notes=notes)


TEMPLATES = [
    ("Beginner fat loss", "Three easy full-body days with cardio and core. Add one rep a week.",
     "fat_loss", "beginner", 6, "reps", 1, [
         ("Full body A", [
             it("Walking_Treadmill", 1, secs=300, rest=0, block="warmup"),
             it("Bodyweight_Squat", 3, 12),
             it("Incline_Push-Up", 3, 10),
             it("Seated_Cable_Rows", 3, 12, weight=20),
             it("Dumbbell_Lunges", 3, 10, weight=4),
             it("Plank", 3, secs=30, rest=45),
             it("Hamstring_Stretch", 1, secs=30, rest=0, block="cooldown"),
         ]),
         ("Cardio and core", [
             it("Elliptical_Trainer", 1, secs=1200, rest=60),
             it("Crunches", 3, 15, rest=45, group="A"),
             it("Reverse_Crunch", 3, 12, rest=45, group="A"),
             it("Side_Bridge", 3, secs=20, rest=45),
             it("Mountain_Climbers", 3, 20, rest=45),
             it("Cat_Stretch", 1, secs=30, rest=0, block="cooldown"),
         ]),
         ("Full body B", [
             it("Bicycling_Stationary", 1, secs=300, rest=0, block="warmup"),
             it("Goblet_Squat", 3, 12, weight=8),
             it("Dumbbell_Bench_Press", 3, 12, weight=6),
             it("Wide-Grip_Lat_Pulldown", 3, 12, weight=20),
             it("Butt_Lift_Bridge", 3, 15),
             it("Quad_Stretch", 1, secs=30, rest=0, block="cooldown"),
         ]),
     ]),
    ("Muscle gain 4-day", "Upper / lower split, four days a week. Add 2.5 kg a week when every set is done.",
     "muscle_gain", "intermediate", 8, "weight", 2.5, [
         ("Upper A", [
             it("Barbell_Bench_Press_-_Medium_Grip", 4, 8, weight=40, rest=120),
             it("Bent_Over_Barbell_Row", 4, 8, weight=30, rest=120),
             it("Dumbbell_Shoulder_Press", 3, 10, weight=10, rest=90),
             it("Wide-Grip_Lat_Pulldown", 3, 10, weight=35, rest=90),
             it("Barbell_Curl", 3, 12, weight=15, group="A"),
             it("Triceps_Pushdown", 3, 12, weight=15, group="A"),
         ]),
         ("Lower A", [
             it("Barbell_Squat", 4, 8, weight=40, rest=150),
             it("Romanian_Deadlift", 3, 10, weight=30, rest=120),
             it("Leg_Press", 3, 12, weight=60, rest=90),
             it("Lying_Leg_Curls", 3, 12, weight=20),
             it("Standing_Calf_Raises", 4, 15, weight=30, rest=45),
         ]),
         ("Upper B", [
             it("Barbell_Incline_Bench_Press_-_Medium_Grip", 4, 8, weight=30, rest=120),
             it("Seated_Cable_Rows", 4, 10, weight=35, rest=90),
             it("Side_Lateral_Raise", 3, 15, weight=4, rest=45),
             it("Pullups", 3, 6, 10, rest=120),
             it("Hammer_Curls", 3, 12, weight=8, group="B"),
             it("Triceps_Pushdown_-_Rope_Attachment", 3, 12, weight=15, group="B"),
         ]),
         ("Lower B", [
             it("Barbell_Deadlift", 3, 5, weight=50, rest=180),
             it("Dumbbell_Lunges", 3, 10, weight=10, rest=90),
             it("Leg_Extensions", 3, 12, weight=25),
             it("Barbell_Hip_Thrust", 3, 10, weight=40, rest=90),
             it("Seated_Calf_Raise", 3, 15, weight=20, rest=45),
         ]),
     ]),
    ("Women's strength", "Three days of the big strength moves with dumbbells and machines.",
     "strength", "beginner", 8, "weight", 2.5, [
         ("Lower and core", [
             it("Goblet_Squat", 3, 10, weight=8, rest=90),
             it("Barbell_Hip_Thrust", 3, 10, weight=20, rest=90),
             it("Dumbbell_Step_Ups", 3, 10, weight=4),
             it("Plank", 3, secs=30, rest=45),
         ]),
         ("Upper", [
             it("Dumbbell_Bench_Press", 3, 10, weight=6, rest=90),
             it("One-Arm_Dumbbell_Row", 3, 10, weight=8),
             it("Dumbbell_Shoulder_Press", 3, 10, weight=4),
             it("Face_Pull", 3, 15, weight=10, rest=45),
         ]),
         ("Full body", [
             it("Stiff-Legged_Dumbbell_Deadlift", 3, 10, weight=8, rest=90),
             it("Leg_Press", 3, 12, weight=40),
             it("Wide-Grip_Lat_Pulldown", 3, 12, weight=20),
             it("Side_Bridge", 3, secs=20, rest=45),
         ]),
     ]),
    ("Senior mobility", "Gentle walking, mobility and balance work. Go slow and stop if anything hurts.",
     "general_fitness", "beginner", 6, "none", 0, [
         ("Mobility A", [
             it("Walking_Treadmill", 1, secs=600, rest=60, block="warmup"),
             it("Bodyweight_Squat", 2, 8, rest=90, notes="Sit to a chair and stand up"),
             it("Incline_Push-Up", 2, 8, rest=90, notes="Hands on a wall or bench"),
             it("Standing_Hip_Circles", 2, secs=30, rest=30),
             it("Pelvic_Tilt_Into_Bridge", 2, secs=30, rest=30),
             it("Calf_Stretch_Hands_Against_Wall", 1, secs=30, rest=0, block="cooldown"),
         ]),
         ("Mobility B", [
             it("Bicycling_Stationary", 1, secs=600, rest=60, block="warmup"),
             it("Cat_Stretch", 2, secs=30, rest=30),
             it("Shoulder_Stretch", 2, secs=30, rest=30),
             it("Seated_Floor_Hamstring_Stretch", 2, secs=30, rest=30),
             it("Chin_To_Chest_Stretch", 1, secs=30, rest=0, block="cooldown"),
         ]),
     ]),
    ("Push / Pull / Legs", "The classic three-day split. Add 2.5 kg a week when every set is done.",
     "muscle_gain", "intermediate", 8, "weight", 2.5, [
         ("Push", [
             it("Barbell_Bench_Press_-_Medium_Grip", 4, 8, weight=40, rest=120),
             it("Dumbbell_Shoulder_Press", 3, 10, weight=10, rest=90),
             it("Incline_Dumbbell_Flyes", 3, 12, weight=8),
             it("Side_Lateral_Raise", 3, 15, weight=4, rest=45),
             it("Triceps_Pushdown", 3, 12, weight=15),
         ]),
         ("Pull", [
             it("Barbell_Deadlift", 3, 5, weight=50, rest=180),
             it("Pullups", 3, 6, 10, rest=120),
             it("Seated_Cable_Rows", 3, 10, weight=35, rest=90),
             it("Face_Pull", 3, 15, weight=12, rest=45),
             it("Barbell_Curl", 3, 10, weight=15),
         ]),
         ("Legs", [
             it("Barbell_Squat", 4, 8, weight=40, rest=150),
             it("Romanian_Deadlift", 3, 10, weight=30, rest=120),
             it("Leg_Press", 3, 12, weight=60, rest=90),
             it("Lying_Leg_Curls", 3, 12, weight=20),
             it("Standing_Calf_Raises", 4, 15, weight=30, rest=45),
         ]),
     ]),
    ("Full body 3x", "Three full-body sessions a week for all-round fitness. Add one rep a week.",
     "general_fitness", "beginner", 6, "reps", 1, [
         ("Day 1", [
             it("Rowing_Stationary", 1, secs=300, rest=0, block="warmup"),
             it("Goblet_Squat", 3, 10, weight=8),
             it("Pushups", 3, 10),
             it("One-Arm_Dumbbell_Row", 3, 10, weight=8),
             it("Plank", 3, secs=30, rest=45),
         ]),
         ("Day 2", [
             it("Bicycling_Stationary", 1, secs=300, rest=0, block="warmup"),
             it("Leg_Press", 3, 12, weight=40),
             it("Dumbbell_Shoulder_Press", 3, 10, weight=6),
             it("Wide-Grip_Lat_Pulldown", 3, 12, weight=25),
             it("Crunches", 3, 15, rest=45),
         ]),
         ("Day 3", [
             it("Walking_Treadmill", 1, secs=300, rest=0, block="warmup"),
             it("Dumbbell_Lunges", 3, 10, weight=6),
             it("Dumbbell_Bench_Press", 3, 10, weight=8),
             it("Seated_Cable_Rows", 3, 12, weight=25),
             it("Butt_Lift_Bridge", 3, 15),
             it("Hamstring_Stretch", 1, secs=30, rest=0, block="cooldown"),
         ]),
     ]),
]


def main():
    data = json.loads(SRC.read_text())
    ids = {x["id"] for x in data}
    lines = [
        "-- GENERATED by scripts/gen_exercise_seed.py from supabase/seed/exercises.json",
        "-- (free-exercise-db, public domain, commit f00c92c7dcf1216a928a52c3706c7ce8e2f71ed5).",
        "-- Seeds the exercise catalogue (F4 4.1) and the gym's starter workout",
        "-- templates (F5 5.3). Safe to re-run: existing rows are left alone.",
        "",
        "insert into public.exercises (source_id, name, primary_muscles, secondary_muscles, equipment, level,",
        "                              category, mechanic, force, tracking_type, instructions, images) values",
    ]
    rows = []
    for x in sorted(data, key=lambda r: r["id"]):
        rows.append(
            "  (" + ", ".join([
                q(x["id"]), q(x["name"].strip()), arr(x["primaryMuscles"]), arr(x["secondaryMuscles"]),
                q(x.get("equipment")), q(x.get("level")), q(x.get("category")), q(x.get("mechanic")),
                q(x.get("force")), q(tracking_type(x)), arr([s.strip() for s in x.get("instructions", []) if s.strip()]),
                arr(x.get("images", [])),
            ]) + ")"
        )
    lines.append(",\n".join(rows))
    lines.append("on conflict (source_id) do nothing;")
    lines.append("")
    lines.append("-- Starter templates (owned by the gym; trainers duplicate and edit them).")
    lines.append("do $$")
    lines.append("declare")
    lines.append("  v_t uuid;")
    lines.append("  v_d uuid;")
    lines.append("begin")
    for name, desc, goal, level, weeks, prog, step, days in TEMPLATES:
        lines.append(f"  if not exists (select 1 from public.workout_templates where name = {q(name)} and is_gym_template) then")
        lines.append(
            "    insert into public.workout_templates (name, description, goal, level, weeks, progression, progression_step, is_gym_template, is_starter)"
        )
        lines.append(f"    values ({q(name)}, {q(desc)}, {q(goal)}, {q(level)}, {weeks}, {q(prog)}, {step}, true, true) returning id into v_t;")
        for di, (dname, items) in enumerate(days, start=1):
            lines.append(f"    insert into public.workout_days (template_id, day_index, name) values (v_t, {di}, {q(dname)}) returning id into v_d;")
            for pi, i in enumerate(items, start=1):
                assert i["src"] in ids, i["src"]
                cols = "day_id, exercise_id, position, block, group_key, sets, reps, reps_max, duration_s, target_weight, rest_s, notes"
                vals = ", ".join([
                    "v_d", f"(select id from public.exercises where source_id = {q(i['src'])})", str(pi), q(i["block"]),
                    q(i["group"]), str(i["sets"]), "null" if i["reps"] is None else str(i["reps"]),
                    "null" if i["reps_max"] is None else str(i["reps_max"]), "null" if i["secs"] is None else str(i["secs"]),
                    "null" if i["weight"] is None else str(i["weight"]), str(i["rest"]), q(i["notes"]),
                ])
                lines.append(f"    insert into public.workout_items ({cols}) values ({vals});")
        lines.append("  end if;")
    lines.append("end $$;")
    OUT.write_text("\n".join(lines) + "\n")
    print(f"wrote {OUT.relative_to(ROOT)}: {len(rows)} exercises, {len(TEMPLATES)} templates")


if __name__ == "__main__":
    main()
