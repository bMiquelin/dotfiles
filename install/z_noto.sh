#!/bin/bash
sudo pacman -S wget --needed
sudo mkdir -p "/usr/local/share/fonts/ttf/NotoSans"
sudo wget "https://github.com/google/fonts/blob/main/ofl/notosans/NotoSans-Regular.ttf?raw=true" -O "/usr/local/share/fonts/ttf/NotoSans/NotoSans-Regular.ttf"

