# Preparation for posting a new post

## Table of contents

* [Author information](#author-information)
  * [(**required**) Add your author information](#required-add-your-author-information)
* [Writting environment](#writting-environment)
  * [(facultative) Install pre-commit hooks](#facultative-install-pre-commit-hooks)

## Author information

### (required) Add your author information

Create your author information in the [authors.yml](authors/authors.yml) file.

Your author information block must follow the following structure :

* `<Author Identifier>`: first letter of your first name followed by your name in lowercase
  * `name`: Your full name
  * `title`: Your title
  * `url`: Your personal website or social media account (GitHub, LinkedIn, etc.)
  * `image_url`: Your picture stored in the [zats blog](https://github.com/zatsit-oss/zats-blog) repository under the `static/img/authors` directory.

Eample :

```yml
jdoe:
  name: John Doe
  title: Site Reliability Engineer  @ **zatsit**
  url: Github account or Linkedin account
  image_url: /img/authors/jdoe.webp
```

**The author identifier is used to reference the author in the blog post metadata.**

## Writting environment

### (facultative) Install pre-commit hooks

[Official pre-commit documentation](https://pre-commit.com)

#### Installation

Install the pre-commit tool to ensure that your commits respect the repository's standards.

```bash
# Mac OS
brew install pre-commit
# Other distributions
pip install pre-commit
```

#### Usage

Pre-commit is configured to run automatically on each commit.

If you want to run it manually, use the following command:

```bash
pre-commit run --all-files
```
#### Development

Generic hooks:

* `trailing-whitespace`: Remove trailing whitespaces ([source](https://github.com/pre-commit/pre-commit-hooks))
* `check-added-large-files`: Check for large files added to Git ([source](https://github.com/pre-commit/pre-commit-hooks))
* `check-yaml`: Check for YAML syntax errors ([source](https://github.com/pre-commit/pre-commit-hooks))
* `fix-byte-order-marker`: Chec for byte order marker (BOM) from files and fix them ([source](https://github.com/pre-commit/pre-commit-hooks))
* `end-of-file-fixer`: Ensure that files end with a newline ([source](https://github.com/pre-commit/pre-commit-hooks))
* `mixed-line-ending`: Check for mixed line ending style and fix them ([source](https://github.com/pre-commit/pre-commit-hooks))
* `markdownlint-cli2`: Check for Markdown syntax errors and fix them ([source](https://github.com/DavidAnson/markdownlint-cli2))

Custom hooks:

* `check_categories-list`: Check if the chosen categorie is in the list of available
* `check_post-directory-name`: Check if the post directory name is correct
* `check_post-filename`: Check if the post filename is correct
* `check_post-headers`: Check if the post headers are correct 

### (facultative) Install jq package

#### Installation

Install the jq package.

```bash
sudo apt install -y jq
```

The `jq` package is used by:

* pre-commit hooks [Link to section](./PRE_POSTING.md#facultative-install-pre-commit-hooks)
* `init_post.sh` script [Link to section](./POSTING.md#initialize-your-blog-post---interactive-way)
