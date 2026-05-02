{ username, ... }:
{
  imports = [
    ./hardware.nix
    ./system.nix
  ];

  shu = {
    base.enable = true;
    hosts.deftones.system.enable = true;
    users.${username}.enable = true;
  };
}
