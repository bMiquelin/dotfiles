setxkbmap -layout us -variant intl -option
$HOME/.screenlayout/display.sh
# xsetroot -cursor_name left_ptr
feh --bg-fill $DOTFILES/wallpaper/wallpaper1.jpg
$HOME/dotfiles/polybar/launch.sh
picom -f &
exec i3
