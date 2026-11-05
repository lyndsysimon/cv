#!/usr/bin/env bash
# Render resume.md to resume.pdf using headless Chrome.
# Usage: ./scripts/build-pdf.sh   -> writes resume.pdf in the repo root
#
# The PDF is committed because the Pages workflow has no PDF engine. Re-run
# this whenever resume.md changes, then commit the new resume.pdf.
set -euo pipefail

cd "$(dirname "$0")/.."

CHROME="${CHROME:-}"
if [ -z "$CHROME" ]; then
  for candidate in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "$(command -v chromium 2>/dev/null || true)" \
    "$(command -v google-chrome 2>/dev/null || true)"
  do
    if [ -n "$candidate" ] && [ -x "$candidate" ]; then
      CHROME="$candidate"
      break
    fi
  done
fi

if [ -z "$CHROME" ]; then
  echo "error: no Chrome/Chromium found. Set CHROME=/path/to/chrome" >&2
  exit 1
fi

./scripts/build.sh

"$CHROME" \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --no-pdf-header-footer \
  --print-to-pdf=resume.pdf \
  "file://$PWD/site/index.html" 2>/dev/null

# Re-run so build.sh copies the fresh PDF into site/.
./scripts/build.sh >/dev/null

echo "built resume.pdf ($(wc -c < resume.pdf | tr -d ' ') bytes)"
