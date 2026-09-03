# Posting in **zatsit** Blog

> The site is built with [Astro](https://astro.build/), in the
> [zats-blog](https://github.com/zatsit-oss/zats-blog) repository. Articles are
> plain Markdown: no MDX, no components, nothing to import.

Posts sit in a top level folder hierarchy that categorizes them, and the folder
they are in **is** their category:

- [ai](blog%2Fai)
- [architecture](blog%2Farchitecture)
- [cloud](blog%2Fcloud)
- [data](blog%2Fdata)
- [dev](blog%2Fdev)
- [general](blog%2Fgeneral)
- [green](blog%2Fgreen)
- [mobile](blog%2Fmobile)
- [ops](blog%2Fops)
- [web](blog%2Fweb)

> If you think you need a new category, please contact [DT](mailto:dirtech@zatsit.fr).

> If you think your post belongs to more than one category, choose the main one to create it. 
> Don't worry, the tags of your post index it across the other categories.

## Create a post for the first time

First of all, pull the project repository and create a branch like "feat/category-YYYYMMDD-SLUG"
> SLUG will be your future URI

```sh
git clone xxxxx
git branch -c feat/category-YYYYMMDD-MyTitle
```

> We are using the conventional commits way, so you have to follow the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) to name your branch.

You are ready to write !

> For further information about the available Markdown functionalities, please read the [Markdown guide](https://www.markdownguide.org/basic-syntax/).

### Add your author information

Go to the [authors.yml file](authors/authors.yml), you will have to create your author's information bloc : 

The first entry follow the same convention in all other **zatsit** software usage : 
- everything in lowercase
- first letter of your first name
- your name
- add your profil picture (in the `.webp` format) into the `authors/img` folder,
  **named after your key**: `authors/img/jdoe.webp`. That filename is how the
  site finds your picture.

This value will be used in your post metadata.

```yml
jdoe:
  name: John Doe
  title: Site Reliability Engineer  @ **zatsit**
  url: Github account or Linkedin account
  socials:            # optional
    linkedin: john-doe
    github: jdoe
```

> Only `name` is required. Do not add an `image_url`: the picture is found by
> its filename, and the field is ignored.

Then in your category folder (under [the blog folder](./blog)) create a folder like : `YYYY-MM-DD-SLUG`, where SLUG 
will be used to build the URL (in fact, it is the 'slug' property in your post that is used, 
but by convention we use it in the folder naming).

> The date in the folder name is not decorative: it is what dates your post when
> the frontmatter carries no `date`.


```sh
cd blog
cd category
mkdir YYYY-MM-DD-SLUG
touch index.md
vim index.md (it is a joke)
```
Then with your favourite IDE, you can edit your `index.md` file following this example

```md
---
slug: zatsit-blog (your future uri)
title: Zatsit blog introduction (Title of the post)
authors: [jdoe] (all your posts will be indexed with the key)
date: 2024-06-21 (the publication date)
tags: (to be categorized)
  - "architecture"
  - "web"
---
```

The attributes definition : 

| Key        | Value                           |
|------------|-----------------------------------|
| slug       | Your future uri                  |
| title      | Title of the post |
| authors    | All your posts will be indexed with your author name, refers to the key in the authors.yml file |
| date       | The publication date (take care of the value during PR reviewing). Optional: falls back to the date in the folder name |
| tags       | To be categorized              |

Optional keys, none of them needed for a plain article: `description` (replaces
the summary below on social cards and previews), `shareText` (see the share
links), `cover` and `draft`. Do **not** write a `category` key, it comes from
the folder.


After this section you have few lines to sum up your post, it will be used in list page.
For example : 

```md
---

Présentation de RedPanda, au travers du premier cours dédié aux développeurs de la "RedPanda University".

<!-- truncate -->
```
will result like this : 
![Screenshot of the sumup in page list](./assets/posting-post-sumup.png "Screenshot of the sumup in page list")

Then you can follow [this guide](https://www.markdownguide.org/basic-syntax/) to format your post if you are not markdown fluent.

### Using pictures

All your pictures for your post have to be stored in your post folder, feel free to create subfolders if you want.

> Do not forget alternative test for accessibility.

> Do not forget to credit your pictures according to the licence of the picture.

> Ideally, you should use the `webp` or `avif` format for your pictures, but if you have to use another format, please use the smallest size possible.

### Using admonitions 

Using abmonitions provide a way to set visual take-away for the readers that is pretty cool !

Open with `:::` and the kind of aside you want, close with `:::` alone:

```md
:::tip
Le contenu de l'encart, en Markdown.
:::
```

Six kinds are supported: `note`, `info`, `tip`, `warning`, `caution` and
`danger`. Any other name is printed as plain text, so mind the typos.

<img width="760" alt="image" src="https://github.com/user-attachments/assets/256db15d-5bd1-466d-bd40-b2afeda5b37b" />

### Add social media link

Nothing to do: the share links to `LinkedIn` and `X` are added automatically at
the bottom of every article by the `ShareLinks` component of the site shell. The
URL is derived from your `slug`, so it can no longer drift from the article it
points at.

The share text defaults to the article title. To write your own, add an optional
`shareText` to the frontmatter:

```yml
---
slug: redpanda-introduction
title: Premier cours de RedPanda
shareText: "Présentation de RedPanda, au travers du premier cours dédié aux développeurs de la RedPanda University"
---
```

Do not paste the old two-line snippet: its relative paths pointed into the
shell's `static/` folder, which the content repository no longer sits inside.

### Add a video link in your post

We don't want to use the iframe way to add a video in our post, because it is not performant (and so, not green). So the idea is to link the video with a picture, and the picture will be the link to the video.

- get the YouTube Thumbnail from [https://www.get-youtube-thumbnail.com](https://www.get-youtube-thumbnail.com), and store it in your post folder.
- Link the video with this example snippet (that is used in the [AsyncAPI post](/blog/architecture/2023-12-21-AsyncAPI-3/index.md))

Format:
```
[![<accessibility title>](<path to the image> '<accessibility tile>')](<link to the youtube video>)
```
Example:
```
[![Regarder la video sur Youtube](./v3livemigration.jpeg 'Go to v3 migration live')](https://www.youtube.com/watch?v=WCK9_ZDv6K4)
```

## Visualise the blog post by submitting a pull request

You can have a first preview like any markdown preview from your favorite IDE. The preview will be very similar to the final result.

When you are ready to submit your post, you can create a pull request. A Github Actions workflow will generate
a previous URL for you in order to visualize your post in an ephemeral blog instance.

To see the real thing before that, run the site locally: see
[Preview locally](./README.md#preview-locally).

## Use mathematical representation  

You can write mathematical expressions in LaTeX syntax, between a pair of `$$`
on their own lines:

```md
$$
WUE = \frac{\text{eau consommée}}{\text{énergie consommée}}
$$
```

Block formulas only. A single `$` stays a literal dollar sign, so there is no
inline math.
