#!/bin/bash

echo "This script will help you to initialize a new blog post."
echo ""


echo "1/ Category of the blog post"
echo ""

categories=("ai" "architecture" "cloud" "data" "dev" "general" "green" "mobile" "ops" "web")

cat_id=0
echo "  Blog post categories:"
for cat in "${categories[@]}"
do
    echo "   [${cat_id}] ${cat}"
    cat_id=$((cat_id+1))
done

echo ""
echo -n "  Select a category for the blog post (0-9) [default: null]: "
read cat_id_input
if [[ -z "${cat_id_input}" ]]; then
    echo "Error: Category is required"
    exit 1
fi
if [[ ! $cat_id_input =~ ^[0-9]$ ]]; then
    echo "Error: Category should be an integer between 0 and 9"
    exit 1
fi
post_category=${categories[$cat_id_input]}
echo ""
echo "  Selected category: ${post_category}"
echo ""


echo "2/ Date of the blog post"
echo ""

post_date=$(date +%Y-%m-%d)
echo -n "  Enter the date of the blog post (YYYY-MM-DD) [default: ${post_date}]: "
read post_date_input
if [[ ! -z "${post_date_input}" ]]; then
    post_date=${post_date_input}
fi


echo "${post_date}" | grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}$" > /dev/null
if [[ $? -eq 1 ]]; then
    echo "Error: Date format is not correct. Please use the format YYYY-MM-DD"
fi
echo ""
echo "  Selected date: ${post_date}"
echo ""


echo "3/ Title of the blog post"
echo ""


echo -n "  Enter the title of the blog post: "
read post_title
echo ""
echo "  Selected title: ${post_title}"

if [[ -z "${post_title}" ]]; then
    echo "Error: Title is required"
    exit 1
fi

# Function to slugify a string
slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]' '-' | sed 's/-*$//g'
}

# Function to remove the last caracter of a string
remove_last_char() {
    echo "${1%?}"
}

post_slug=$(slugify "${post_title}")
echo "  Generated slug: ${post_slug}"
echo ""


echo "4/ Excerpt (sumup) of the blog post"
echo ""

echo "  Enter the excerpt of the blog post:"
read post_excerpt
echo ""
echo "  excerpt: ${post_excerpt}"
echo ""
echo ""


echo "Initialization of the blog post content"
echo ""
post_directory="blog/${post_category}/${post_date}-${post_slug}"
post_file="${post_directory}/index.md"
echo "  Blog post directory: ${post_directory}"
echo "  Blog post file: ${post_file}"
mkdir -p "./blog/${post_category}/${post_date}-${post_slug}"
cat > "./blog/${post_category}/${post_date}-${post_slug}/index.md" <<EOF
---
title: "${post_title}"
slug: "${post_slug}"
authors: []
tags: []
---

${post_excerpt}

<!-- truncate -->

EOF
