{
  description = "Shu's configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
      url = "github:danth/stylix/release-24.11";
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
          specialArgs = argDefaults // args // { inherit hostname username wm; };
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
        ];
      };

      nixosConfigurations.squarepusher = mkNixosConfiguration {
        hostname = "squarepusher";
        username = "sebastien";
        wm = "hyprland";
        modules = [
          ./system.nix
        ];
      };

      nixosConfigurations.deftones = mkNixosConfiguration {
        hostname = "deftones";
        username = "sebastien";
        modules = [
          ./system.nix
        ];
      };
    };
}
