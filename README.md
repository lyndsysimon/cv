# cv

Single-page CV for Lyndsy Simon, published to GitHub Pages at
<https://cv.lyndsysimon.com>.

## Layout

```
resume.md              canonical source — edit this
resume.pdf             committed PDF export, served at /resume.pdf
build/style.css        site stylesheet (screen + print)
scripts/build.sh       pandoc build: resume.md -> site/index.html
scripts/build-pdf.sh   headless Chrome: site/index.html -> resume.pdf
.github/workflows/     Pages build and deploy
```

`site/` is a build artifact and is gitignored. Nothing in it should be edited
by hand or committed.

## Local build

Requires [pandoc](https://pandoc.org) (`brew install pandoc`).

```sh
./scripts/build.sh
open site/index.html
```

## Page actions

`build/template.html` carries a floating nav with two icon links: a document
with a download arrow (the PDF) and the GitHub mark. It lives in the template,
not `resume.md`, so the resume source stays pure content.

- Wide screens (≥ 58rem): the icons sit open at the top right.
- Narrow screens: a 44px hamburger at the bottom right, collapsed by default,
  toggled by tap. Escape or an outside tap closes it.
- `@media print` hides it entirely, so it never reaches the PDF.

Icons are inline SVG filled with `currentColor` — no icon font, no CDN, no
build step. Each link carries `title` and `aria-label` with its old text, since
the visible label is gone.

The 58rem breakpoint is the width at which the open icon row stops colliding
with the 44rem content column. Re-measure it if the icons or their padding
change.

## PDF

`resume.pdf` is committed and served at <https://cv.lyndsysimon.com/resume.pdf>.
Regenerate it after editing `resume.md`:

```sh
./scripts/build-pdf.sh
```

It uses headless Chrome (set `CHROME=/path/to/chrome` if it can't find one).
The PDF is committed rather than built in CI because the Pages runner has no
PDF engine.

## Deploy

Push to `main`. The workflow runs `scripts/build.sh`, uploads `site/` as the
Pages artifact, and deploys it.

## Custom domain

The domain is repo configuration (Settings → Pages → Custom domain), not a
`CNAME` file, because the site deploys as a workflow artifact.

DNS at the registrar for `cv.lyndsysimon.com`:

```
CNAME  cv  lyndsysimon.github.io.
```

GitHub issues the TLS certificate asynchronously after DNS resolves to its
edge; expect minutes to a few hours before `https://` works.

## Notes

- The page is the Markdown, rendered. No templating layer, no Jekyll, no
  hidden layout files — `resume.md` is what ships.
- Print styles are in place, so the same stylesheet is the basis for a PDF
  export when that gets added.