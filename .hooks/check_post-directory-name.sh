#!/bin/bash

flag_exit=0

for dir in $(ls -d ./blog/*/*)
do
  dir_name=$(basename $dir)
  if [[ ! $dir_name =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-zA-Z0-9-]+$ ]]; then
    flag_exit=1
    echo "Directory $dir_name is not well formatted. It should be formatted like YYYY-MM-DD-Slug-title"
  fi
done

echo "Exit status: ${flag_exit}"
exit $flag_exit
