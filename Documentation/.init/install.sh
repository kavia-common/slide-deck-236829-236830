#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/tmp/kavia/workspace/code-generation/slide-deck-236829-236830/Documentation"
cd "$WORKSPACE"
err() { echo "ERROR:deps-001:$1" >&2; }
# Try to copy existing node_modules dist if present
if [ -d node_modules/reveal.js/dist ]; then
  rm -rf public/vendor/reveal && mkdir -p public/vendor && cp -r node_modules/reveal.js/dist public/vendor/reveal || true
fi
# helper to find JS file
find_js() {
  for f in public/vendor/reveal/reveal.js public/vendor/reveal/reveal.min.js public/vendor/reveal/reveal.esm.js public/vendor/reveal/reveal.esm.min.js; do
    [ -f "$f" ] && echo "$f" && return 0
  done
  return 1
}
if ! find_js >/dev/null 2>&1; then
  # install reveal.js locally only if missing
  printf "fund=false\naudit=false\n" > .npmrc || true
  npm i --no-audit --no-fund --silent --no-save reveal.js@^4.5.0 || { rm -f .npmrc || true; err "npm install reveal.js failed"; exit 6; }
  rm -f .npmrc || true
  if [ -d node_modules/reveal.js/dist ]; then
    rm -rf public/vendor/reveal && mkdir -p public/vendor && cp -r node_modules/reveal.js/dist public/vendor/reveal || true
  fi
fi
# re-evaluate selected js file
JS_FILE=$(find_js || true)
if [ -z "$JS_FILE" ]; then err "no reveal JS found after install"; exit 7; fi
# create a normalized shim public/vendor/reveal/reveal.js that loads the real script if needed
SHIM="$WORKSPACE/public/vendor/reveal/reveal.js"
REAL_REL=$(realpath --relative-to="$(dirname "$SHIM")" "$JS_FILE")
# Only write shim if it isn't already the real file path and file differs
if [ ! -f "$SHIM" ] || [ "./$REAL_REL" != "./reveal.js" ]; then
  mkdir -p "$(dirname "$SHIM")"
  cat > "$SHIM" <<'EOF'
/* generated shim to normalize reveal.js filename */
(function(){
  var s=document.createElement('script');
  s.src='./$REAL_REL';
  document.head.appendChild(s);
})();
EOF
fi
# ensure theme exists
if [ ! -f public/vendor/reveal/theme/white.css ]; then err "reveal theme white.css missing"; exit 8; fi
# ensure http-server available: prefer global, else install locally no-save
if ! command -v http-server >/dev/null 2>&1; then
  npm i --no-audit --no-fund --silent --no-save http-server@0.12.3 || { err "failed to install http-server"; exit 9; }
fi
# ensure jest available: prefer global, else install locally no-save
if ! command -v jest >/dev/null 2>&1; then
  npm i --no-audit --no-fund --silent --no-save jest@29 || { err "failed to install jest"; exit 10; }
fi
exit 0
