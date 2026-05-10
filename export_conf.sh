#!/usr/bin/env bash

set -e

# Configuration
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors
PINK='\033[38;2;242;93;148m'
PURPLE='\033[38;2;125;86;244m'
CYAN='\033[38;2;0;173;216m'
GREEN='\033[38;2;4;181;117m'
RED='\033[38;2;232;64;51m'
ORANGE='\033[38;2;255;148;0m'
NC='\033[0m'

# Shared list
source "$DOTFILES_DIR/sync_vars.sh"

echo -e "${PURPLE}[OP-SAAL] Starte Organentnahme: Patient -> Spenderbank (Dotfiles)${NC}"

echo -e "${CYAN}[VITALWERTE] Isoliere Hauptorgane...${NC}"
for dir in "${FOLDERS_TO_SYNC[@]}"; do
    src="$CONFIG_DIR/$dir"
    dest="$DOTFILES_DIR/$dir"

    if [[ -d "$src" ]]; then
        echo -e "${GREEN}[SKALPELL] Entnehme Organ: $dir${NC}"

        mkdir -p "$dest"
        rsync -a --delete --exclude '.git' "$src/" "$dest/"
    else
        echo -e "${ORANGE}[WARNUNG] Quell-Organ $src im Patienten nicht gefunden. Überspringe.${NC}"
    fi
done

echo -e "${PINK}[ERFOLG] Entnahme abgeschlossen. Spenderbank ist auf dem neuesten Stand. Patient überlebt.${NC}"
