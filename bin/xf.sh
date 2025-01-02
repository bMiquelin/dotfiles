#!/bin/bash

# xf.sh - A simple script to extract files dynamically based on their type
# Author: [Your Name]
# Credits: Script designed with assistance from OpenAI GPT
# License: MIT

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Usage: xf <file> [output_directory]"
    exit 1
fi

# Get the file name and extension
file="$1"
filename=$(basename -- "$file")
extension="${filename##*.}"
basename="${filename%.*}"

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' does not exist."
    exit 1
fi

# Determine the output directory
if [ -n "$2" ]; then
    output_dir="$2"
else
    output_dir="./${basename// /-}_extracted"
fi

echo "[LOG] Creating directory: $output_dir"
mkdir -p "$output_dir"

# Temporary directory for extraction
temp_dir="${output_dir}_temp"
mkdir -p "$temp_dir"

# Extract based on the file extension
case "$extension" in
    zip)
        echo "[LOG] Extracting zip file to: $temp_dir"
        unzip "$file" -d "$temp_dir"
        ;;
    7z|rar)
        echo "[LOG] Extracting archive using 7z to: $temp_dir"
        7z x -o"$temp_dir" "$file"
        ;;
    tar|gz|bz2|xz)
        echo "[LOG] Extracting tar archive to: $temp_dir"
        tar -xf "$file" -C "$temp_dir"
        ;;
    *)
        echo "Error: Unsupported file type '$extension'."
        echo "[LOG] Removing temporary directory: $temp_dir"
        rmdir "$temp_dir"  # Clean up temporary directory
        exit 1
        ;;
esac

# Check if extraction created a single top-level directory
if [ $(find "$temp_dir" -mindepth 1 -maxdepth 1 -type d | wc -l) -eq 1 ]; then
    top_level_dir=$(find "$temp_dir" -mindepth 1 -maxdepth 1 -type d)
    echo "[LOG] Moving contents of: $top_level_dir to $output_dir"
    mv "$top_level_dir"/* "$output_dir" 2>/dev/null
    rmdir "$top_level_dir"
else
    echo "[LOG] Moving contents of: $temp_dir to $output_dir"
    mv "$temp_dir"/* "$output_dir" 2>/dev/null
fi

# Clean up temporary directory
echo "[LOG] Removing temporary directory: $temp_dir"
rmdir "$temp_dir"

# Notify the user
echo "Extracted '$file' to '$output_dir'"

# Prompt to delete the original file
echo -n "Do you want to delete the original file '$file'? (y/N): "
read -r delete_response
if [[ "$delete_response" =~ ^[Yy]$ ]]; then
    echo "[LOG] Deleting original file: $file"
    rm "$file"
fi
