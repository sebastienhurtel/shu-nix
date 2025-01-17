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

    stylix = {
      url = "github:danth/stylix?rev=d042af478ce87e188139480922a3085218194106";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
                owner = "nix-community";
                repo = "nixd";
                rev = "c9d8970a646dbaa82981d050d905637a29bbdd21";
                hash = "sha256-tBvNlNvI3xRjmfUuzwgwWFrk+SO50wlrmAGRuG3Yzi4=";
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
          stylix
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
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
          ] ++ modules;
        };
    in
    {
      nixosConfigurations.vmarcus = mkNixosConfiguration {
        hostname = "vmarcus";
        username = "sebastien";
        wm = "hyprland";
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
