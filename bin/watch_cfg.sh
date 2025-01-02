#!/bin/bash

# nohup watch_cfg &

# Set the DOTFILES directory
DOTFILES="$HOME/dotfiles"

# Ensure the directory exists
if [[ ! -d "$DOTFILES" ]]; then
  echo "Directory $DOTFILES does not exist."
  exit 1
fi

send_notify() {
  notify-send "Watcher" "$1" -i /usr/share/pixmaps/archlinux-logo.png
}

# Watch for CLOSE_WRITE event only
inotifywait -m -r -e close_write --format '%e %w%f' "$DOTFILES" | while read event file; do
  echo "Change"
  if [[ "$file" == "$DOTFILES/picom/picom.conf" ]]; then
    send_notify "Picom config changed"
    pkill picom && picom &
  elif [[ "$file" == "$DOTFILES/i3/config" ]]; then
    send_notify "i3 config changed"
    i3-msg reload
  elif [[ "$file" == "$DOTFILES/polybar/config.ini" ]]; then
    send_notify "Polybar config changed"
    killall -q polybar
    polybar main 2>&1 | tee -a /tmp/polybar.log &
    disown
  elif [[ "$file" == "$DOTFILES/dunst/dunstrc" ]]; then
    killall dunst
    send_notify "Dunst config changed"
  elif [[ "$file" == "$DOTFILES/bin/watch_cfg.sh" ]]; then
    send_notify "watch_cfg.sh changed"
    $DOTFILES/bin/watch_cfg.sh & disown
    exit 0
  elif [[ "$file" == "$DOTFILES/bin/twitch_watch.sh" ]]; then
    send_notify "twitch_watch.sh changed"
    killall twitch_watch.sh
    $DOTFILES/bin/twitch_watch.sh & disown
  fi
done
