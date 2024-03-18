#!/bin/bash

flag_exit=0

for dir in $(ls -d ./blog/*/*)
do
  echo $dir
  if [[ ! -f $dir/index.md ]]; then
    flag_exit=1
    echo "Directory $dir does not contain 'index.md' file"
  fi
done

echo "Exit status: ${flag_exit}"
exit $flag_exit
