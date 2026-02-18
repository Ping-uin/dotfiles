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
    "zathura"
)

# Dateien, die direkt ins Home-Dir oder woanders hin gehören (falls nötig)
# Wenn Sie nur .config Ordner haben, lassen Sie das leer.
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

# 1. Sync Folders (Repo -> .config)
for dir in "${FOLDERS_TO_SYNC[@]}"; do
    src="$DOTFILES_DIR/$dir"
    dest="$CONFIG_DIR/$dir"

    if [[ -d "$src" ]]; then
        echo -e "${GREEN}Deploying: $dir${NC}"
        
        # Sicherstellen, dass das Ziel existiert
        mkdir -p "$dest"

        # rsync macht den Job. 
        # --delete bedeutet: Wenn eine Datei im Repo gelöscht wurde, 
        # verschwindet sie auch lokal. Das ist Hygiene.
        rsync -av --delete --exclude '.git' "$src/" "$dest/"
    else
        echo -e "${YELLOW}Warning: Donor organ $dir is missing in Repo. Skipping.${NC}"
    fi
done

# 2. Sync Files (Repo -> Home/Config)
# Hier müssen Sie vorsichtig sein. Wohin sollen die Shell-Skripte?
# Ich nehme an, sie bleiben im dotfiles Ordner zur Ausführung, 
# aber falls Sie sie kopieren wollen:
for file in "${FILES_TO_SYNC[@]}"; do
    src="$DOTFILES_DIR/$file"
    # Ziel bestimmen. Wo wollen Sie diese haben? 
    # Wenn sie im Root liegen sollen: dest="$HOME/$file"
    # Wenn sie im dotfiles ordner bleiben sollen, tun wir hier nichts.
    
    # Beispiel: Kopiere Scripte ins Home Verzeichnis (optional)
    # dest="$HOME/$file"
    # cp "$src" "$dest"
done

echo -e "${GREEN}Operation successful. Patient updated.${NC}"
