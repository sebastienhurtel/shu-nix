{
  description = "Shu's configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-bwrapper.url = "github:Naxdy/nix-bwrapper";
  };

  outputs =
    inputs:
    with inputs;
    let
      nixpkgsWithOverlays = {
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            # this allows us to reference pkgs.unstable
            unstable = import nixpkgs-unstable {
              inherit (final) config;
              inherit (final.stdenv.hostPlatform) system;
            };
            pyang = final.pkgs.callPackage ./packages/pyang.nix { };
            libnetconf2 = final.pkgs.callPackage ./packages/libnetconf2.nix { };
            sysrepo = final.pkgs.callPackage ./packages/sysrepo.nix { };
            netopeer2 = final.pkgs.callPackage ./packages/netopeer2.nix { };
          })
          nix-bwrapper.overlays.default
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
          disko
          nix-index-database
          nixos-hardware
          stylix
          noctalia
          nix-bwrapper
          nixpkgs-unstable
          ;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
      };

      mkNixosConfiguration =
        {
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
          inherit specialArgs;
          modules = [
            (configurationDefaults specialArgs)
            home-manager.nixosModules.home-manager
          ]
          ++ modules;
        };
    in
    {
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

      nixosConfigurations.aphex = mkNixosConfiguration {
        hostname = "aphex";
        username = "sebastien";
        modules = [
          ./system.nix
        ];
      };
    };
}
