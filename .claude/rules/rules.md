# Project Rules

## Language
- **Articles: French.** Match the tone of the existing posts.
- **Repository files: English.** README, AGENTS, hooks, CI, commit messages.
- Author titles and share texts are reader-facing, so they are written in French or kept as in `authors.yml`.

## Git Commits (Angular / Conventional Commits)

Format: `type(scope): description`

### Types
- `feat`: New post, or a new feature of the content repo
- `fix`: Correction in a post (typo, wrong fact, broken link) or in a hook
- `docs`: README, POSTING, CONTRIBUTING, AGENTS changes
- `chore`: Authors, images, tags, tooling
- `refactor`: Restructuring without a visible change (folder renames, image conversion)
- `ci`: Workflows and composite actions

### Scope (optional)
The category (`ai`, `dev`, `green`…), or `content`, `authors`, `hooks`.

### Examples
```
feat(ai): add the AI 2027 article
fix(content): host the Redpanda mascot instead of hotlinking it
chore(authors): add author glefebvre
ci: build the Astro shell and upload dist, not build
```

### Rules
- Use imperative mood: "add" not "added" or "adds"
- No capital letter at start of description
- No period at end
- Keep description under 72 characters
- Commits are signed; branch names follow `feat/<category>-YYYY-MM-DD-slug`

## Posts

- Path: `blog/<category>/YYYY-MM-DD-slug/index.md`, category from `config.json` only.
- Frontmatter: `slug`, `title`, `authors`, `tags` required. Never write a `category` key: it comes from the folder. `date`, `description`, `shareText` and `draft` are optional (schema: `../zats-blog/src/content.config.ts`).
- The page title comes from `title`. Don't repeat it as a leading `# H1` in new posts.
- Excerpt: text above `<!-- truncate -->`, or `description` when set.
- Admonitions: `note`, `info`, `tip`, `warning`, `caution`, `danger`. Any other type is not rendered as an admonition, and the build only prints a warning (`[admonitions] type inconnu`): mind the typos.
- Math: `$$` blocks only. A single `$` is literal text.

## Authors

- Key: lowercase, first-name initial + last name (`jdoe`).
- Every key used in a post must exist in `authors/authors.yml` (checked by the hook).
- Avatar: `authors/img/<key>.webp`, named after the key. Don't add `image_url` to a new author: the field is ignored.
