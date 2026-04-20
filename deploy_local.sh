#!/usr/bin/env bash

set -e

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# WICHTIG: Diese Liste muss identisch mit der im export_conf.sh sein
FOLDERS_TO_SYNC=(
    "nvim"
    "tmux"
    "wezterm"
    "zsh"
    "doom"
)

FILES_TO_SYNC=(
    "deploy_local.sh"
    "export_conf.sh"
)

echo -e "${BLUE}Starting transfusion: DOTFILES -> LOCAL CONFIG${NC}"

# Check Check
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}Critical: Donor organ bank (dotfiles dir) not found!${NC}"
    exit 1
fi

# 1. Sync Folders
for dir in "${FOLDERS_TO_SYNC[@]}"; do
    src="$DOTFILES_DIR/$dir"
    dest="$CONFIG_DIR/$dir"

    if [[ -d "$src" ]]; then
        echo -e "${GREEN}Deploying: $dir${NC}"

        # Make sure destination exists
        mkdir -p "$dest"

        # rsync
        # --delete bedeutet: Wenn eine Datei im Repo gelöscht wurde,
        # verschwindet sie auch lokal
        rsync -av --delete --exclude '.git' "$src/" "$dest/"
    else
        echo -e "${YELLOW}Warning: Donor organ $dir is missing in Repo. Skipping.${NC}"
    fi
done

# 2. Sync Files
for file in "${FILES_TO_SYNC[@]}"; do
    src="$DOTFILES_DIR/$file"
done

echo -e "${GREEN}Operation successful. Patient updated.${NC}"
