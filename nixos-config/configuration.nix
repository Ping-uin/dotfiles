# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Hardware configuration wird jetzt über die flake.nix eingebunden
    # ./hardware-configuration.nix  # Entfernt, da über flake geladen
    ./gnome-config.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Wifi adapter driver
  hardware.enableRedistributableFirmware = true;
  boot.extraModulePackages = [config.boot.kernelPackages.rtl8821au];
  boot.kernelModules = ["8821au"];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # networking.hostName = "vivo"; # Hostname wird jetzt über flake.nix gesetzt
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # GNOME Extensions Support
  services.udev.packages = with pkgs; [gnome-settings-daemon];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.ping_uin = {
    isNormalUser = true;
    description = "Max";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    neovim #-nightly
    ghostty
    wezterm
    (writeShellScriptBin "wezterm-x11" ''
      WAYLAND_DISPLAY="" ${wezterm}/bin/wezterm "$@"
    '')
    btop
    atuin
    alejandra
    ani-cli
    protonvpn-gui
    vscode
    zsh
    nmap
    rpi-imager
    obsidian
    signal-desktop
    discord
    neofetch
    fastfetch
    fzf
    chezmoi
    tree-sitter
    usbutils
    pciutils
    spotify
    zoxide

    # C++
    clang
    clang-tools # clang-format, clang-tidy, etc.
    lldb # Debugger
    cmake
    ninja
    pkg-config
    glibc
    gcc
    binutils

    # Rust
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Julia
    julia

    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.setuptools
    python3Packages.wheel
    pyright

    # JavaScript
    nodejs
    yarn
    nodePackages.vscode-langservers-extracted

    # GNOME Extensions TODO: Check if those can be removed in here
    gnomeExtensions.blur-my-shell
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals
    gnomeExtensions.workspace-indicator
    gnomeExtensions.removable-drive-menu

    # Lua
    lua-language-server

    orchis-theme

    # Theme-Tools
    gnome-tweaks # Für GUI-Konfiguration

    # simple rebuild script
    #(writeShellScriptBin "nix_rebuild.sh" ''
    # ${builtins.readFile /home/ping_uin/nixos-config/nix_rebuild.sh}
    # '')
  ];

  # Fonts configuration
  fonts.packages = with pkgs; [
    julia-mono
  ];

  services.logind = {
    # Wichtig: Deaktiviert suspend-then-hibernate und setzt Lid-Switch-Verhalten
    extraConfig = ''
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=suspend
      HandlePowerKey=poweroff # Moved this here
      # Optional: Verhindert auch SuspendKey und SleepKey vom Hibernate
      # HandleSuspendKey=suspend
      # HandleHibernateKey=suspend
    '';
  };

  # Deaktiviert suspend-then-hibernate systemweit
  systemd.sleep.extraConfig = ''
    SuspendMode=mem
    HibernateMode=
    HibernateState=
    HybridSleepMode=
    HybridSleepState=
  '';

  nix.optimise.automatic = true;

  # Zsh configuration
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "zoxide"
        "vi-mode"
      ];
      theme = "robbyrussell";
    };
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    shellAliases = {
      rb = "nix flake update ~/nixos-config && sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname) --impure";
      rbb = "zsh ~/nixos-config/nix_rebuild.sh";
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/ping_uin/nixos-config";
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent ={
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
