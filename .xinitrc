#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap
[ -f $userresources ] && xrdb -merge $userresources
[ -f $usermodmap ] && xmodmap $usermodmap
[ -d /etc/X11/xinit/xinitrc.d ] && for f in /etc/X11/xinit/xinitrc.d/?*.sh; do [ -x "$f" ] && . "$f"; done

export EDITOR=nvim
export BROWSER=chromium
export TERMINAL=alacritty

setxkbmap -layout us -variant intl -option
# picom -f &
# $HOME/.screenlayout/display.sh
# xsetroot -cursor_name left_ptr
$HOME/dotfiles/polybar/launch.sh
feh --bg-fill $DOTFILES/wallpaper/wallpaper1.jpg
exec i3
