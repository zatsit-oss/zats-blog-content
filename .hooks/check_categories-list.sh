#!/bin/bash

## Read categories from config.json file
categories_list=" "$(echo `cat config.json | jq -cr '.categories[]' | tr '\n' ' '`)" "

flag_exit=0

for dir in $(ls -d ./blog/*/)
do
  dir_name=$(basename $dir)
  flag=1
  if [[ " ${categories_list[@]} " =~ " ${dir_name} " ]]; then
    flag=0
  fi
  if [[ $flag -eq 1 ]]; then
    echo "Category $dir_name does not exist"
    flag_exit=1
  fi
done

echo "Exit status: ${flag_exit}"
exit $flag_exit
