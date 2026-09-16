# sway

Tiling-Window-Manager für Wayland, weitgehend kompatibel zu i3 — gleiche
Konzepte, gleiche Config-Syntax, nur eben unter Wayland statt X11. Wer i3
kennt, kann hier direkt loslegen.

Diese Config ist bewusst schlank gehalten: Rahmen statt Titelleisten, keine
Gaps, eine durchgängige Leiste oben, und die
[CharmTone](https://charm.land)-Palette überall.

---

## Inhalt

- [Starten](#starten)
- [Die Grundidee](#die-grundidee)
- [Tastenbelegung](#tastenbelegung)
- [Welche Datei macht was](#welche-datei-macht-was)
- [Anpassen](#anpassen)
- [Pakete kommen aus NixOS](#pakete-kommen-aus-nixos)
- [Wenn etwas nicht geht](#wenn-etwas-nicht-geht)
- [Die Palette](#die-palette)

---

## Starten

Nach einem Rebuild (siehe unten) abmelden und im GDM-Anmeldebildschirm unten
rechts auf das **Zahnrad** klicken → **Sway** auswählen → einloggen.

Die Auswahl merkt sich GDM. Um zurück zu GNOME zu kommen: dasselbe Zahnrad,
**GNOME** auswählen.

Zum Ausprobieren ohne Abmelden geht auch ein verschachteltes sway in einem
Fenster:

```bash
sway
```

Beenden: `Mod+Shift+E` oder der **⏻** rechts in der Leiste → Eintrag wählen
→ bestätigen.

---

## Die Grundidee

**Fenster kacheln automatisch.** Es gibt kein Überlappen und kein Ziehen mit
der Maus. Jedes neue Fenster teilt sich den Platz mit den vorhandenen.

**`Mod` ist die Super-/Windows-Taste.** Fast alles läuft über sie.

**Container.** Jeder Workspace ist ein Baum aus Containern. Ein Container
enthält entweder Fenster oder weitere Container. Das klingt abstrakt, heißt
aber praktisch nur: du kannst Gruppen von Fenstern gemeinsam verschieben und
umlayouten. `Mod+A` wählt den Eltern-Container aus.

**Split-Richtung.** `Mod+B` (horizontal) und `Mod+V` (vertikal) legen fest,
wo das *nächste* Fenster aufgeht — rechts daneben oder darunter. Der farbige
Balken am Rand des fokussierten Fensters zeigt an, wo es landen wird.

**Layouts.** Ein Container kann statt nebeneinander auch als Reiter
(`Mod+W`) oder gestapelt (`Mod+S`) dargestellt werden. Sehr nützlich, wenn
vier Fenster auf einem Workspace zu eng werden.

**Workspaces** sind virtuelle Arbeitsflächen, `Mod+1` bis `Mod+0`. Sie
werden bei Bedarf angelegt und verschwinden wieder, wenn das letzte Fenster
weg ist.

**Floating.** Einzelne Fenster dürfen aus der Kachelung ausbrechen
(`Mod+Shift+Space`) — sinnvoll für kleine Dialoge. Mit `Mod` + linker
Maustaste verschieben, `Mod` + rechter Maustaste skalieren.

**Scratchpad** ist eine Ablage für Fenster, die man nur ab und zu braucht:
`Mod+Shift+-` legt das aktuelle Fenster hinein, `Mod+-` holt es wieder hervor
(und bei mehrfachem Drücken das nächste).

---

## Tastenbelegung

### Programme

| Taste | Aktion |
|---|---|
| `Mod+Return` | Terminal (wezterm) |
| `Mod+D` | App-Launcher (fuzzel) |
| `Mod+Shift+Return` | Dateimanager (nautilus) |
| `Mod+Shift+Q` | Fenster schließen |
| `Mod+Shift+V` | Zwischenablage-Verlauf durchsuchen |

### Fokus und Fenster bewegen

| Taste | Aktion |
|---|---|
| `Mod+H/J/K/L` | Fokus nach links / unten / oben / rechts |
| `Mod+Pfeiltasten` | dasselbe, falls die Finger woanders sind |
| `Mod+Shift+H/J/K/L` | Fenster in diese Richtung schieben |
| `Mod+A` | Fokus auf den Eltern-Container |
| `Mod+Space` | zwischen gekacheltem und schwebendem Bereich springen |

### Workspaces

| Taste | Aktion |
|---|---|
| `Mod+1` … `Mod+0` | Workspace 1–10 |
| `Mod+Shift+1` … `Mod+Shift+0` | Fenster auf Workspace 1–10 schieben |
| `Mod+Tab` / `Mod+Shift+Tab` | nächster / vorheriger Workspace |
| `Mod+Strg+Links/Rechts` | ganzen Workspace auf den anderen Monitor |

### Layout

| Taste | Aktion |
|---|---|
| `Mod+B` | nächstes Fenster geht rechts daneben auf |
| `Mod+V` | nächstes Fenster geht darunter auf |
| `Mod+W` | Container als Reiter |
| `Mod+S` | Container gestapelt |
| `Mod+E` | zurück auf nebeneinander |
| `Mod+F` | Vollbild |
| `Mod+Shift+Space` | schwebend an/aus |
| `Mod+R` | Größenänderungs-Modus (mit `H/J/K/L`, `Esc` beendet) |

### Scratchpad

| Taste | Aktion |
|---|---|
| `Mod+Shift+-` | Fenster in die Ablage legen |
| `Mod+-` | Fenster aus der Ablage holen |

### Screenshots

| Taste | Aktion |
|---|---|
| `Druck` | Bereich mit der Maus ziehen → Zwischenablage |
| `Mod+Druck` | ganzer Bildschirm → Datei in `~/Pictures` |
| `Mod+Shift+Druck` | aktuelles Fenster → Zwischenablage |

### Sitzung

| Taste | Aktion |
|---|---|
| `Mod+Shift+C` | Config neu laden (ohne Fenster zu verlieren) |
| `Mod+Shift+X` | Bildschirm sperren |
| `Mod+Shift+E` | Power-Menü: sperren, Ruhezustand, abmelden, neu starten, aus |

### Sondertasten

Lautstärke, Helligkeit und Medientasten sind belegt und funktionieren auch
im gesperrten Zustand. Der Bildschirm sperrt nach 10 Minuten von selbst und
geht nach 15 Minuten aus.

---

## Welche Datei macht was

Alles liegt unter `~/.config/`, eine Ebene pro Programm:

| Pfad | Inhalt |
|---|---|
| `sway/config` | Tastenbelegung, Layout, Farben, Autostart, Monitore |
| `sway/scripts/powermenu.sh` | das Menü hinter dem ⏻ und `Mod+Shift+E` |
| `waybar/config` | welche Module die Leiste zeigt |
| `waybar/style.css` | wie die Leiste aussieht |
| `fuzzel/fuzzel.ini` | Aussehen des App-Launchers |
| `mako/config` | Aussehen der Benachrichtigungen |
| `swaylock/config` | Aussehen des Sperrbildschirms |

Dazu kommt `/etc/sway/config.d/` — dort legt das NixOS-Modul systemweite
Ergänzungen ab (aktuell das de-Tastaturlayout). Die letzte Zeile von
`sway/config` bindet den Ordner ein.

Die Dateien werden über das Dotfiles-Repo synchronisiert:

```bash
~/dotfiles/export_conf.sh   # ~/.config  ->  ~/dotfiles
~/dotfiles/deploy_local.sh  # ~/dotfiles ->  ~/.config
```

Neue Programmordner müssen dafür in **beiden** Dateien stehen:
`~/dotfiles/sync_vars.sh` und `~/dotfiles/.gitignore`.

---

## Anpassen

Nach jeder Änderung an `sway/config`: **`Mod+Shift+C`**. Vorher prüfen lohnt
sich, ein Tippfehler zerschießt sonst die Session:

```bash
sway --validate -c ~/.config/sway/config
```

Waybar-Änderungen greifen ebenfalls mit `Mod+Shift+C`, weil sway die Leiste
selbst neu startet.

### Die Leiste bedienen

Die Module sind anklickbar:

| Modul | Aktion |
|---|---|
| Uhr | Links: GNOME Kalender · Rechts: Monats-/Jahresansicht im Tooltip · Scrollen: Monat vor/zurück · Mitte: zurück zu heute |
| Lautstärke | Links: `pavucontrol` · Rechts: stummschalten · Scrollen: lauter/leiser |
| Netzwerk | Links: `nm-connection-editor` |
| CPU | Links: `btop` im Terminal |
| Auge (Idle) | Links: verhindert, dass der Bildschirm ausgeht |
| ⏻ (ganz rechts) | Links: Power-Menü — sperren, Ruhezustand, abmelden, neu starten, herunterfahren |

### Monitore

Die Namen stehen in:

```bash
swaymsg -t get_outputs
```

Bequemer ist `wdisplays` — anordnen per Maus, dann die passenden
`output`-Zeilen in `sway/config` eintragen. Im Abschnitt *Ausgabe* stehen
schon auskommentierte Beispiele für die beiden 1080p-Schirme.

### Farben

Die Palette steht als `set $name #hex` oben in `sway/config` und als
`@define-color` oben in `waybar/style.css`. Weiter unten wird nur noch mit
den Namen gearbeitet — eine Farbe ändern heißt also: eine Zeile ändern.

### Fensterregeln

Um herauszufinden, wie ein Programm heißt:

```bash
swaymsg -t get_tree | grep -E 'app_id|class|title'
```

Dann im Abschnitt *Fensterregeln* eine `for_window`-Zeile ergänzen.

### Autostart

Im Abschnitt *Autostart* eine `exec`-Zeile hinzufügen. `exec` läuft nur beim
Start von sway, `exec_always` auch bei jedem Reload — letzteres startet
Programme doppelt, wenn sie sich nicht selbst darum kümmern.

---

## Pakete kommen aus NixOS

Das ist der wichtigste Unterschied zu einem normalen Linux: ein
`~/.config`-Eintrag alleine installiert nichts. Alle Programme, die hier
benutzt werden, stehen in:

```
~/nixos-config/modules/sway.nix
```

Dort in `extraPackages` ergänzen, dann bauen. Zum Prüfen ohne das System
anzufassen:

```bash
cd ~/nixos-config
nixos-rebuild build --flake ".#$(cat /etc/nixos-label)"
```

Und zum tatsächlichen Übernehmen der normale Weg:

```bash
rbb
```

Aktuell mitinstalliert: `waybar`, `fuzzel`, `mako`, `swaylock`, `swayidle`,
`swaybg`, `grim`, `slurp`, `jq`, `wl-clipboard`, `cliphist`, `brightnessctl`,
`playerctl`, `pavucontrol`, `wdisplays`, `libnotify` und ein
polkit-Agent für Passwort-Dialoge.

---

## Wenn etwas nicht geht

**Ein Tastenkürzel tut nichts.**
Fast immer das Tastaturlayout. Auf `de` erzeugt `Shift+1` ein `!`, nicht `1` —
sway sieht die Kombination dann nie. Deshalb steht vor jeder Bindung
`--to-code`: das bindet die *Position* der Taste statt des Zeichens. Bei
neuen Bindungen daran denken.

**Kästchen statt Icons in der Leiste.**
Die Nerd-Font-Symbole fehlen. Sie kommen aus `sway.nix`
(`fonts.packages = [pkgs.nerd-fonts.symbols-only]`) — also rebuilden. Prüfen
mit `fc-list | grep -i nerd`.

**Kein Datei-Dialog in Firefox & Co.**
Das GTK-Portal fehlt. Steht in `sway.nix` unter `xdg.portal.extraPortals`.

**Bildschirmfreigabe funktioniert nicht.**
Braucht `xdg.portal.wlr.enable` (ist gesetzt) und eine App, die das
Wayland-Portal kann — in Firefox klappt es, bei manchen Electron-Apps muss
Wayland erst erzwungen werden.

**Ein Programm startet nicht oder sieht kaputt aus.**
Manche X11-Programme kommen mit Wayland nicht klar. `wezterm-x11` aus
`modules/core.nix` zeigt das Muster: `WAYLAND_DISPLAY=""` davorsetzen, dann
läuft es über XWayland.

**Das Log ansehen.**
Wenn sway aus GDM gestartet wurde:

```bash
journalctl --user -b -u graphical-session.target
journalctl -b | grep -i sway
```

**Alles ist kaputt und die Session startet nicht mehr.**
Aus dem GDM-Bildschirm zurück auf GNOME wechseln, dort in Ruhe
`sway --validate -c ~/.config/sway/config` laufen lassen. GNOME bleibt
parallel installiert, genau dafür.

---

## Die Palette

CharmTone, die Farben von [charm.land](https://charm.land). Die vollständige
Liste steht in
[charmbracelet/x/exp/charmtone](https://github.com/charmbracelet/x/tree/main/exp/charmtone).

Hier benutzt:

| Name | Hex | Wofür |
|---|---|---|
| Pepper | `#201F26` | Hintergrund, Leiste |
| BBQ | `#2D2C36` | Hover in der Leiste, Tooltips |
| Char | `#3A3943` | inaktive Rahmen, Unterkante der Leiste |
| Iron | `#4D4C57` | stummgeschaltet |
| Squid | `#858392` | inaktive Schrift |
| Smoke | `#BFBCC8` | gedämpfte Schrift |
| Salt | `#F7F6FB` | Schrift |
| **Charple** | `#6B50FF` | aktives Fenster, aktiver Workspace |
| Hazy | `#8B75FF` | Split-Indikator, Akku |
| Malibu | `#00A4FF` | CPU, Passwortprüfung |
| Turtle | `#0ADCD9` | Lautstärke |
| Julep | `#00FFB2` | lädt, Treffer im Launcher, heute im Kalender |
| Guac | `#12C78F` | Netzwerk |
| Zest | `#E8FE96` | Akku niedrig |
| Mustard | `#F5EF34` | Modus-Anzeige, Feststelltaste |
| Cheeky | `#FF79D0` | RAM |
| Coral | `#FF577D` | offline |
| Sriracha | `#EB4268` | dringend, Akku kritisch, falsches Passwort |
