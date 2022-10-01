setxkbmap -model abnt2 -layout br
$HOME/.screenlayout/display.sh
xsetroot -cursor_name left_ptr
feh --bg-scale ~/Wallpapers/neoncity.png
$HOME/.config/polybar/launch.sh
picom -f &
exec bspwm
