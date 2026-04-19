---
name: thuthesis-compiler
description: Compile Quarto book (.qmd chapters) into a thuthesis-formatted PDF dissertation. Trigger when the user asks to compile, build, or render the dissertation to PDF, or when troubleshooting LaTeX/BibTeX errors in a thuthesis project.
---

# thuthesis Compiler

This skill compiles a Quarto book dissertation (`.qmd` chapters) into a thuthesis-formatted PDF via XeLaTeX. It orchestrates chapter splitting, heading demotion, citation conversion, image path fixing, and BibTeX integration.

## Pipeline

```
.qmd files → quarto render --to pdf → index.tex
           → split_quarto_tex_v2.py  → chap01–09.tex
           → XeLaTeX (×3) + BibTeX  → main.pdf
```

## Key Files

| File | Purpose |
|------|---------|
| `_quarto.yml` | Quarto config; must have `bibliography` and `cite-method: natbib` |
| `thuthesis/build.sh` | One-click full build (runs entire pipeline) |
| `thuthesis/recompile.sh` | XeLaTeX-only recompilation (3 passes + BibTeX) |
| `thuthesis/scripts/split_quarto_tex_v2.py` | Chapter splitting + heading demotion + cleanup |
| `thuthesis/scripts/consolidate_bibs.py` | Merge multiple `.bib` files into one |
| `thuthesis/thusetup.tex` | Template config (fonts, macros, preamble fixes) |
| `thuthesis/main.tex` | LaTeX main file (includes chapters, backmatter) |
| `references.bib` | Master bibliography file |

## Invocation

```
/thuthesis-compiler:compile
```

See [`commands/compile.md`](commands/compile.md) for the full step-by-step execution checklist.

## Reference Docs

- [`references/chapter-groups.md`](references/chapter-groups.md) — How to update `CHAPTER_GROUPS` when chapter structure changes
- [`references/pitfalls.md`](references/pitfalls.md) — 11 known pitfalls with diagnosis and fixes
