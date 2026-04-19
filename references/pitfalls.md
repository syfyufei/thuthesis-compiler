# Known Pitfalls

Hard-won fixes for the quarto-to-thuthesis pipeline. Check this list first when debugging compilation failures.

## Pitfall 1: Chapter Inflation

**Problem**: In Quarto book mode, every `#` heading in every `.qmd` becomes `\chapter{}` in `index.tex`. A single `.qmd` with 5 headings produces 5 chapters instead of 1 chapter + 4 sections.

**Solution**: `split_quarto_tex_v2.py` uses `CHAPTER_GROUPS` to map consecutive `\chapter{}` entries to their source `.qmd`. The `demote_sub_chapters()` function keeps the first `\chapter{}` and demotes the rest:
- `\chapter{}` → `\section{}`
- `\section{}` → `\subsection{}`
- `\subsection{}` → `\subsubsection{}`

**When to update**: After adding or removing `#` headings in any `.qmd` — see [chapter-groups.md](chapter-groups.md).

## Pitfall 2: Citations Not Converted

**Problem**: Without `bibliography:` in `_quarto.yml`, Pandoc converts `[@key]` into literal text `{[}@key{]}` instead of `\citep{key}`.

**Solution**: `_quarto.yml` must contain:
```yaml
bibliography: references.bib
cite-method: natbib
```

**Fallback**: `fix_citations()` in the split script uses regex to convert leftover `{[}@key{]}` patterns to `\citep{key}`.

## Pitfall 3: Image Paths Broken

**Problem**: Quarto generates paths relative to project root (e.g., `chapters/08LegCo/fig.png`), but XeLaTeX compiles from the `thuthesis/` subdirectory.

**Solution**: `fix_image_paths()` prepends `../` to all `\includegraphics` paths so they resolve correctly from `thuthesis/`.

## Pitfall 4: Images Overflow Margins

**Problem**: Pandoc wraps images in `\pandocbounded{}`, which is undefined in thuthesis, so large images exceed `\linewidth`.

**Solution**: Define in `thusetup.tex`:
```latex
\newcommand{\pandocbounded}[1]{%
  \sbox0{#1}%
  \ifdim\wd0>\linewidth \resizebox{\linewidth}{!}{#1}%
  \else #1%
  \fi}
```

## Pitfall 5: Undefined Pandoc Commands

**Problem**: Pandoc 3.x emits commands that thuthesis doesn't define: `\pandocbounded`, `\bookmarksetup{startatroot}`, `\begin{figure}[H]`.

**Solution**: Add to `thusetup.tex`:
```latex
\usepackage{float}
\providecommand{\bookmarksetup}[1]{}
% \pandocbounded defined above (see Pitfall 4)
```

## Pitfall 6: `\end{document}` Leak

**Problem**: Quarto appends `\backmatter\end{document}` to `index.tex`. When split, these land in the last chapter file, causing everything after it (references, appendices, acknowledgements) to vanish from the final PDF.

**Solution**: `clean_pandoc_artifacts()` strips `\backmatter`, `\frontmatter`, `\mainmatter`, and `\end{document}` from all chapter files.

## Pitfall 7: bibunits Hijacks `\bibliography`

**Problem**: `thuthesis.cls` loads the `bibunits` package, which intercepts `\bibliography{}` so `\bibdata` never appears in `main.aux`. BibTeX fails with "I found no database files".

**Solution**: Force-write `\bibdata` in `thusetup.tex`:
```latex
\AtEndDocument{%
  \immediate\write\@mainaux{\string\bibdata{ref/references}}%
}
```

## Pitfall 8: `.bbl` Deleted by Cleanup

**Problem**: The cleanup section in `recompile.sh` includes `rm -f *.bbl`, which deletes the BibTeX output that LaTeX needs on passes 2 and 3.

**Solution**: Remove `*.bbl` from the cleanup list in `recompile.sh`.

## Pitfall 9: Unescaped `&` in `.bib`

**Problem**: Journal names like `Asian Politics & Policy` contain bare `&`, which LaTeX interprets as an alignment tab → "Misplaced alignment tab" error.

**Solution**: All `&` in `.bib` field values must be escaped as `\&`. Check before compilation:
```bash
grep -n '[^\\]&' references.bib
```

## Pitfall 10: Residual `\bookmarksetup`

**Problem**: Pandoc inserts `\bookmarksetup{startatroot}` between chapters for PDF bookmark hierarchy reset. This command is undefined in thuthesis.

**Solution**: `clean_pandoc_artifacts()` removes these with regex. Also guarded by `\providecommand` in `thusetup.tex` (see Pitfall 5).

## Pitfall 11: Stale CHAPTER_GROUPS (Silent Content Corruption)

**Problem**: When `#` headings are added to or removed from `.qmd` files, the total number of `\chapter{}` entries in `index.tex` changes. But `CHAPTER_GROUPS` in `split_quarto_tex_v2.py` still uses the old index ranges. This causes **silent** failures:

- Chapters bleed into each other (e.g., chapter 8 content merged into `chap07.tex`)
- Later chapters point to indices beyond the array, producing `⚠️ 章节 X 超出范围`
- Build log shows `成功提取: N/M 个章节` where N < M (partial extraction)
- Content deleted from `.qmd` files still appears in PDF (it's actually the *next* chapter being pulled into the wrong slot)

This is the most dangerous pitfall because the build may still succeed with 0 LaTeX errors while producing a silently corrupted PDF.

**Detection**: After `quarto render --to pdf`, always run:
```bash
grep -c '\\chapter{' index.tex
```
Compare this count against the sum of all ranges in `CHAPTER_GROUPS`. If they don't match, the mapping is stale.

**Solution**: Follow the procedure in [chapter-groups.md](chapter-groups.md):
1. `grep -n '\\chapter{' index.tex` to list all entries with line numbers
2. Map each entry to its source `.qmd` using `_quarto.yml` chapter order
3. Update `CHAPTER_GROUPS` with correct `(start, end)` tuples
4. Re-run `bash thuthesis/build.sh`

**Prevention**: Step 3 (Validate CHAPTER_GROUPS) in `commands/compile.md` is MANDATORY before every build. Never skip it.
