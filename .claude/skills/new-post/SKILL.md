---
name: new-post
description: Scaffold a new blog post folder with valid frontmatter
argument-hint: "<category> <slug>"
---

Create a new post from `$ARGUMENTS` (category, then slug).

1. The category must be in `config.json`. Otherwise stop and tell the user that a new category goes through
   dirtech@zatsit.fr.
2. Ask for the title, the author keys and the tags if they were not given. Every author key must exist in
   `authors/authors.yml`; if not, offer to add the author (key, name, title, url, avatar `authors/img/<key>.webp`, no `image_url`).
3. Create `blog/<category>/<YYYY-MM-DD>-<slug>/index.md` with today's date:

```md
---
slug: <slug>
title: <Titre en français>
authors: [<key>]
tags: [<tag>, <tag>]
---

<Une ou deux phrases qui résument l'article, affichées dans la liste.>

<!-- truncate -->

## <Première section>
```

4. Do not write the article body unless asked, and never invent facts.
5. Run `.hooks/check_post-directory-name.sh` and `.hooks/check_post-headers.sh` and report the result.
