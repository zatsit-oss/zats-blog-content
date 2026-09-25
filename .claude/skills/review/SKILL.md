---
name: review
description: Review content changes (posts, authors, images) before a pull request
---

Review the current changes (`git diff` against the default branch, `main` here or `main_training` in the training mirror, plus untracked files under `blog/` and `authors/`).

## Checklist

### Structure
- Post at `blog/<category>/YYYY-MM-DD-slug/index.md`, category listed in `config.json`
- Frontmatter has `slug`, `title`, `authors`, `tags`, no `category` key; every author exists in `authors/authors.yml`
- `date`, when present, is the intended publication date
- Hooks pass: run each `.hooks/*.sh`

### Markdown
- Only supported syntax: `:::note|info|tip|warning|caution|danger`, `$$` blocks, `<!-- truncate -->`
  (an unknown admonition type only produces a build warning, so check the spelling here)
- No MDX, no imports, no raw `<iframe>` or `<script>`
- Excerpt above `<!-- truncate -->` (or a `description`) reads well on its own
- No leading `# H1` repeating the title

### Images & a11y
- WebP/AVIF/SVG, stored in the post folder, relative paths, no hotlinking
- Meaningful French alt text, credits for licensed images
- Heading levels don't skip; link texts are descriptive

### Writing
- French, consistent tone, no fabricated facts; sources linked
- Code blocks fenced with a language

### Security
- No secrets, tokens, internal URLs or personal data in text, code or screenshots

Report findings grouped by file, most severe first.
