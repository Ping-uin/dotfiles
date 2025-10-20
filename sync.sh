#!/usr/bin/env bash

set -e

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
GITIGNORE_FILE="$DOTFILES_DIR/.gitignore"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if dotfiles directory exists
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    exit 1
fi

# Check if .gitignore exists
if [[ ! -f "$GITIGNORE_FILE" ]]; then
    echo -e "${RED}Error: .gitignore not found at $GITIGNORE_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}Syncing dotfiles from $CONFIG_DIR to $DOTFILES_DIR${NC}"
echo ""

# Parse .gitignore and extract whitelisted directories
# We look for patterns like "!dirname/" which indicate a directory to track
whitelisted_dirs=()

while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    
    # Look for negated patterns (whitelist) that represent directories
    if [[ "$line" =~ ^!([^/]+)/$ ]]; then
        dir_name="${BASH_REMATCH[1]}"
        whitelisted_dirs+=("$dir_name")
    fi
done < "$GITIGNORE_FILE"

# Check if we found any directories
if [[ ${#whitelisted_dirs[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No whitelisted directories found in .gitignore${NC}"
    exit 0
fi

echo -e "${GREEN}Found ${#whitelisted_dirs[@]} directories to sync:${NC}"
printf '%s\n' "${whitelisted_dirs[@]}"
echo ""

# Sync each directory
for dir in "${whitelisted_dirs[@]}"; do
    src="$CONFIG_DIR/$dir"
    dest="$DOTFILES_DIR/$dir"
    
    if [[ -d "$src" ]]; then
        echo -e "${GREEN}Syncing: $dir${NC}"
        
        # Create destination directory if it doesn't exist
        mkdir -p "$dest"
        
        # Use rsync for efficient copying
        # -a: archive mode (preserves permissions, timestamps, etc.)
        # -v: verbose
        # --delete: remove files in dest that don't exist in src
        rsync -av --delete "$src/" "$dest/"
        
        echo ""
    else
        echo -e "${YELLOW}Warning: $src does not exist, skipping${NC}"
        echo ""
    fi
done

echo -e "${GREEN}Sync complete!${NC}"
