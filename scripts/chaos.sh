#!/usr/bin/env bash
set -euo pipefail
NS=apps
echo "[*] Killing one API pod to simulate failure..."
kubectl -n $NS delete pod $(kubectl -n $NS get pods -l app=api -o name | head -n1)
echo "[*] Simulated."
