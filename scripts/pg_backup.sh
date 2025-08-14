#!/usr/bin/env bash
set -euo pipefail
NS=platform
POD=$(kubectl -n $NS get pods -l app=postgres -o jsonpath='{.items[0].metadata.name}')
TS=$(date +%F_%H%M%S)
BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"
kubectl -n $NS exec $POD -- sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -F c' > "$BACKUP_DIR/db_$TS.dump"
find "$BACKUP_DIR" -type f -mtime +7 -delete
echo "Backup saved to $BACKUP_DIR/db_$TS.dump"
