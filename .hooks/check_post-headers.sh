#!/bin/bash

flag_exit=0

for post in $(ls -d ./blog/*/*/index.md)
do
  post_header=$(sed '/---/,/---/!d' $post | grep "^authors")
  post_author=$(echo $post_header | cut -d ':' -f2 | tr -d ' []')
  authors_list=$(cat ./blog/authors.yml | grep -e '^[a-z]*:' | cut -d ':' -f1)

  echo $authors_list | tr " " '\n' | grep -F -q -x $post_author

  if [[ $? -eq 1 ]]; then
    flag_exit=1
    echo "Author $post_author does not exist in authors.yml"
  fi
done

echo "Exit status: ${flag_exit}"
exit $flag_exit
