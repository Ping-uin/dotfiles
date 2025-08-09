{
  description = "Nixos config by Ping_uin";
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    neovim-nightly-overlay,
  }: let
    system = "x86_64-linux";
    # Overlay for unstable packages
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      # private laptop (asus vivobook)
      vivo = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./hardware/laptop-hardware.nix
          ({
            config,
            pkgs,
            ...
          }: {
            # set hostname
            networking.hostName = "vivo";
            nixpkgs.overlays = [
              overlay-unstable
              neovim-nightly-overlay.overlays.default
            ];
          })
        ];
      };

      # priv desktop pc
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./hardware/desktop-hardware.nix
          ({
            config,
            pkgs,
            ...
          }: {
            # set hostname
            networking.hostName = "desktop";
            nixpkgs.overlays = [
              overlay-unstable
              neovim-nightly-overlay.overlays.default
            ];
          })
        ];
      };
    };
  };
}
