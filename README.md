# cv

Single-page CV for Lyndsy Simon, published to GitHub Pages at
<https://cv.lyndsysimon.com>.

## Layout

```
resume.md              canonical source — edit this
build/style.css        site stylesheet (screen + print)
scripts/build.sh       pandoc build: resume.md -> site/index.html
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