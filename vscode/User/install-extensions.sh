#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

if [ ! -f "$EXTENSIONS_FILE" ]; then
  echo "Error: extensions.txt not found at $EXTENSIONS_FILE" >&2
  exit 1
fi

if ! command -v code >/dev/null 2>&1; then
  echo "Error: VS Code (code) is not installed or not in PATH." >&2
  exit 1
fi

echo "Installing VS Code extensions from $EXTENSIONS_FILE..."

while IFS= read -r extension; do
  # Skip empty lines and comments
  [[ -z "$extension" || "$extension" =~ ^# ]] && continue
  
  echo "Installing: $extension"
  code --install-extension "$extension"
done < "$EXTENSIONS_FILE"

echo "All VS Code extensions have been installed successfully."
