#!/bin/bash

while inotifywait -e modify ~/dotfiles/i3/config; do
  i3-msg reload
done
