#!/usr/bin/env bash
# ╭────────────────────────────────────────────────────────────╮
# │  Power-Menü — hängt am ⏻ rechts in der Leiste und an       │
# │  Mod+Shift+E. Zeigt fuzzel im dmenu-Modus, damit es        │
# │  aussieht wie der App-Launcher.                            │
# ╰────────────────────────────────────────────────────────────╯
set -euo pipefail

# Rückfrage, bevor etwas Unwiderrufliches passiert.
#   $1 = Frage, $2 = Befehl, der bei "Ja" läuft
nachfragen() {
    swaynag -t warning -m "$1" -B 'Ja' "$2" -s 'Abbrechen'
}

# Escape/Abbruch in fuzzel -> Exit-Code != 0 -> das Skript endet hier (set -e).
gewaehlt=$(printf '%s\n' \
    "  Sperren" \
    "  Ruhezustand" \
    "  Abmelden" \
    "  Neu starten" \
    "  Herunterfahren" \
    | fuzzel --dmenu --prompt '⏻  ' --lines 5 --width 22)

case "$gewaehlt" in
    *Sperren*)
        exec swaylock -f -i "$HOME/.config/background" -s fill
        ;;
    *Ruhezustand*)
        # Gesperrt wird automatisch: swayidle hat einen before-sleep-Hook.
        exec systemctl suspend
        ;;
    *Abmelden*)
        nachfragen 'Abmelden? Die Wayland-Sitzung wird geschlossen.' 'swaymsg exit'
        ;;
    *"Neu starten"*)
        nachfragen 'Neu starten?' 'systemctl reboot'
        ;;
    *Herunterfahren*)
        nachfragen 'Herunterfahren?' 'systemctl poweroff'
        ;;
esac
