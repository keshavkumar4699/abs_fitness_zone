#!/usr/bin/env bash
# Applies every migration to a scratch Postgres database and runs each RLS
# test file against a fresh copy. Fails on the first failed check.
# Usage: PGHOST=localhost PGUSER=postgres PGPASSWORD=... scripts/test_db.sh
set -euo pipefail
DB="${TEST_DB:-abs_rls_test}"
PSQL=(psql -X -q -v ON_ERROR_STOP=1)

fresh_db() {
  "${PSQL[@]}" -d postgres -c "drop database if exists $DB" -c "create database $DB" >/dev/null
  "${PSQL[@]}" -d "$DB" -f supabase/tests/supabase_stub.sql >/dev/null
  for f in supabase/migrations/*.sql; do
    "${PSQL[@]}" -d "$DB" -f "$f" >/dev/null
  done
}

for t in supabase/tests/*_test.sql; do
  echo "== $t"
  fresh_db
  "${PSQL[@]}" -d "$DB" -o /dev/null -f "$t" 2>&1 | sed -n 's/.*NOTICE:  //p; /ERROR/p'
done
echo "database tests passed"
