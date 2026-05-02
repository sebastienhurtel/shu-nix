{ username, ... }:

{
  imports = [
    ./system.nix
    ./hardware.nix
  ];

  shu = {
    base.enable = true;
    hosts.aphex.system.enable = true;
    users.${username}.enable = true;
  };
}
