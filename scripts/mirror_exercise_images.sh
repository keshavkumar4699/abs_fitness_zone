#!/usr/bin/env bash
# Copies the seeded exercise images (free-exercise-db, public domain, pinned
# commit) into the public "exercises" storage bucket, at <source_id>/<n>.jpg,
# which is where the app looks for them. Run once per Supabase project, from
# your own computer (never in the app): it needs the service-role key.
#
#   SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
#   SUPABASE_SERVICE_ROLE_KEY=... scripts/mirror_exercise_images.sh
#
# Re-running is safe (uploads overwrite). About 1,750 images, ~90 MB.
set -euo pipefail
: "${SUPABASE_URL:?set SUPABASE_URL}"
: "${SUPABASE_SERVICE_ROLE_KEY:?set SUPABASE_SERVICE_ROLE_KEY}"
COMMIT=f00c92c7dcf1216a928a52c3706c7ce8e2f71ed5
SRC="https://raw.githubusercontent.com/yuhonas/free-exercise-db/$COMMIT/exercises"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 -c 'import json,sys; [print(p) for x in json.load(open(sys.argv[1])) for p in x["images"]]' \
  "$ROOT/supabase/seed/exercises.json" > "$TMP/paths.txt"
total=$(wc -l < "$TMP/paths.txt")
n=0
while IFS= read -r path; do
  n=$((n + 1))
  file="$TMP/img.jpg"
  curl -fsS --retry 3 -o "$file" "$SRC/$path"
  curl -fsS --retry 3 -o /dev/null -X POST "$SUPABASE_URL/storage/v1/object/exercises/$path" \
    -H "Authorization: Bearer $SUPABASE_SERVICE_ROLE_KEY" \
    -H "Content-Type: image/jpeg" -H "x-upsert: true" -H "Cache-Control: max-age=31536000" \
    --data-binary @"$file"
  if (( n % 50 == 0 )); then echo "$n / $total"; fi
done < "$TMP/paths.txt"
echo "done: $n images"
