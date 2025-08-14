#!/usr/bin/env bash
set -euo pipefail
make bootstrap
make cluster
make apm
