---
description: Compile a Quarto book dissertation into thuthesis-formatted PDF. Runs the full pipeline: quarto render → chapter splitting → XeLaTeX × 3 + BibTeX → main.pdf.
---

## Goal

Compile `.qmd` dissertation chapters into `thuthesis/main.pdf` using the full build pipeline.

## Execution Checklist

### Step 1 — Verify Configuration

- [ ] Read `_quarto.yml` — confirm `bibliography: references.bib` and `cite-method: natbib` are present
- [ ] Confirm chapter list in `_quarto.yml` matches actual `.qmd` files in `chapters/`
- [ ] Read `thuthesis/main.tex` — confirm `\input` commands match expected chapter filenames
- [ ] Read `thuthesis/scripts/split_quarto_tex_v2.py` — note current `CHAPTER_GROUPS` values

### Step 2 — Merge Bibliography

```bash
python3 thuthesis/scripts/consolidate_bibs.py
```

- [ ] Confirm `thuthesis/ref/references.bib` is complete
- [ ] Check for unescaped `&` in journal names:
  ```bash
  grep -n '[^\\]&' thuthesis/ref/references.bib
  ```
  Escape any found as `\&` before continuing.

### Step 3 — Validate CHAPTER_GROUPS (MANDATORY — never skip)

Stale `CHAPTER_GROUPS` indices cause **silent content corruption**: wrong chapters merged, deleted content reappearing, or chapters truncated. The build may still show 0 LaTeX errors while producing a corrupted PDF.

1. Render to get a fresh `index.tex`:
   ```bash
   quarto render --to pdf
   ```

2. Count and list all `\chapter{}` entries:
   ```bash
   grep -n '\\chapter{' index.tex
   ```

3. Compare against `CHAPTER_GROUPS` in `split_quarto_tex_v2.py`:
   - Total count must equal the sum of all group ranges
   - First entry of each group must match the YAML title of the corresponding `.qmd`
   - Entry count per group must match the number of `#` headings in that `.qmd`

4. If any mismatch → update `CHAPTER_GROUPS`. See [`references/chapter-groups.md`](../references/chapter-groups.md) for the full procedure.

**Warning signs of stale CHAPTER_GROUPS:**
- Build log shows `⚠️ 章节 X 超出范围`
- Build log shows `成功提取: N/M 个章节` where N < M
- Chapter titles in output `.tex` files don't match expectations
- Deleted `.qmd` content still appears in PDF
- Unexpected page count

### Step 4 — Run Full Build

```bash
bash thuthesis/build.sh
```

### Step 5 — Inspect Build Log

```bash
grep -n '^!' thuthesis/main.log | head -30
grep -n 'Citation.*undefined' thuthesis/main.log
grep -n 'File.*not found' thuthesis/main.log
```

- [ ] Zero lines starting with `!` (LaTeX errors)
- [ ] No `Citation ... undefined` warnings
- [ ] No `File ... not found` warnings
- [ ] Overfull box warnings noted (cosmetic only, low priority)

### Step 6 — Fix and Iterate

If errors found:
1. Consult [`references/pitfalls.md`](../references/pitfalls.md) — check the symptom table
2. Apply the fix
3. Re-run `bash thuthesis/recompile.sh` (faster than full build for LaTeX-only fixes)
4. Repeat until log shows 0 errors

### Step 7 — Verify Output

Open `thuthesis/main.pdf` and confirm:

- [ ] All images present and within margins (not overflowing `\linewidth`)
- [ ] References section populated (not empty)
- [ ] Table of contents has correct chapter titles and page numbers
- [ ] Citations render as `(Author, Year)` format — no `??` placeholders
- [ ] No `{[}@key{]}` literal text visible in body

## Quick Troubleshooting Reference

| Symptom | Likely Pitfall | Quick Fix |
|---------|---------------|-----------|
| Too many chapters in PDF | Pitfall 1 | Update `CHAPTER_GROUPS`, re-split |
| `{[}@key{]}` in output | Pitfall 2 | Add `bibliography` + `cite-method` to `_quarto.yml` |
| "File not found" for images | Pitfall 3 | Check `fix_image_paths()` prepends `../` |
| Images overflow margins | Pitfall 4 | Define `\pandocbounded` in `thusetup.tex` |
| "Undefined control sequence" | Pitfall 5 | Add `\providecommand` in `thusetup.tex` |
| References / appendix missing | Pitfall 6 | Check `clean_pandoc_artifacts()` |
| "I found no database files" | Pitfall 7 | Add `\AtEndDocument{\bibdata{...}}` |
| References empty after build | Pitfall 8 | Remove `*.bbl` from cleanup in `recompile.sh` |
| "Misplaced alignment tab" | Pitfall 9 | Escape `&` as `\&` in `.bib` file |
| Bookmark warnings | Pitfall 10 | `\providecommand{\bookmarksetup}[1]{}` |
| Wrong chapters merged / `⚠️ 章节 X 超出范围` | Pitfall 11 | Recount `\chapter{}` in `index.tex`, update `CHAPTER_GROUPS` |

Full details: [`references/pitfalls.md`](../references/pitfalls.md)

## Important Notes

- Never skip the 3-pass XeLaTeX compilation — cross-references and TOC require multiple passes
- BibTeX must run between pass 1 and pass 2: `xelatex → bibtex → xelatex → xelatex`
- Always read existing scripts before modifying — `split_quarto_tex_v2.py` has careful edge-case logic
- When a new pitfall is discovered, document it in `references/pitfalls.md`
