#!/bin/bash

cd $HOME/repo/dotfiles/.config

mkdir -p fish
cp ~/.config/fish/config.fish		    fish/config.fish
mkdir -p polybar
cp ~/.config/polybar/config.ini		    polybar/config.ini
cp ~/.config/polybar/launch.sh		    polybar/launch.sh
mkdir -p alacritty
cp ~/.config/alacritty/alacritty.yml	alacritty/alacritty.yml
mkdir -p bspwm
cp ~/.config/bspwm/bspwmrc		        bspwm/bspwmrc
mkdir -p picom
cp ~/.config/picom/picom.conf		    picom/picom.conf
mkdir -p sxhkd
cp ~/.config/sxhkd/sxhkdrc		        sxhkd/sxhkdrc
mkdir -p nvim
cp ~/.config/nvim/init.vim		        nvim/init.vim
mkdir -p dunst
cp ~/.config/dunst/dunstrc              dunst/dunstrc


cp -rv ./* ~/.config
notify-send 'DONE'
