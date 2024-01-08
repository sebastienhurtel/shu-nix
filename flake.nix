{
  description = "Shu";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      #	pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        vmarcus = lib.nixosSystem {
          inherit system;
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                users.sebastien = import ./home.nix;
              };
            }
          ];
        };
      };
      #		homeConfigurations = {
      #			sebastien = home-manager.lib.homeManagerConfiguration {
      #				inherit pkgs;
      #				modules = [ ./home.nix ];
      #			};
      #		};
    };
}
