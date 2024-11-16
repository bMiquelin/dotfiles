#!/bin/bash
# Declare variables for paths
ZIP_PATH="$HOME/.pass.zip"
TXT_PATH="/tmp/pass.txt"
# Prompt for password
read -sp "Enter password: " password
echo  # Move to next line after password input
# Error handling function
handle_error() {
  echo "Error: $1"
  exit 1
}
# Unzip file with error handling
if ! unzip -P "$password" "$ZIP_PATH" -d /tmp/; then
  handle_error "Failed to unzip the file. Check the password or file location."
fi
# Open file with vi
if ! vim "$TXT_PATH"; then
  handle_error "Failed to open the file with vi."
fi
# Re-zip the file with a password
if ! 7z a -p"$password" "$ZIP_PATH" "$TXT_PATH"; then
  handle_error "Failed to re-zip the file."
fi
# Clear the temporary TXT file
if ! rm "$TXT_PATH"; then
  handle_error "Failed to delete the temporary file."
fi
echo "Operation completed successfully."
