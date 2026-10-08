---
name: dev
description: Start the zats-blog Astro dev server on this content
---

The site is rendered by the sibling shell `../zats-blog`, which reads the content from
`../zats-blog-content` (exact name, hard-coded in its `src/consts.ts` and `src/utils/avatars.ts`).

1. Check that `../zats-blog` exists, and that `../zats-blog-content` is this repository (a symlink to it or the
   checkout itself). If it is another checkout, tell the user: the build would render stale content.
   In the training mirror, the fix is to clone `zats-blog-content-training` under the name `zats-blog-content`,
   or to symlink it there.
2. Start the server:

```bash
cd ../zats-blog && npm run dev
```

The site is on http://localhost:4321 and reloads when an article changes. Search does not work in dev
(Pagefind index is built by `/build`).
