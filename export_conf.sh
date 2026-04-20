#!/usr/bin/env bash

set -e

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Neues kommt HIER rein, muss identisch mit dem deploy_local.sh script sein
FOLDERS_TO_SYNC=(
    "nvim"
    "tmux"
    "wezterm"
    "zsh"
    "doom"
)

# Dateien im Root, die nicht in .config liegen
FILES_TO_SYNC=(
    "deploy_local.sh"
    "export_conf.sh"
)

echo -e "${GREEN}Starting transplant to $DOTFILES_DIR...${NC}"

# 1. Sync Folders (.config -> dotfiles)
for dir in "${FOLDERS_TO_SYNC[@]}"; do
    src="$CONFIG_DIR/$dir"
    dest="$DOTFILES_DIR/$dir"

    if [[ -d "$src" ]]; then
        echo -e "${GREEN}Syncing Directory: $dir${NC}"
        mkdir -p "$dest"
        # rsync flags:
        # -a: Archive (Behält Rechte, Times, Symlinks - WICHTIG für nvim Plugins)
        # -v: Verbose
        # --delete: Löscht Dateien im Ziel, die in der Quelle nicht mehr existieren
        # --exclude: Ignoriert .git Ordner
        rsync -av --delete --exclude '.git' "$src/" "$dest/"
    else
        echo -e "${YELLOW}Warning: Source organ $src missing. Skipping.${NC}"
    fi
done

# 2. Sync Individual Files
for file in "${FILES_TO_SYNC[@]}"; do
    src="$HOME/$file"
    dest="$DOTFILES_DIR/$file"

    if [[ -f "$src" ]]; then
        echo -e "${GREEN}Syncing File: $file${NC}"
        cp "$src" "$dest"
    else
        # Wenn die Datei nicht existiert, ist es vielleicht okay,
        # solange sie schon im Repo ist.
        echo -e "${YELLOW}File $src not found in source.${NC}"
    fi
done

echo -e "${GREEN}Patient stabil. Sync complete.${NC}"
