#!/usr/bin/env bash
set -euo pipefail
echo "[1/5] Hitting /health and /metrics..."
curl -s http://api.localtest.me/health || true
curl -s http://api.localtest.me/metrics || true

echo "[2/5] Load test (ab 200 req @ 20 concurrency)..."
which ab >/dev/null 2>&1 && ab -n 200 -c 20 http://api.localtest.me/health || echo "Install apache2-utils for ab"

echo "[3/5] Error rate demo (bad token to /echo)..."
for i in {1..20}; do curl -s -XPOST http://api.localtest.me/echo -d '{}' -H 'Content-Type: application/json' >/dev/null; done

echo "[4/5] Chaos: deleting one API pod to see rolling recovery..."
kubectl -n apps delete pod $(kubectl -n apps get pods -l app=api -o name | head -n1)

echo "[5/5] Done. Check Kibana APM (http://localhost:5601)."
