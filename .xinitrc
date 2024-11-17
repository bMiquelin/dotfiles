#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#--#
export EDITOR=nvim
export BROWSER=chromium
export TERMINAL=alacritty
setxkbmap -layout us -variant intl -option
$HOME/dotfiles/polybar/launch.sh
feh --bg-fill $DOTFILES/wallpaper/wallpaper1.jpg
exec i3


# picom -f &
# $HOME/.screenlayout/display.sh
# xsetroot -cursor_name left_ptr
feh --bg-fill $DOTFILES/wallpaper/wallpaper1.jpg
$HOME/dotfiles/polybar/launch.sh
exec i3
