#!/usr/bin/env bash
set -euo pipefail
make build scan push
make secrets
make deploy
