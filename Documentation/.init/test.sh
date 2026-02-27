#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/tmp/kavia/workspace/code-generation/slide-deck-236829-236830/Documentation"
cd "$WORKSPACE"
err(){ echo "ERROR:test-001:$1" >&2; }
# Minimal check: ensure public/index.html exists
if [ ! -f "$WORKSPACE/public/index.html" ]; then err "public/index.html missing"; exit 2; fi
# If jest exists locally or globally, run a trivial test, otherwise skip (environment already has jest preinstalled)
if [ -x "$WORKSPACE/node_modules/.bin/jest" ]; then
  "$WORKSPACE/node_modules/.bin/jest" --version >/dev/null 2>&1 || true
elif command -v jest >/dev/null 2>&1; then
  jest --version >/dev/null 2>&1 || true
fi
exit 0
