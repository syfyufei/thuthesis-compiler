<div align="center">

<br />

<a href="https://adriansun.drhuyue.site/thu-forge/">
  <img alt="thu-forge" src="https://img.shields.io/badge/thu--forge-_one_command_thuthesis_PDF-1F2A37?style=for-the-badge&labelColor=F6F0E1" />
</a>

# *thu — forge*

**Forge a [Quarto](https://quarto.org/) book dissertation into a 清华大学学位论文 PDF**
*typeset with the upstream [thuthesis](https://github.com/tuna/thuthesis) LaTeX class.*

<br />

[![Homepage](https://img.shields.io/badge/homepage-→-E35D3F?style=for-the-badge&labelColor=1F2A37)](https://adriansun.drhuyue.site/thu-forge/)
[![License](https://img.shields.io/badge/thu--forge-MIT-2B7A7B?style=for-the-badge&labelColor=1F2A37)](LICENSE)
[![thuthesis](https://img.shields.io/badge/thuthesis-LPPL_1.3c-E35D3F?style=for-the-badge&labelColor=1F2A37)](https://www.latex-project.org/lppl/lppl-1-3c/)

**English** · [简体中文](README.zh-CN.md)

</div>

---

<div align="center">

```text
.qmd  →  quarto render  →  index.tex  →  split  →  chapN.tex  →  XeLaTeX×3 + BibTeX  →  main.pdf
```

</div>

## ✦ Quickstart

**Local install** — clone this repo and register it as a marketplace:

```bash
git clone https://github.com/syfyufei/thu-forge.git
claude plugin marketplace add ./thu-forge
claude plugin install thu-forge@thu-forge
```

**Or try it without installing** — use `--plugin-dir` in any Claude Code session:

```bash
claude --plugin-dir ./thu-forge
```

Then, from inside your dissertation project:

```text
/thu-forge:compile
```

Claude can also auto-invoke the skill when you ask it to *"compile my Quarto thesis"* or *"build the thuthesis PDF"* — no slash command needed.

---

## ✦ What it does

`thu-forge` orchestrates the full Quarto → PDF pipeline so you don't have to babysit XeLaTeX.

| Stage | What happens |
| :--- | :--- |
| **Chapter splitting** | Maps Quarto's flat `\chapter{}` output back to individual chapter files |
| **Heading demotion** | Converts `\chapter{}` → `\section{}` for sub-headings inside a `.qmd` |
| **Citation conversion** | Ensures `[@key]` becomes `\citep{key}`, not literal `{[}@key{]}` |
| **Image path fixing** | Prepends `../` so paths resolve from the `thuthesis/` subdirectory |
| **BibTeX integration** | Merges `.bib` files and works around the `bibunits` hijack in `thuthesis.cls` |
| **Log inspection** | Checks for LaTeX errors, undefined citations, and missing figures |

---

## ✦ Expected project structure

```text
project/
├── _quarto.yml              ← must have bibliography + cite-method: natbib
├── chapters/
│   ├── 01intro.qmd
│   ├── 02background.qmd
│   └── …
├── references.bib
└── thuthesis/               ← upstream thuthesis checkout (user-supplied)
    ├── build.sh
    ├── recompile.sh
    ├── main.tex
    ├── thusetup.tex
    ├── ref/
    │   └── references.bib   ← merged bibliography (generated)
    └── scripts/
        ├── split_quarto_tex_v2.py
        └── consolidate_bibs.py
```

---

## ✦ Requirements

<table>
<tr>
<td>

- [Quarto](https://quarto.org/) CLI
- XeLaTeX (TeX Live or MacTeX)

</td>
<td>

- Python 3 (split + consolidate scripts)
- [thuthesis](https://github.com/tuna/thuthesis) LaTeX class *(obtain from upstream)*

</td>
</tr>
</table>

---

## ✦ Reference docs

- [`skills/thu-forge/references/chapter-groups.md`](skills/thu-forge/references/chapter-groups.md) — how to update `CHAPTER_GROUPS` when chapter structure changes *(critical for avoiding silent content corruption)*
- [`skills/thu-forge/references/pitfalls.md`](skills/thu-forge/references/pitfalls.md) — known pitfalls with symptoms, root causes, and fixes

---

## ✦ Relationship to upstream thuthesis

> [!IMPORTANT]
> `thu-forge` is an **independent build orchestrator** for dissertations typeset with the `thuthesis` LaTeX class maintained by [TUNA](https://github.com/tuna) at <https://github.com/tuna/thuthesis>.

- `thu-forge` does **not** bundle, modify, or redistribute `thuthesis`. You must obtain the upstream class yourself from the official repository.
- `thu-forge` is **not affiliated with, endorsed by, or supported by** the `thuthesis` maintainers. Do not report issues encountered with `thu-forge` to the `tuna/thuthesis` issue tracker.
- The `thuthesis` class is licensed under [LPPL 1.3c](https://www.latex-project.org/lppl/lppl-1-3c/). Users of `thu-forge` remain responsible for complying with LPPL 1.3c terms, including trademark restrictions on the Tsinghua University logo files (`thu-fig-logo.pdf`, `thu-text-logo.pdf`), which may be used **only** within the template for their intended purpose.
- If you modify upstream `thuthesis` files while using this skill, you are responsible for complying with LPPL 1.3c §6 (prominent change notices, pointer to unmodified upstream copy, no implication of upstream support).

---

## ✦ License

`thu-forge` itself is MIT-licensed. The `thuthesis` LaTeX class it drives is separately licensed under LPPL 1.3c and is **not** included in this repository.

<div align="center">
<br />
<sub><em>one command · thuthesis · done</em></sub>
<br /><br />
</div>
