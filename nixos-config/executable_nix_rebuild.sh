#!/bin/bash
CONFIG_DIR="/home/ping_uin/nixos-config"

cd "$CONFIG_DIR" || { echo "Fehler: Kann nicht in $CONFIG_DIR wechseln"; exit 1; }

echo "Formating..."
alejandra *.nix

# save git status for possible rollback
CURRENT_COMMIT=$(git rev-parse HEAD)

echo "Testing build using nh..."
if sudo nixos-rebuild build --flake .#vivo; then
    echo "✓ Build OK - try switch..."
    
    if sudo nixos-rebuild switch --flake; then
        echo "Switch successful!"
        
        # Nur bei Erfolg committen und pushen
        git add .
        if git diff --staged --quiet; then
            echo "No changes to commit"
        else
            git commit -m "NixOS config update $(date '+%Y-%m-%d %H:%M:%S')"
            if git push origin main; then
                echo "Changes pushed!"
            else
                echo "Push failed - but config is active"
            fi
        fi
        
        echo "✅ Update successful!"
    else
        echo "❌ Switch failed - system unchanged"
        exit 1
    fi
else
    echo "❌ Build failed"
    echo "Revert the changes? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git reset --hard "$CURRENT_COMMIT"
        echo "Setback to commit: ${CURRENT_COMMIT:0:8}"
    fi
    exit 1
fi
