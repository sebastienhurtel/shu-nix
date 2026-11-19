{ ... }:

{
  imports = [
    ./ttl/ttl.nix
    ./base/base.nix
  ];
  fonts.fontconfig.hinting.style = "full";
}
