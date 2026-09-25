# Claude Code Guidelines

**zats-blog-content** holds the **content** of the zatsit blog (<https://blog.zatsit.fr>): articles, authors and their images. It holds no application code. The site is rendered by the Astro 7 shell [zats-blog](https://github.com/zatsit-oss/zats-blog), cloned as a sibling directory, which reads this repository in place.

**Read [AGENTS.md](AGENTS.md) first**: it is the reference for the layout, the frontmatter, images, authors and the validation hooks. This file only adds what is specific to Claude Code.

## Quick Reference

| Topic | File |
|-------|------|
| Repository guide for agents | [AGENTS.md](AGENTS.md) |
| Authoring guide for humans | [POSTING.md](POSTING.md) |
| Writing & repo rules | [.claude/rules/rules.md](.claude/rules/rules.md) |
| Content quality (eco, a11y) | [.claude/rules/quality.md](.claude/rules/quality.md) |
| Security | [.claude/rules/security.md](.claude/rules/security.md) |
| Rendering rules, schema, plugins | `../zats-blog/CLAUDE.md`, `../zats-blog/src/content.config.ts` |

## Skills

| Skill | Description |
|-------|-------------|
| `/new-post <category> <slug>` | Scaffold a post folder and its frontmatter |
| `/dev` | Start the shell's dev server on this content |
| `/build` | Production build of the shell with its quality gates |
| `/review` | Review content changes before a PR |

## Layout

```
blog/<category>/YYYY-MM-DD-slug/index.md   # one folder per post, images beside it
authors/authors.yml                        # author registry
authors/img/<key>.webp                     # avatars, found by file name
config.json                                # closed list of categories
.hooks/                                    # pre-commit validation scripts
.github/                                   # preview (Firebase) and publish (GCS) pipelines
```

## Key Rules

1. **Posts are in French**; repo files (README, AGENTS, hooks, CI) are in English.
2. **Plain Markdown, no MDX.** Only what the shell supports: `:::type` admonitions, `$$` display math, `<!-- truncate -->`.
3. **Never modify a published article** to suit the tooling: the shell supports the existing syntax on purpose.
4. **Fix the content, never weaken a hook** (`.hooks/`) to silence it.
5. **Commits**: Conventional Commits (`type(scope): description`), signed, on a feature branch.
6. **Eco-design**: this blog measures its own weight. Images must be WebP/AVIF, sized for the column, stored in the post folder.

## Hosting

- A PR builds a Firebase preview.
- A merge to `main` rebuilds the shell and uploads `zats-blog/dist/` to the GCS bucket behind `blog.zatsit.fr`.
- Moving to Clever Cloud Cellar is **postponed** (decision D3 bis in `../zats-blog/PLAN-MIGRATION.md`): a bare bucket serves no 404 page, no slash redirect and no security headers.

## Training mirror

[zats-blog-content-training](https://github.com/zatsit-oss/zats-blog-content-training) is the practice repository for newcomers. `update-content-training-on-merge.yml` **force-pushes** this repository's `main` onto its `main_training` branch: the whole branch is replaced, not only `blog/`. Anything committed directly to `main_training` is lost at the next sync, so changes to these guidelines, skills or docs belong **here**. The publish workflow is guarded on the repository name, so the mirror never deploys to production.
