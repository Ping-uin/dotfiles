# gnome-config.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  # GNOME Extensions systemweit verfügbar machen
  environment.systemPackages = with pkgs.gnomeExtensions;
    [
      dash-to-dock
      user-themes
      vitals
      blur-my-shell
      appindicator
    ]
    ++ (with pkgs; [
      orchis-theme
      (writeShellScriptBin "setup-gnome-user" ''
        echo "Setting up user-specific GNOME settings..."

        # Extensions aktivieren
        gnome-extensions enable apps-menu@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable system-monitor@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable status-icons@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable window-list@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable places-menu@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable dash-to-dock@micxgx.gmail.com
        gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable Vitals@CoreCoding.com
        gnome-extensions enable blur-my-shell@aunetx
        gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

        # Extensions deaktivieren
        gnome-extensions disable launch-new-instance@gnome-shell-extensions.gcampax.github.com
        gnome-extensions disable light-style@gnome-shell-extensions.gcampax.github.com
        gnome-extensions disable screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com
        gnome-extensions disable windowsNavigator@gnome-shell-extensions.gcampax.github.com
        gnome-extensions disable workspace-indicator@gnome-shell-extensions.gcampax.github.com
        gnome-extensions disable clipboard-indicator@tudmotu.com

        # Favorite Apps setzen
        gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.wezfurlong.wezterm.desktop']"

        # Eingabequellen
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'de')]"
        gsettings set org.gnome.desktop.input-sources xkb-options "['terminate:ctrl_alt_bksp', 'lv3:ralt_switch']"

        # Search Providers
        gsettings set org.gnome.desktop.search-providers sort-order "['org.gnome.Settings.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Nautilus.desktop']"

        # Hintergrundbild (falls vorhanden)
        if [ -f "$HOME/Firefox_wallpaper.png" ]; then
          gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Firefox_wallpaper.png"
          gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Firefox_wallpaper.png"
        fi

        echo "GNOME user setup complete! You may need to log out and back in for all changes to take effect."
      '')
    ]);

  # GNOME Services und Grundkonfiguration
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Einfache GSettings Overrides
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.interface]
    color-scheme='prefer-dark'
    gtk-theme='Orchis'
    icon-theme='Adwaita'
    show-battery-percentage=true
    accent-color='blue'

    [org.gnome.desktop.peripherals.mouse]
    accel-profile='flat'
    speed=0.52713178294573648

    [org.gnome.desktop.peripherals.touchpad]
    click-method='areas'
    natural-scroll=true
    tap-to-click=true
    two-finger-scrolling-enabled=true

    [org.gnome.desktop.wm.preferences]
    button-layout='appmenu:minimize,maximize,close'

    [org.gnome.mutter]
    dynamic-workspaces=true

    [org.gnome.desktop.sound]
    event-sounds=true
    theme-name='__custom'

    [org.gnome.nautilus.preferences]
    default-folder-viewer='icon-view'
    search-filter-time-type='last_modified'

    [org.gnome.settings-daemon.plugins.power]
    power-button-action='interactive'
    sleep-inactive-ac-timeout=1800
    sleep-inactive-ac-type='nothing'
    sleep-inactive-battery-type='nothing'

    [org.gnome.shell]
    disable-user-extensions=false

    [org.gnome.shell.extensions.dash-to-dock]
    always-center-icons=false
    dock-position='BOTTOM'
    dash-max-icon-size=32
    show-favorites=true
    show-trash=false

    [org.gnome.shell.extensions.appindicator]
    legacy-tray-enabled=true

    [org.gnome.tweaks]
    show-extensions-notice=false
  '';

  # GNOME ausgeschlossene Pakete
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
  ];

  # dconf aktivieren
  programs.dconf.enable = true;
}
