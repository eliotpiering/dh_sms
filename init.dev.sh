#!/bin/bash

while read -r line; do
  line=$(sed -e 's/[[:space:]]*$//' <<<${line})
  var=`echo $line | cut -d '=' -f1`; test=$(echo $var)
  if [ -z "$(test)" ];then echo "export \"$line\"";eval export "$line";fi
done <.env

iex -S mix phx.server
