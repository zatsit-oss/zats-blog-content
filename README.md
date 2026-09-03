# **zatsit** blog contents repository

This repository holds the contents of the **zatsit** blog: articles, authors and
their pictures. Nothing else.

The site itself lives in [zats-blog](https://github.com/zatsit-oss/zats-blog),
built with [Astro](https://astro.build/). Its loader reads this repository in
place, next to it, so there is no copy and no synchronisation step.

Feel free to contribute to the blog by creating a pull request.

- [Code of conduct](./CODE_OF_CONDUCT.md)
- [Contributing](./CONTRIBUTING.md)
- [Posting](./POSTING.md)

## Pre-requisites

Committing on this repository requires to do signed commits.
To enable signed commits,

- register your SSH public key in your GitHub account as **Signing key** `Key type
- configure your Git CLI **globally** to sign commits by default.

```
git config --global gpg.format ssh
# here replace ~/.ssh/examplekey.pub with your own public key path
git config --global user.signingkey ~/.ssh/examplekey.pub

git config --global commit.gpgsign true
```

> You can also follow [those instructions](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/signing-commits).

## Write a new post

Please follow the [posting guidelines](./POSTING.md) to write a new post.

Opening your Pull Request triggers a GitHub Actions workflow that builds the
site and deploys it to an ephemeral Firebase preview channel. Wait a few seconds
and check the preview link commented on the PR.

Merging to `main` publishes to <https://blog.zatsit.fr>, a GCS bucket fed by the
same pipeline.

## Preview locally

Optional, and only useful to check rendering before opening a PR. Clone the site
repository **beside** this one, the directory names matter:

```
your-workspace/
├── zats-blog/          ← the site
└── zats-blog-content/  ← this repository
```

```bash
git clone git@github.com:zatsit-oss/zats-blog.git
cd zats-blog
npm install
npm run dev
```

Editing an article here shows up immediately. Search is the exception: its index
is produced by the build, so it needs `npm run build && npm run preview`.
