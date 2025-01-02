#!/bin/bash

if [ $# -gt 0 ]; then
  query=$(echo "$*" | sed 's/ /+/g')
  xdg-open "https://www.youtube.com/results?search_query=$query"
else
  xdg-open https://www.youtube.com
fi
