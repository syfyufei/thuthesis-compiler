# thu-forge

**English** | [简体中文](README.zh-CN.md)

🌐 **[Visit the homepage →](https://adriansun.drhuyue.site/thu-forge/)**

> Forge a [Quarto](https://quarto.org/) book dissertation into a **清华大学学位论文** PDF, typeset with the upstream [thuthesis](https://github.com/tuna/thuthesis) LaTeX class.

`thu-forge` is a Claude Code skill that orchestrates the full compilation pipeline from Quarto `.qmd` sources to a thuthesis-formatted PDF via XeLaTeX.

```
.qmd → quarto render → index.tex → split → chapN.tex → XeLaTeX×3 + BibTeX → main.pdf
```

## Relationship to upstream thuthesis

This project is an **independent build orchestrator** for dissertations that are typeset with the `thuthesis` LaTeX class maintained by [TUNA](https://github.com/tuna) at <https://github.com/tuna/thuthesis>.

- `thu-forge` does **not** bundle, modify, or redistribute `thuthesis`. You must obtain the upstream class yourself from the official repository.
- `thu-forge` is **not affiliated with, endorsed by, or supported by** the `thuthesis` maintainers. Do not report issues encountered with `thu-forge` to the `tuna/thuthesis` issue tracker.
- The `thuthesis` class is licensed under [LPPL 1.3c](https://www.latex-project.org/lppl/lppl-1-3c/). Users of `thu-forge` remain responsible for complying with LPPL 1.3c terms, including trademark restrictions on the Tsinghua University logo files (`thu-fig-logo.pdf`, `thu-text-logo.pdf`), which may be used **only** within the template for their intended purpose.
- If you modify the upstream `thuthesis` files while using this skill, you are responsible for complying with LPPL 1.3c §6 (prominent change notices, pointer to unmodified upstream copy, no implication of upstream support).

## What it does

The skill orchestrates the full Quarto → PDF pipeline:

- **Chapter splitting** — maps flat `\chapter{}` output from Quarto back to individual chapter files
- **Heading demotion** — converts `\chapter{}` → `\section{}` for sub-headings inside a `.qmd`
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
claude plugin install thu-forge
```

## Usage

```
/thu-forge:compile
```

Invoke from within your dissertation project directory. The skill verifies your configuration, validates `CHAPTER_GROUPS`, runs the build, and reports any errors.

## Expected Project Structure

```
project/
├── _quarto.yml              # must have bibliography + cite-method: natbib
├── chapters/
│   ├── 01intro.qmd
│   ├── 02background.qmd
│   └── ...
├── references.bib
└── thuthesis/               # upstream thuthesis checkout (user-supplied)
    ├── build.sh
    ├── recompile.sh
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
- [`references/pitfalls.md`](references/pitfalls.md) — Known pitfalls with symptoms, root causes, and fixes

## Requirements

- [Quarto](https://quarto.org/) CLI
- XeLaTeX (via TeX Live or MacTeX)
- Python 3 (for split and consolidate scripts)
- [thuthesis](https://github.com/tuna/thuthesis) LaTeX class (obtain from upstream)

## License

`thu-forge` itself is MIT-licensed. The `thuthesis` LaTeX class it drives is separately licensed under LPPL 1.3c and is **not** included in this repository.
