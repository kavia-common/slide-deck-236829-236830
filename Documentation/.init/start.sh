#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/tmp/kavia/workspace/code-generation/slide-deck-236829-236830/Documentation"
if [ "$#" -lt 2 ]; then echo "Usage: $0 <dist_path> <port>" >&2; exit 2; fi
DIST="$1"
PORT="$2"
cd "$WORKSPACE"
err(){ echo "ERROR:start-001:$1" >&2; }
# wrapper to find http-server (global or local) and exec
# prefer local node_modules/.bin/http-server, fall back to global
if [ -x "$WORKSPACE/node_modules/.bin/http-server" ]; then
  exec "$WORKSPACE/node_modules/.bin/http-server" "$DIST" -p "$PORT" --silent
elif command -v http-server >/dev/null 2>&1; then
  exec http-server "$DIST" -p "$PORT" --silent
else
  err "http-server not available"
  exit 3
fi
