#!/bin/bash
sudo pacman -S wget --needed

mkdir -p $HOME/tmp
wget "https://discord.com/api/download?platform=linux&format=tar.gz" -O $HOME/tmp/discord.tar.gz
mkdir -p $HOME/programs/discord
tar -xf $HOME/tmp/discord.tar.gz -C $HOME/programs
sudo ln -sf ~/programs/Discord/Discord /usr/local/bin/discord
