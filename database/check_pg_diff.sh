#!/bin/bash
set -euo pipefail

BACKUP_DIR="/var/lib/postgresql/data/pg_backups"

if [[ "${1:-}" == "--help" ]]; then
  echo "Usage: $0 [--data-only]"
  echo "Shows diff between last two PostgreSQL dump files."
  exit 0
fi

cd "$BACKUP_DIR" || { echo "Backup directory not found: $BACKUP_DIR"; exit 1; }

latest_files=($(ls -t dump-*.sql 2>/dev/null | head -n 2))
if [[ ${#latest_files[@]} -lt 2 ]]; then
  echo "Not enough backup files found."
  exit 1
fi

newest="${latest_files[0]}"
previous="${latest_files[1]}"

echo "🔍 Comparing latest two backups:"
echo "   Newest  : $newest"
echo "   Previous: $previous"
echo "---------------------------------------------"

if [[ "${1:-}" == "--data-only" ]]; then
  echo "🧠 Showing only data (COPY / INSERT / DELETE / UPDATE differences)"
  echo
  diff <(grep -E "COPY|INSERT|DELETE|UPDATE" "$previous") \
       <(grep -E "COPY|INSERT|DELETE|UPDATE" "$newest") || true
else
  diff -u "$previous" "$newest" || true
fi

echo "---------------------------------------------"
echo "✅ Diff completed."
