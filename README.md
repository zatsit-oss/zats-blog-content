# **zatsit** blog contents repository

This repository holds the contents of the **zatsit** blog. 
Under the hood, it is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

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

Opening your Pull Request will trigger a CI/CD pipeline that will generate 
a preview on your article based on [zatsit blog](https://zatsit.github.io/blog/).
Wait few seconds and check the preview link in the PR checks.
