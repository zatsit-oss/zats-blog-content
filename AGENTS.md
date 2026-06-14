# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this repository is

This is the **content repository** for the **zatsit blog** (<https://blog.zatsit.fr>).
It holds blog posts and author metadata only — **not** the site itself.

The Docusaurus configuration, theme, custom pages and build live in a **separate
sibling repository** (`zats-blog`). Do not look here for `docusaurus.config.js`,
React components, or CSS — they are not in this repo. A CI pipeline pulls this
content into the build repo to produce the site.

- **Stack:** Docusaurus 3.x (classic preset), French content, KaTeX math support, Lunr search.
- **Deployment:** PR → ephemeral Firebase preview; merge to `main` → production.
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
docs/                 # Currently essentially empty
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
`index.md` must start with YAML frontmatter containing **all** of these keys
(enforced by `.hooks/check_post-headers.sh`):

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

- `slug` — the public URI (under `/blog/`).
- `authors` — a list of **keys that must exist in `authors/authors.yml`** (the hook
  verifies this). If the author is new, add them first (see below).
- `date` — publication date; double-check it during review.
- `tags` — quoted strings, used for cross-category indexing.
- The `<!-- truncate -->` marker separates the list-page excerpt from the body.

### 4. Images & media
- Store all post images **inside the post folder** (subfolders allowed).
- Prefer `webp` or `avif`; otherwise use the smallest reasonable size (this blog is
  eco-design conscious — page weight matters).
- Always provide **alt text** for accessibility, and **credit** images per their license.
- **Videos:** never embed via `<iframe>` (not performant / not green). Link a thumbnail
  image to the video instead — see the AsyncAPI post for the pattern.
- **Math:** use KaTeX syntax (see Docusaurus math-equations docs).
- **Admonitions:** use Docusaurus admonitions for call-outs.

## Adding / editing an author

Edit `authors/authors.yml`. Key convention: all lowercase, first letter of first
name + last name (e.g. `jdoe` for John Doe). Add the avatar as `.webp` under
`authors/img/`.

```yml
jdoe:
  name: John Doe
  title: Site Reliability Engineer
  url: https://github.com/jdoe        # GitHub or LinkedIn
  image_url: /img/authors/jdoe.webp   # served from the build repo's static/img/authors
  socials:                            # optional
    github: jdoe
    linkedin: john-doe
    x: jdoe
    bluesky: jdoe.bsky.social
```

Note `image_url` uses the runtime path `/img/authors/<key>.webp` (resolved in the
build repo), while the file itself lives in this repo under `authors/img/`.

## Validation — must pass before merge

Local hooks in `.hooks/` are wired through `.pre-commit-config.yaml`:

| Hook | Checks |
|------|--------|
| `check_categories-list.sh` | Every `blog/*` folder is a category in `config.json` |
| `check_post-directory-name.sh` | Post folders match `YYYY-MM-DD-slug` |
| `check_post-filename.sh` | Each post folder contains `index.md` |
| `check_post-headers.sh` | Frontmatter has `slug`, `title`, `authors`, `tags`; authors exist in `authors.yml` |

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
- [ ] Frontmatter has `slug`, `title`, `authors`, `date`, `tags`
- [ ] Every author key exists in `authors/authors.yml`
- [ ] French content, excerpt + `<!-- truncate -->`
- [ ] Images inside the post folder, `webp`/`avif`, with alt text + credit
- [ ] Hooks pass (`pre-commit run --all-files`)
- [ ] Signed commits on a Conventional-Commits-named branch
