#!/bin/bash
set -euo pipefail

# Pod ismini al
POD=$(kubectl get pods -n database -l app=postgres -o jsonpath='{.items[0].metadata.name}')

echo "📦 Copying diff script into PostgreSQL pod: $POD"
kubectl cp ./check_pg_diff.sh -n database "$POD":/var/lib/postgresql/data/check_pg_diff.sh >/dev/null

echo "🚀 Running diff check inside pod..."
kubectl exec -it -n database "$POD" -- bash /var/lib/postgresql/data/check_pg_diff.sh "${1:-}"

echo "✅ Done."
