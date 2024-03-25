#!/bin/bash


# Functions
## Slugify a string
slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]' '-' | sed 's/-*$//g'
}

## Remove the last caracter of a string
remove_last_char() {
    echo "${1%?}"
}

# User adapter
## Change sed behavior if Mac OS users
export SED=sed
if [[ "$OSTYPE" == "darwin"* ]]; then
    export SED=sed -i ''
fi


# Variables
## Read categories from config.json file
categories=(`cat config.json | jq -cr '.categories[]' | tr '\n' ' '`)
categories_size=$(( ${#categories[@]} - 1 ))


# Main
echo "This script will help you to initialize a new blog post."
echo ""


echo "0/ Author of the blog post"
echo ""

echo -n "  Enter the author of the blog post: "
read post_author
echo ""
echo "  Selected author: ${post_author}"

# Check if author exists in the authors/authors.yml file
author_exists=$(grep "^${post_author}:" authors/authors.yml)
if [[ $author_exists -eq 0 ]]; then
    echo "Error: Author does not exist in the authors/authors.yml file"
    exit 1
fi

function select_post_category {
    echo "1/ Category of the blog post"
    echo ""


    cat_id=0
    echo "  Blog post categories:"
    for cat in "${categories[@]}"
    do
        echo "   [${cat_id}] ${cat}"
        cat_id=$((cat_id+1))
    done

    echo ""
    echo -n "  Select a category for the blog post (0-${categories_size}) [default: null]: "
    read cat_id_input
}

while [[ -z "${cat_id_input}" ]] || [[ ! $cat_id_input =~ ^[0-9]*$ ]] || [[ $cat_id_input -lt 0 ]] || [[ $cat_id_input -gt $categories_size ]]; do
    select_post_category
done

post_category=${categories[$cat_id_input]}
echo ""
echo "  Selected category: ${post_category}"
echo ""


function select_post_date {
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
        select_post_date
    fi
}
select_post_date

echo ""
echo "  Selected date: ${post_date}"
echo ""


function select_post_title {
    echo "3/ Title of the blog post"
    echo ""


    echo -n "  Enter the title of the blog post: "
    read post_title
    echo ""
    echo "  Selected title: ${post_title}"

    if [[ -z "${post_title}" ]]; then
        select_post_title
    fi
}
select_post_title

post_slug=$(slugify "${post_title}")
echo "  Generated slug: ${post_slug}"
echo ""


# echo "4/ Excerpt (sumup) of the blog post"
# echo ""

# echo "  Enter the excerpt of the blog post:"
# read post_excerpt
# echo ""
# echo "  excerpt: ${post_excerpt}"
# echo ""
# echo ""


echo ""
echo "Initialization of the blog post content"
echo ""
post_directory="blog/${post_category}/${post_date}-${post_slug}"
post_file="${post_directory}/index.md"
echo "  Blog post directory: ${post_directory}"
echo "  Blog post file: ${post_file}"
mkdir -p ./${post_directory}
cp ./templates/blog/blog-post.md ./${post_file}
sed -i "s/^title: .*/title: \"${post_title}\"/" ./${post_file}
sed -i "s/^slug: .*/slug: \"${post_slug}\"/" ./${post_file}
sed -i "s/^authors: .*/authors: [${post_author}]/" ./${post_file}
sed -i "s/^tags: .*/tags: []/" ./${post_file}

echo ""
echo "Blog post initialized successfully"
