#!/usr/bin/env bash
set -euo pipefail
DIR="$PWD"
PORT="${2:-8000}"
TARGET="${1:-public}"
HTTP_BIN="$(command -v http-server || true)"
if [ -z "$HTTP_BIN" ]; then
  HTTP_BIN="$DIR/node_modules/.bin/http-server"
fi
if [ ! -x "$HTTP_BIN" ]; then
  echo "ERROR:scaffold-001:http-server not found" >&2
  exit 2
fi
exec "$HTTP_BIN" "$TARGET" -p "$PORT"
