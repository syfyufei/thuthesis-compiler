# Updating CHAPTER_GROUPS

The `CHAPTER_GROUPS` dict in `split_quarto_tex_v2.py` maps each output chapter file to its range of `\chapter{}` indices from `index.tex`. It must be updated whenever the chapter structure changes.

**CRITICAL**: Stale `CHAPTER_GROUPS` causes silent content corruption — chapters bleed into each other, deleted content reappears, or chapters are truncated. The build may succeed with 0 LaTeX errors while producing a silently corrupted PDF. See [Pitfall 11](pitfalls.md#pitfall-11-stale-chapter_groups).

## When to Update

Update `CHAPTER_GROUPS` whenever:

- A `.qmd` file is added to or removed from `_quarto.yml`
- Chapters are reordered in `_quarto.yml`
- **A `#` heading is added to or removed from any `.qmd` file** — this is the most common trigger and the easiest to miss. Each `#` heading in a `.qmd` produces one `\chapter{}` in `index.tex`. Removing 6 headings from chapter 4 shifts all subsequent chapter indices by −6.

## Validation

Always verify before building. After `quarto render --to pdf`:

```bash
grep -c '\\chapter{' index.tex
```

The total must equal the sum of all `(end - start)` values across `CHAPTER_GROUPS`. If not, the mapping is stale.

## Update Procedure

1. Render to get a fresh `index.tex`:
   ```bash
   quarto render --to pdf
   ```

2. List all `\chapter{}` entries with line numbers:
   ```bash
   grep -n '\\chapter{' index.tex
   ```

3. Map each consecutive group of `\chapter{}` entries to the `.qmd` that generated them. The order matches `_quarto.yml`.

4. Update `CHAPTER_GROUPS` in `split_quarto_tex_v2.py` with the new index ranges (0-based, half-open intervals).

5. Re-run the full build:
   ```bash
   bash thuthesis/build.sh
   ```

## Example

If `grep` output shows:
```
10: \chapter{Introduction}
50: \chapter{Background}
90: \chapter{History of HK}
91: \chapter{Colonial Period}
92: \chapter{Post-handover}
```

And `_quarto.yml` lists:
1. `introduction.qmd` — 1 heading
2. `background.qmd` — 1 heading
3. `history_hk.qmd` — 3 headings

Then `CHAPTER_GROUPS` should be:
```python
CHAPTER_GROUPS = {
    "chap01": (0, 1),   # introduction.qmd:  1 chapter
    "chap02": (1, 2),   # background.qmd:    1 chapter
    "chap03": (2, 5),   # history_hk.qmd:    3 chapters (first kept, last 2 demoted)
}
```

The `demote_sub_chapters()` function keeps the first `\chapter{}` in each group and demotes the rest:
- `\chapter{}` → `\section{}`
- `\section{}` → `\subsection{}`
- `\subsection{}` → `\subsubsection{}`
