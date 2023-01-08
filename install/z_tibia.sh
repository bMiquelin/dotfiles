#!/bin/bash
sudo pacman -S wget --needed
cd $HOME/Downloads
wget "https://static.tibia.com/download/tibia.x64.tar.gz"
mkdir -p $HOME/games
tar -xf ./tibia.x64.tar.gz -C $HOME/games
sudo ln -sf ~/games/Tibia/Tibia /usr/local/bin/tibia
