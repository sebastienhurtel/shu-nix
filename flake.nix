{
  description = "Shu's configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    with inputs;
    let
      userSettings = {
        theme =
          "uwunicorn-yt"; # selcted theme from my themes directory (./themes/)
        term = "alacritty"; # Default terminal command;
        font = "MesloLGS NF"; # Selected font
        fontPkg = pkgs.meslo-lgs-nf; # Font package
      };

      configurationDefaults = args: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = args;
        };
      };

      #TODO Check
      argDefaults = {
        inherit userSettings inputs self;
        channels = { inherit nixpkgs nixpkgs-unstable; };
      };

      mkNixosConfiguration =
        { system ? "x86_64-linux", hostname, username, args ? { }, modules, }:
        let specialArgs = argDefaults // { inherit hostname username; } // args;
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
        modules =
          [ ./system.nix ./workstation/system.nix ./hardware-vmarcus.nix ];
      };
    };
}
