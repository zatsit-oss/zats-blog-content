#!/bin/bash

flag_exit=0

for post in $(ls -d ./blog/*/*/index.md)
do
  # Check slug field
  sed '/---/,/---/!d' $post | grep "^slug:"
  if [[ $? -eq 1 ]]; then
    flag_exit=1
    echo "Blog post $post should contain 'slug' field in headers"
  fi

  # Check title field
  post_header_title=$(sed '/---/,/---/!d' $post | grep "^title:")
  if [[ $? -eq 1 ]]; then
    flag_exit=1
    echo "Blog post $post should contain 'title' field in headers"
  fi

  # Check authors field
  post_header_authors=$(sed '/---/,/---/!d' $post | grep "^authors:")
  if [[ $? -eq 1 ]]; then
    flag_exit=1
    echo "Blog post $post should contain 'authors' field in headers"
  fi

  # Check if authors exist in authors.yml
  post_header_authors=$(sed '/---/,/---/!d' $post | grep "^authors:" | cut -d ':' -f2 | tr -d ' []')  
  authors_list=$(cat ./blog/authors.yml | grep -e '^[a-z]*:' | cut -d ':' -f1)
  echo $authors_list | tr " " '\n' | grep -F -q -x $post_header_authors
  if [[ $? -eq 1 ]]; then
    flag_exit=1
    echo "Blog post $post authors ($post_header_authors) does not exist in authors.yml"
  fi

  # Check tags field
  post_header_tags=$(sed '/---/,/---/!d' $post | grep "^tags:")
  if [[ $? -eq 1 ]]; then
    flag_exit=1
    echo "Blog post $post should contain 'tags' field in headers"
  fi
done

echo "Exit status: ${flag_exit}"
exit $flag_exit
