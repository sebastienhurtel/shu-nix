{
  description = "Shu's configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    with inputs;
    let
      nixpkgsWithOverlays = rec {
        config.allowUnfree = true;
        overlays = [
          (_final: prev: {
            # this allows us to reference pkgs.unstable
            unstable = import nixpkgs-unstable {
              inherit (prev) system;
              inherit config;
            };
          })
          (_final: prev: {
            nixd = prev.nixd.overrideAttrs (old: {
              src = prev.fetchFromGitHub {
                owner = "sebastienhurtel";
                repo = "nixd";
                rev = "2120080b7241821a009a382852e0891ca011a1c4";
                hash = "sha256-ndPbt3KLSbTc+AvWvtVkJXsvvjeaL2TEsMFu0hFmMHk=";
              };
            });
          })
        ];
      };

      configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager = {
          extraSpecialArgs = args;
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };

      argDefaults = {
        inherit
          self
          inputs
          agenix
          nix-index-database
          nixos-hardware
          ;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
      };

      mkNixosConfiguration =
        {
          system ? "x86_64-linux",
          hostname,
          username,
          wm ? "headless",
          args ? { },
          modules,
        }:
        let
          specialArgs = argDefaults // { inherit hostname username wm; } // args;
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            (configurationDefaults specialArgs)
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
          ] ++ modules;
        };
    in
    {
      nixosConfigurations.vmarcus = mkNixosConfiguration {
        hostname = "vmarcus";
        username = "sebastien";
        wm = "gnome";
        modules = [
          ./system.nix
          ./hardware/vmarcus.nix
        ];
      };

      nixosConfigurations.squarepusher = mkNixosConfiguration {
        hostname = "squarepusher";
        username = "sebastien";
        wm = "gnome";
        modules = [
          ./system.nix
          ./hardware/squarepusher.nix
        ];
      };

      nixosConfigurations.deftones = mkNixosConfiguration {
        hostname = "deftones";
        username = "sebastien";
        modules = [
          ./system.nix
          ./hardware/deftones.nix
        ];
      };
    };
}
