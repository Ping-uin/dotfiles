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

echo -e "${PURPLE}[OP-SAAL] Starte Operation: Implantation (Spenderbank -> Patient)${NC}"

# Check Check
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}[NOTFALL] Spenderbank ($DOTFILES_DIR) nicht gefunden! Abbruch der Operation.${NC}"
    exit 1
fi

echo -e "${CYAN}[VITALWERTE] Überprüfe Hauptorgane...${NC}"
for dir in "${FOLDERS_TO_SYNC[@]}"; do
    src="$DOTFILES_DIR/$dir"
    dest="$CONFIG_DIR/$dir"

    if [[ -d "$src" ]]; then
        echo -e "${GREEN}[SKALPELL] Implantiere Organ: $dir${NC}"

        mkdir -p "$dest"
        rsync -a --delete --exclude '.git' "$src/" "$dest/"
    else
        echo -e "${ORANGE}[WARNUNG] Spenderorgan $dir fehlt in der Kühlbox. Überspringe.${NC}"
    fi
done

echo -e "${PINK}[ERFOLG] Operation abgeschlossen. Patient ist stabil und aktualisiert.${NC}"
