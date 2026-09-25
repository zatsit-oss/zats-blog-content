---
name: build
description: Build the blog with the zats-blog shell and run its quality gates
---

Same checks as CI (`.github/actions/astro/action.yml`), run from the sibling shell.
First check that `../zats-blog-content` points to this repository (see `/dev`).

```bash
cd ../zats-blog
npm run check        # TypeScript + content schema (frontmatter errors show up here)
npm run build        # dist/ + Pagefind index
npm run check:a11y   # WCAG contrasts
npm run check:eco    # page weight budgets
```

Every command fails on error. Report content errors (missing date, unknown category, schema error)
against the post that caused them, and fix the post, not the shell. Also scan the build output for
`[admonitions] type inconnu` warnings: an unknown admonition type does not fail the build.
`npm run preview` then serves `dist/` with working search.
