#!/bin/bash

# Find all .sh files
files=$(rg --files | rg '\.sh$')

# Check if there's only one .sh file
if [ -n "$files" ]; then
    if [ $(echo "$files" | wc -l) -eq 1 ]; then
        selected_file=$(echo "$files")
        if [ -n "$selected_file" ]; then
            if [ "$(echo -e "Yes\nNo" | dmenu -i -l 20 -p "Are you sure you want to run $selected_file?")" == "Yes" ]; then
                bash "$selected_file"
            fi
        fi
    else
        selected_file=$(echo "$files" | dmenu -i -l 20 -p "Select a shell script:")
        if [ -n "$selected_file" ]; then
            bash "$selected_file"
        fi
    fi
else
    echo "No .sh files found."
fi
