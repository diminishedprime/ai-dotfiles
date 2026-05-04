---
name: zensical
description:
  Reference docs for Zensical, a static site generator with extended markdown.
  Use when the user asks how to do something in Zensical - configuration,
  authoring features (admonitions, mermaid, code annotations, content tabs,
  etc.), CLI commands - or when editing markdown in a repo that contains
  `mkdocs.yml` or `zensical.toml`.
user-invocable: true
---

# Zensical

## About these references

The contents of `references/` were vendored from the upstream Zensical docs at a
point in time. Treat them as your primary source of truth for what Zensical can
do and how it works.

If you see concrete evidence that they're out of date, say so inform the user
they should re-vendor from upstream.

## Markdown standards

When writing or editing markdown content for a Zensical site:

- **Use reference-style links, implicit form.** Write `[text]` in prose and
  define `[text]: url` in a single block at the very bottom of the file. Do not
  scatter link definitions next to the prose, even temporarily. Avoid the
  explicit `[text][label]` form - the label is just noise. Only use the explicit
  form when two links share the same display text but point to different URLs
  (which should generally be avoided anyway).
- **In-site links must be relative paths.** Absolute paths within the site (e.g.
  `/setup/extensions/`) do not resolve - use a relative path (e.g.
  `../setup/extensions/index.md`) instead. Absolute URLs to external sites are
  fine.

## Authoring capabilities (draft)

- `references/authoring/admonitions.md` - collapsible, nestable callout boxes
  (note, warning, tip, etc.)
- `references/authoring/code-blocks.md` - syntax highlighting, line numbers,
  line highlighting, inline annotations, snippet inclusion from other files via
  the `--8<--` "scissors" syntax
- `references/authoring/content-tabs.md` - group alternative content under tabs
  (e.g. Windows vs. Mac instructions)
- `references/authoring/diagrams.md` - Mermaid.js diagrams (flowchart, sequence,
  state, class, ER, ...) via fenced `mermaid` blocks.

  Note: Prefer prose; reach for diagrams only when prose genuinely cannot convey
  the structure.

- `references/authoring/footnotes.md` - inline footnote references; optionally
  render as tooltips
- `references/authoring/formatting.md` - keyboard keys (`++ctrl+s++`),
  highlighted text (`==text==`), subscript (`H~2~O`), superscript (`A^T^A`)
- `references/authoring/frontmatter.md` - per-page YAML metadata: title,
  description, icon, sidebar visibility
- `references/authoring/images.md` - image alignment, captions (figures),
  lazy-loading, light/dark variants.

  Note: When using `{ ... }` attribute suffixes (e.g. `{ target=_blank }`), wrap
  in a prettier-ignore - prettier doesn't understand the attr_list extension and
  will mangle them.

- `references/authoring/lists.md` - unordered, ordered, definition, and task
  lists
- `references/authoring/markdown.md` - base markdown dialect (Python-Markdown);
  4-space indent rule; cross-page linking
- `references/authoring/tooltips.md` - abbreviations and project-wide glossaries
  with hover tooltips

### Less commonly needed

These exist and Zensical supports them; only use when the user explicitly asks.

- `references/authoring/buttons.md`
- `references/authoring/data-tables.md`
- `references/authoring/grids.md`
- `references/authoring/icons-emojis.md`
- `references/authoring/math.md`

## Site setup and CLI usage

`references` also covers configuring and running Zensical itself. These spots
are valuable when the question is about the site rather than its content:

- `references/setup/` - `mkdocs.yml` / `zensical.toml` configuration: theme,
  navigation, search, extensions, etc.
- `references/usage/` - the `zensical` CLI: `new`, `build`, `preview`.

There is no curated capability map for these; grep/skim the relevant
subdirectory as needed.
