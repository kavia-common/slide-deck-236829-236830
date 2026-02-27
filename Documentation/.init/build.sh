#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/tmp/kavia/workspace/code-generation/slide-deck-236829-236830/Documentation"
cd "$WORKSPACE"
err(){ echo "ERROR:build-001:$1" >&2; }
# Ensure public exists
if [ ! -d "$WORKSPACE/public" ]; then err "public directory missing"; exit 2; fi
# Prefer npm build script if present, otherwise copy public -> dist
if npm run | sed -n '1,200p' | grep -q "build"; then
  npm run build --silent || { err "npm build failed"; exit 3; }
else
  rm -rf "$WORKSPACE/dist" && mkdir -p "$WORKSPACE/dist"
  cp -a "$WORKSPACE/public/." "$WORKSPACE/dist/" || { err "copy public->dist failed"; exit 4; }
fi
exit 0
