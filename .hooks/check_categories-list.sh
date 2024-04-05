#!/bin/bash

## Read categories from config.json file
categories=(`cat config.json | jq -cr '.categories[]' | tr '\n' ' '`)

flag_exit=0

for dir in $(ls -d ./blog/*/)
do
  dir_name=$(basename $dir)
  if [[ ! " ${categories_list[@]} " =~ " ${dir_name} " ]]; then
    flag_exit=1
    echo "Category $dir_name should not exist"
  fi
done

echo "Exit status: ${flag_exit}"
exit $flag_exit
