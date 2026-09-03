# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this repository is

This is the **content repository** for the **zatsit blog** (<https://blog.zatsit.fr>).
It holds blog posts and author metadata only, **not** the site itself.

The Astro configuration, theme, layouts and build live in a **separate sibling
repository** (`zats-blog`). Do not look here for `astro.config.mjs`, components,
or CSS: they are not in this repo. Its content loader reads this repository in
place, through `CONTENT_REPO = '../zats-blog-content'`, so nothing is copied.
The directory name is part of the contract: the shell resolves author avatars
with a literal glob that Vite only analyses because it is literal.

- **Stack:** Astro 7, plain Markdown (no MDX), French content, Pagefind search, block math and admonitions through local plugins.
- **Deployment:** PR → ephemeral Firebase preview channel; merge to `main` → build and upload to the `zatsit-blog-prod` GCS bucket, which serves the site.
- **Default language of published content:** **French.**

## Repository layout

```
blog/                 # Blog posts, grouped by category folder
  ai/ architecture/ cloud/ data/ dev/ general/ green/ mobile/ ops/ web/
    YYYY-MM-DD-slug/  # One folder per post
      index.md        # The post (required)
      *.webp ...      # Post-local images
authors/
  authors.yml         # Author registry (referenced by post frontmatter)
  img/                # Author avatars (.webp)
docs/                 # Empty, and not read by the site build
config.json           # Canonical list of allowed categories
.hooks/               # Local validation scripts (run via pre-commit)
POSTING.md            # Human authoring guide — read it before writing a post
CONTRIBUTING.md       # Contribution process
```

## Golden rules

1. **Never fabricate technical content.** Do not invent facts, benchmarks, quotes,
   API behavior, or details about a tool. If a source (screenshot, doc, link) is
   ambiguous or missing, ask the user instead of guessing.
2. **Published post content is written in French.** Match the tone and language of
   existing posts. (Repo meta files like this one and READMEs are in English.)
3. **Respect the validation hooks** (see below). Code/structure must pass them —
   fix the content, never weaken a hook or ruleset to silence an error.
4. **Commits are signed.** Do not amend, force-push, or rewrite history. Do not
   commit to `main` — work on a feature branch. Only commit/push when asked.
5. **No AI-attribution** in commit messages or PR descriptions (no `Co-Authored-By`,
   no "Generated with…").

## Authoring a new post

Full human guide: **`POSTING.md`**. Summary for agents:

### 1. Pick a category
The post folder must live directly under one of the categories listed in
`config.json`: `ai`, `architecture`, `cloud`, `data`, `dev`, `general`, `green`,
`mobile`, `ops`, `web`. Choose the single best-fit category; use `tags` for the rest.
Do **not** invent a new category — that requires asking the team (dirtech@zatsit.fr).

### 2. Create the post folder
Path: `blog/<category>/YYYY-MM-DD-<slug>/index.md`

The folder name **must** match `^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-zA-Z0-9-]+$`
(enforced by `.hooks/check_post-directory-name.sh`). That means dashed dates:
`2026-06-12-my-post`, **not** `20260612-my-post`. Some older folders use the
compact form; the dashed form is the canonical one — follow it for new posts.

### 3. Write the frontmatter
`index.md` must start with YAML frontmatter. `slug`, `title`, `authors` and
`tags` are required (enforced by `.hooks/check_post-headers.sh`); the rest is
optional:

```md
---
slug: my-post-uri
title: My Post Title
authors: [jdoe]
date: 2026-06-12
tags:
  - "architecture"
  - "web"
---

One or two French sentences summarizing the post — shown in the list/preview page.

<!-- truncate -->

Rest of the article…
```

- `slug`: the public URI (under `/blog/`).
- `authors`: a list of **keys that must exist in `authors/authors.yml`** (the hook
  verifies this). If the author is new, add them first (see below).
- `tags`: quoted strings, used for cross-category indexing.
- `date`: publication date. Optional, because the shell derives it from the
  `YYYY-MM-DD-` prefix of the folder name when it is absent, and frontmatter
  wins when both exist. Write it anyway, and double-check it during review.
- The category is **never** written in the frontmatter: it is derived from the
  folder the article sits in, and validated against `config.json`.
- Also accepted, all optional: `description` (overrides the excerpt for social
  cards and previews), `cover`, `draft`, and `shareText` (see the share links
  below).
- The `<!-- truncate -->` marker separates the list-page excerpt from the body.

### 4. Images & media
- Store all post images **inside the post folder** (subfolders allowed).
- Prefer `webp` or `avif`; otherwise use the smallest reasonable size (this blog is
  eco-design conscious — page weight matters).
- Always provide **alt text** for accessibility, and **credit** images per their license.
- **Videos:** never embed via `<iframe>` (not performant / not green). Link a thumbnail
  image to the video instead, see the AsyncAPI post for the pattern.
- **Sizing:** do not resize images by hand for the layout. The build generates a
  responsive `srcset` and caps any image at 1366px wide.
- **Math:** `$$…$$` blocks only. A single `$` is left as literal text on purpose,
  so there is no inline math.
- **Admonitions:** `:::note`, `:::info`, `:::tip`, `:::warning`, `:::caution` or
  `:::danger`, closed by `:::`. Any other name is left as plain text.
- **Share links:** nothing to add in the article. The shell renders the LinkedIn
  and X links at the bottom of every post, using `shareText` if present and the
  title otherwise.

## Adding / editing an author

Edit `authors/authors.yml`. Key convention: all lowercase, first letter of first
name + last name (e.g. `jdoe` for John Doe). Add the avatar under
`authors/img/`, named after that key: **`authors/img/<key>.webp`**. That
filename is how the shell finds the picture, so a mismatch means no avatar, with
no error.

```yml
jdoe:
  name: John Doe
  title: Site Reliability Engineer
  url: https://github.com/jdoe        # GitHub or LinkedIn
  socials:                            # optional
    github: jdoe
    linkedin: john-doe
    x: jdoe
    bluesky: jdoe.bsky.social
```

Only `name` is required. `image_url` still exists on a few authors and is
**dead**: the shell reads the schema but never uses the value, since avatars are
resolved from the filename. Do not add it to a new author.

## Validation — must pass before merge

Local hooks in `.hooks/` are wired through `.pre-commit-config.yaml`:

| Hook | Checks |
|------|--------|
| `check_categories-list.sh` | Every `blog/*` folder is a category in `config.json` |
| `check_post-directory-name.sh` | Post folders match `YYYY-MM-DD-slug` |
| `check_post-filename.sh` | Each post folder contains `index.md` |
| `check_post-headers.sh` | Frontmatter has `slug`, `title`, `authors`, `tags`; authors exist in `authors.yml` |

The site build adds two checks of its own, and fails rather than publishing a
half-broken page: an article with neither a `date` in its frontmatter nor a date
in its folder name, and a category folder absent from `config.json`.

Run them locally:

```sh
pre-commit run --all-files
# or invoke a single script directly, e.g.:
.hooks/check_post-headers.sh
```

Linting also applies: **markdownlint** (config `.markdownlint.yaml`; `MD013`
line-length disabled; ignores listed in `.markdownlintignore`) and **yamllint**
(`.yamllint`).

## Git & PR workflow

- Branch naming follows **Conventional Commits**: e.g. `feat/dev-2026-06-12-my-post`.
- Commit messages follow Conventional Commits too (`feat(blog): …`, `fix: …`, `chore: …`).
- Commits **must be signed** (SSH signing — see `README.md`).
- Opening a PR triggers a GitHub Actions workflow that builds an **ephemeral preview**
  (Firebase) — check the preview link in the PR checks.
- Workflows live in `.github/workflows/`:
  `firebase-hosting-pull-request.yml`, `publish-on-merge.yml`,
  `update-content-training-on-merge.yml`.

## Quick checklist for a new post

- [ ] Folder: `blog/<valid-category>/YYYY-MM-DD-<slug>/index.md`
- [ ] Frontmatter has `slug`, `title`, `authors`, `tags`, and ideally `date`
- [ ] Every author key exists in `authors/authors.yml`, avatar named `<key>.webp`
- [ ] French content, excerpt + `<!-- truncate -->`
- [ ] Images inside the post folder, `webp`/`avif`, with alt text + credit
- [ ] Hooks pass (`pre-commit run --all-files`)
- [ ] Signed commits on a Conventional-Commits-named branch
