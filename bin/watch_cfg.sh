#!/bin/bash

# nohup watch_cfg &

# Set the DOTFILES directory
DOTFILES="$HOME/dotfiles"

# Ensure the directory exists
if [[ ! -d "$DOTFILES" ]]; then
    echo "Directory $DOTFILES does not exist."
    exit 1
fi

# Watch for CLOSE_WRITE event only
inotifywait -m -r -e close_write --format '%e %w%f' "$DOTFILES" | while read event file; do
    echo "Change"
    if [[ "$file" == "$DOTFILES/picom/picom.conf" ]]; then
        echo "Picom config changed"
        pkill picom && picom &
    elif [[ "$file" == "$DOTFILES/i3/config" ]]; then
        echo "i3 config changed"
        i3-msg reload
    elif [[ "$file" == "$DOTFILES/polybar/config.ini" ]]; then
        echo "Polybar config changed"
        killall -q polybar
        polybar main 2>&1 | tee -a /tmp/polybar.log & disown
    fi
done
