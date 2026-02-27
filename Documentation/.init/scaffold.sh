#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/tmp/kavia/workspace/code-generation/slide-deck-236829-236830/Documentation"
mkdir -p "$WORKSPACE" && cd "$WORKSPACE"
# create package.json only if missing; pin reveal.js to a tested minor for reproducibility
if [ ! -f package.json ]; then
  cat > package.json <<'EOF'
{
  "name": "revealjs-docs",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "start": "sh ./scripts/start-server.sh public 8000",
    "build": "rm -rf dist && mkdir -p dist && cp -r public/* dist/",
    "preview": "npm run start"
  },
  "dependencies": {
    "reveal.js": "^4.5.0"
  }
}
EOF
fi
mkdir -p public/css public/vendor/reveal scripts
# start-server wrapper: locate http-server (global or local) and exec it
cat > scripts/start-server.sh <<'EOF'
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
EOF
chmod +x scripts/start-server.sh
# minimal index.html referencing normalized reveal.js path
if [ ! -f public/index.html ]; then
  cat > public/index.html <<'EOF'
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Reveal.js Slides</title>
  <link rel="stylesheet" href="vendor/reveal/reveal.css">
  <link rel="stylesheet" href="vendor/reveal/theme/white.css" id="theme">
  <style> .reveal { height: 100%; } </style>
</head>
<body>
  <div class="reveal"><div class="slides">
    <section>Slide 1<br><small>Generated scaffold</small></section>
    <section>Slide 2</section>
  </div></div>
  <script src="vendor/reveal/reveal.js"></script>
  <script>
    Reveal.initialize({ hash: true });
  </script>
</body>
</html>
EOF
fi
if [ ! -f public/css/theme.css ]; then
  cat > public/css/theme.css <<'EOF'
.reveal { font-family: Arial, Helvetica, sans-serif }
EOF
fi
exit 0
