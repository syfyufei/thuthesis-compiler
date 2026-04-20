<div align="center">

<br />

<a href="https://adriansun.drhuyue.site/thu-forge/">
  <img alt="thu-forge" src="https://img.shields.io/badge/thu--forge-_一条命令_生成_thuthesis_PDF-1F2A37?style=for-the-badge&labelColor=F6F0E1" />
</a>

# *thu — forge*

**将 [Quarto](https://quarto.org/) book 格式的学位论文「锻造」为 清华大学学位论文 PDF**
*使用上游 [thuthesis](https://github.com/tuna/thuthesis) LaTeX 模板排版。*

<br />

[![主页](https://img.shields.io/badge/主页-→-E35D3F?style=for-the-badge&labelColor=1F2A37)](https://adriansun.drhuyue.site/thu-forge/)
[![License](https://img.shields.io/badge/thu--forge-MIT-2B7A7B?style=for-the-badge&labelColor=1F2A37)](LICENSE)
[![thuthesis](https://img.shields.io/badge/thuthesis-LPPL_1.3c-E35D3F?style=for-the-badge&labelColor=1F2A37)](https://www.latex-project.org/lppl/lppl-1-3c/)

[English](README.md) · **简体中文**

</div>

---

<div align="center">

```text
.qmd  →  quarto render  →  index.tex  →  拆分  →  chapN.tex  →  XeLaTeX×3 + BibTeX  →  main.pdf
```

</div>

## ✦ 快速上手

**本地安装** — 克隆本仓库并注册为 marketplace：

```bash
git clone https://github.com/syfyufei/thu-forge.git
claude plugin marketplace add ./thu-forge
claude plugin install thu-forge@thu-forge
```

**或免安装试用** — 在任意 Claude Code 会话中用 `--plugin-dir`：

```bash
claude --plugin-dir ./thu-forge
```

然后在你的论文项目目录下调用：

```text
/thu-forge:compile
```

你也可以直接对 Claude 说「帮我编译 Quarto 清华学位论文」或「构建 thuthesis PDF」，skill 会自动触发——无需手敲斜杠命令。

---

## ✦ 功能概述

`thu-forge` 负责编排完整的 Quarto → PDF 流水线，让你不必手动照看 XeLaTeX。

| 步骤 | 作用 |
| :--- | :--- |
| **章节拆分** | 将 Quarto 输出的扁平 `\chapter{}` 映射回各章独立 `.tex` 文件 |
| **标题降级** | 把 `.qmd` 内部的二级标题从 `\chapter{}` 降为 `\section{}` |
| **引用格式修正** | 确保 `[@key]` 被正确转换为 `\citep{key}`，而非字面 `{[}@key{]}` |
| **图片路径修正** | 给路径加 `../` 前缀，使其能在 `thuthesis/` 子目录下正确解析 |
| **BibTeX 集成** | 合并多个 `.bib` 文件，并绕过 `thuthesis.cls` 中的 `bibunits` 劫持 |
| **日志检查** | 自动扫描 LaTeX 错误、未定义引用、缺失图片 |

---

## ✦ 期望的项目结构

```text
project/
├── _quarto.yml              ← 必须包含 bibliography 与 cite-method: natbib
├── chapters/
│   ├── 01intro.qmd
│   ├── 02background.qmd
│   └── …
├── references.bib
└── thuthesis/               ← 用户自行获取的上游 thuthesis 仓库
    ├── build.sh
    ├── recompile.sh
    ├── main.tex
    ├── thusetup.tex
    ├── ref/
    │   └── references.bib   ← 合并后的参考文献（自动生成）
    └── scripts/
        ├── split_quarto_tex_v2.py
        └── consolidate_bibs.py
```

---

## ✦ 运行要求

<table>
<tr>
<td>

- [Quarto](https://quarto.org/) CLI
- XeLaTeX（TeX Live 或 MacTeX）

</td>
<td>

- Python 3（拆章与 bib 合并脚本）
- [thuthesis](https://github.com/tuna/thuthesis) LaTeX 模板 *（请自行从上游获取）*

</td>
</tr>
</table>

---

## ✦ 参考文档

- [`skills/thu-forge/references/chapter-groups.md`](skills/thu-forge/references/chapter-groups.md) — 章节结构变化时如何更新 `CHAPTER_GROUPS`*（避免静默内容损坏的关键）*
- [`skills/thu-forge/references/pitfalls.md`](skills/thu-forge/references/pitfalls.md) — 已知陷阱清单：症状、根因、修复方法

---

## ✦ 与上游 thuthesis 的关系

> [!IMPORTANT]
> 本项目是一个**独立的编译编排工具**，服务于使用 [TUNA](https://github.com/tuna) 维护的 `thuthesis` LaTeX 模板（<https://github.com/tuna/thuthesis>）撰写的学位论文。

- `thu-forge` **不打包、不修改、不再分发** `thuthesis`。你必须自行从官方仓库获取上游模板。
- `thu-forge` **与 thuthesis 维护者无任何关联，也未获其背书或支持**。请**不要**将使用 `thu-forge` 过程中遇到的问题反馈到 `tuna/thuthesis` 的 issue tracker。
- `thuthesis` 模板采用 [LPPL 1.3c](https://www.latex-project.org/lppl/lppl-1-3c/) 协议。使用 `thu-forge` 的用户仍需自行遵守 LPPL 1.3c 条款，包括清华大学校徽文件（`thu-fig-logo.pdf`、`thu-text-logo.pdf`）的商标限制——这些文件**仅能**在模板规定的用途（如封面）中使用。
- 若你在使用本 skill 的过程中对上游 `thuthesis` 文件做了修改，你自己需负责遵守 LPPL 1.3c §6 的相关条款（显著标注修改内容、提供未修改原版的获取途径、不得暗示上游作者提供支持）。

---

## ✦ 许可证

`thu-forge` 本身采用 MIT 协议。它所驱动的 `thuthesis` LaTeX 模板单独采用 LPPL 1.3c 协议，**并不包含在本仓库中**。

<div align="center">
<br />
<sub><em>一条命令 · thuthesis · 搞定</em></sub>
<br /><br />
</div>
