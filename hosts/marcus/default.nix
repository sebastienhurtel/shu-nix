{ username, ... }:
{
  imports = [
    ./hardware.nix
    ./system.nix
  ];

  shu = {
    base.enable = true;
    hosts.marcus.system.enable = true;
    users.${username}.enable = true;
  };
  fonts.fontconfig.subpixel.rgba = "rgb";
}
