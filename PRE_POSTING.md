# Preparation for posting a new post

## Table of contents

* [Author information](#author-information)
  * [(**required**) Add your author information](#required-add-your-author-information)

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
