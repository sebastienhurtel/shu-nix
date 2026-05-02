pkgs: {
  pyang = pkgs.callPackage ./pyang.nix { };
  libnetconf2 = pkgs.callPackage ./libnetconf2.nix { };
  sysrepo = pkgs.callPackage ./sysrepo.nix { };
  netopeer2 = pkgs.callPackage ./netopeer2.nix { };
  libyang-cpp = pkgs.callPackage ./libyang-cpp.nix { };
  netconf-cli = pkgs.callPackage ./netconf-cli.nix { };
}
