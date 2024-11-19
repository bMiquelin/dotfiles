#!/bin/bash

orphaned_packages=$(yay -Qdt | wc -l)
if [ "$orphaned_packages" -gt 0 ]; then
    echo "There are $orphaned_packages orphaned packages (yay -Qdt)"
fi

pending_updates=$(yay -Qu | wc -l)
if [ "$pending_updates" -gt 0 ]; then
    echo "There are $pending_updates pending updates (ya -Qu)"
fi
