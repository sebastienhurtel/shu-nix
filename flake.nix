{
  description = "Shu's configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    with inputs;
    let

      nixpkgsWithOverlays = with inputs; rec {
        config.allowUnfree = true;
        overlays = [
          (_final: prev: {
            # this allows us to reference pkgs.unstable
            unstable = import nixpkgs-unstable {
              inherit (prev) system;
              inherit config;
            };
          })
        ];
      };

      configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = args;
        };
      };

      argDefaults = {
        inherit inputs self;
        channels = { inherit nixpkgs nixpkgs-unstable; };
      };

      mkNixosConfiguration = { system ? "x86_64-linux", hostname, username, wm
        , args ? { }, modules, }:
        let
          specialArgs = argDefaults // {
            inherit hostname username wm nixos-hardware;
          } // args;
        in nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            (configurationDefaults specialArgs)
            home-manager.nixosModules.home-manager
          ] ++ modules;
        };

    in {
      nixosConfigurations.vmarcus = mkNixosConfiguration {
        hostname = "vmarcus";
        username = "sebastien";
        wm = "gnome";
        modules = [ ./system.nix ./hardware/vmarcus.nix ];
      };

      nixosConfigurations.squarepusher = mkNixosConfiguration {
        hostname = "squarepusher";
        username = "sebastien";
        wm = "gnome";
        modules = [ ./system.nix ./hardware/squarepusher.nix ];
      };
    };
}
