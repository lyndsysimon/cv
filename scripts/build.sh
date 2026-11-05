#!/usr/bin/env bash
# Build the CV site from resume.md. Requires pandoc.
# Usage: ./scripts/build.sh   -> writes site/index.html and site/style.css
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found. Install with: brew install pandoc" >&2
  exit 1
fi

rm -rf site
mkdir -p site

pandoc resume.md \
  --from=markdown+smart \
  --to=html5 \
  --strip-comments \
  --template=build/template.html \
  --metadata=pagetitle:"Lyndsy Simon" \
  --output=site/index.html

cp build/style.css site/style.css

# resume.pdf is committed (see scripts/build-pdf.sh); ship it alongside the page.
if [ -f resume.pdf ]; then
  cp resume.pdf site/resume.pdf
fi

echo "built site/index.html ($(wc -c < site/index.html | tr -d ' ') bytes)"