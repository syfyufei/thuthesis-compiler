# site/

Single-page landing site for [thu-forge](https://github.com/syfyufei/thu-forge), deployed to GitHub Pages at <https://adriansun.drhuyue.site/thu-forge/>.

## Source

`index.html` — self-contained HTML with inline CSS and JS. No build step, no dependencies (Google Fonts loaded at runtime). Originally mocked in [Claude Design](https://claude.ai/design) and exported as a handoff bundle.

## Local preview

```bash
python3 -m http.server 8000 --directory site
# then open http://localhost:8000
```

Or any other static file server.

## Deploy

Pushed to `main`. The [`deploy-pages.yml`](../.github/workflows/deploy-pages.yml) workflow builds and deploys automatically whenever files under `site/` change.

**First-time setup** (repo owner, one-off): GitHub repo → Settings → Pages → *Source* = **GitHub Actions**.

## Editing

- **Copy (EN/中):** single `DICT` object near the top of the `<script>` block at the bottom of `index.html`. Every translatable string has `en` and `zh` entries.
- **Colors:** CSS custom properties in `:root` (`--bg`, `--ink`, `--coral`, `--teal`, …).
- **Logo:** inline SVG in the `<nav>` brand block.

All strings are rendered via `innerHTML`, so you can freely embed `<em>`, `<code>`, `<strong>`, `<a>` tags in translation values.
