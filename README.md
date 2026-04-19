# thuthesis-compiler

A Claude Code skill that compiles a [Quarto](https://quarto.org/) book dissertation (`.qmd` chapters) into a [thuthesis](https://github.com/tuna/thuthesis)-formatted PDF via XeLaTeX.

## What it does

The skill orchestrates the full build pipeline:

```
.qmd files → quarto render --to pdf → index.tex
           → split_quarto_tex_v2.py  → chap01–09.tex
           → XeLaTeX (×3) + BibTeX  → main.pdf
```

At each step it handles:
- **Chapter splitting** — maps flat `\chapter{}` output from Quarto back to individual chapter files
- **Heading demotion** — converts `\chapter{}` → `\section{}` etc. for sub-headings within a `.qmd`
- **Citation conversion** — ensures `[@key]` becomes `\citep{key}`, not literal `{[}@key{]}`
- **Image path fixing** — prepends `../` so paths resolve from the `thuthesis/` subdirectory
- **BibTeX integration** — merges `.bib` files and works around the `bibunits` hijack in `thuthesis.cls`
- **Log inspection** — checks for LaTeX errors, undefined citations, and missing figures

## Installation

```bash
bash install.sh
```

Or manually:
```bash
claude plugin install thuthesis-compiler
```

## Usage

```
/thuthesis-compiler:compile
```

Invoke this command from within your dissertation project directory. The skill will verify your configuration, validate `CHAPTER_GROUPS`, run the build, and report any errors.

## Project Structure Expected

```
project/
├── _quarto.yml              # must have bibliography + cite-method: natbib
├── chapters/
│   ├── 01intro.qmd
│   ├── 02background.qmd
│   └── ...
├── references.bib
└── thuthesis/
    ├── build.sh             # full build script
    ├── recompile.sh         # XeLaTeX-only recompile
    ├── main.tex
    ├── thusetup.tex
    ├── ref/
    │   └── references.bib   # merged bibliography (generated)
    └── scripts/
        ├── split_quarto_tex_v2.py
        └── consolidate_bibs.py
```

## Reference Docs

- [`references/chapter-groups.md`](references/chapter-groups.md) — How to update `CHAPTER_GROUPS` when chapter structure changes (critical for avoiding silent content corruption)
- [`references/pitfalls.md`](references/pitfalls.md) — 11 known pitfalls with symptoms, root causes, and fixes

## Requirements

- [Quarto](https://quarto.org/) CLI
- XeLaTeX (via TeX Live or MacTeX)
- Python 3 (for split and consolidate scripts)
- thuthesis LaTeX class installed

## License

MIT
