#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/tmp/kavia/workspace/code-generation/slide-deck-236829-236830/Documentation"
cd "$WORKSPACE"
err(){ echo "ERROR:validation-001:$1" >&2; }
# BUILD (copy public->dist if no npm build)
if npm run | sed -n '1,200p' | grep -q "build"; then
  npm run build --silent || { err "build failed"; echo '{"validation":"failed","reason":"build failed","workspace":"'$WORKSPACE'"}' > "$WORKSPACE/validation_result.json"; exit 2; }
else
  rm -rf "$WORKSPACE/dist" && mkdir -p "$WORKSPACE/dist"
  cp -a "$WORKSPACE/public/." "$WORKSPACE/dist/" || { err "copy public->dist failed"; echo '{"validation":"failed","reason":"copy failed","workspace":"'$WORKSPACE'"}' > "$WORKSPACE/validation_result.json"; exit 2; }
fi
PORT=${VALIDATION_PORT:-8000}
DIST="$WORKSPACE/dist"
# start server via wrapper to ensure correct binary selection
nohup sh "$WORKSPACE/scripts/start-server.sh" "$DIST" "$PORT" >/dev/null 2>&1 &
SERVER_PID=$!
# ensure PID looks valid
if [ -z "$SERVER_PID" ] || ! kill -0 "$SERVER_PID" 2>/dev/null; then err "server failed to start (no valid PID)"; echo '{"validation":"failed","reason":"no valid pid","workspace":"'$WORKSPACE'"}' > "$WORKSPACE/validation_result.json"; exit 3; fi
# scoped cleanup function
cleanup() {
  kill "$SERVER_PID" 2>/dev/null || true
  sleep 0.2
  pkill -f "${WORKSPACE}/dist" 2>/dev/null || true
  wait "$SERVER_PID" 2>/dev/null || true
}
trap cleanup EXIT
# poll for HTTP 200 with higher timeout
TRIES=0
MAX=120
SLEEP=0.5
URL="http://127.0.0.1:$PORT/"
while [ $TRIES -lt $MAX ]; do
  if curl -sSf --max-time 2 "$URL" >/dev/null 2>&1; then
    break
  fi
  TRIES=$((TRIES+1))
  sleep $SLEEP
done
if [ $TRIES -ge $MAX ]; then
  err "server did not become ready"
  echo '{"validation":"failed","reason":"server did not become ready","workspace":"'$WORKSPACE'"}' > "$WORKSPACE/validation_result.json"
  exit 4
fi
HTTP_CODE=$(curl -sS --max-time 2 -o /dev/null -w "%{http_code}" "$URL" || true)
if [ "$HTTP_CODE" != "200" ]; then
  err "unexpected http code $HTTP_CODE"
  echo '{"validation":"failed","http_code":'$HTTP_CODE',"workspace":"'$WORKSPACE'"}' > "$WORKSPACE/validation_result.json"
  exit 5
fi
# success: write evidence
echo '{"validation":"success","url":"'$URL'","workspace":"'$WORKSPACE'"}' > "$WORKSPACE/validation_result.json"
# cleanup will run via trap
exit 0
