#!/bin/bash
sudo pacman -S wget --needed
cd $HOME/Downloads
wget "https://support.pokexgames.com/files/pxg-linux.zip"
mkdir $HOME/games
unzip ./pxg-linux.zip -d $HOME/games/pxg
sudo ln -sf ~/games/pxg/pxgme-linux /usr/local/bin/pxg