#!/usr/bin/env bash
set -euo pipefail
: "${INFISICAL_PROJECT_ID:=YOUR_PROJECT_ID}"
: "${INFISICAL_ENV:=dev}"
: "${NS_APPS:=apps}"

if ! which infisical >/dev/null; then
  echo "Infisical CLI not installed. Please install and login."
  exit 1
fi

echo "[*] Exporting secrets from Infisical..."
infisical secrets --projectId "$INFISICAL_PROJECT_ID" --env "$INFISICAL_ENV" --format=dotenv > /tmp/app.env

echo "[*] Creating/Updating Kubernetes Secret apps/app-secrets"
kubectl -n "$NS_APPS" create secret generic app-secrets --from-env-file=/tmp/app.env --dry-run=client -o yaml | kubectl apply -f -
