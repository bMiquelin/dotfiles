#!/bin/bash

cd $HOME/repo/dotfiles/.config

mkdir -p fish
cp ~/.config/fish/config.fish		fish/config.fish
mkdir -p polybar
cp ~/.config/polybar/config.ini		polybar/config.ini
cp ~/.config/polybar/launch.sh		polybar/launch.sh
mkdir -p alacritty
cp ~/.config/alacritty/alacritty.yml	alacritty/alacritty.yml
mkdir -p bspwm
cp ~/.config/bspwm/bspwmrc		bspwm/bspwmrc
mkdir -p picom
cp ~/.config/picom/picom.conf		picom/picom.conf

echo 'DONE'
