# Quality Principles

**Important**: this blog publishes about eco-design and measures its own weight
(`check:eco` in the shell, EcoIndex badge). Its content must lead by example.

## Images (Eco-design)
- WebP or AVIF only for photos and illustrations; SVG for diagrams.
- Store images inside the post folder, referenced with a relative path (`./img.webp`).
- Never hotlink an external image: host it in the post folder.
- Don't commit huge source photos. The shell caps widths at 1366px, so larger sources only make the repo heavier.
- Avatars stay small (they are displayed at 64px).

## Media
- No `<iframe>` embeds (YouTube…): link a local thumbnail to the video instead.
- No external scripts, widgets or tracking snippets in posts.

## Accessibility (a11y)
- Every image has a meaningful French `alt` text; decorative images use empty alt.
- Keep a logical heading hierarchy (`##` then `###`); don't skip levels.
- Link texts describe their target (no bare "ici" / "click here").
- Credit images according to their license.

## Content
- Never fabricate facts, figures, quotes or tool behavior; cite sources.
- Keep code blocks fenced with a language, so the shell highlights them.
- Wide tables are fine: the shell makes them keyboard-scrollable.

## Checklist before a PR
- [ ] `pre-commit run --all-files` passes (or each `.hooks/*.sh` script)
- [ ] Images are WebP/AVIF/SVG, in the post folder, with alt text
- [ ] Shell build passes locally (`/build`), or the Firebase preview renders correctly
- [ ] Post reviewed in light and dark theme on the preview
