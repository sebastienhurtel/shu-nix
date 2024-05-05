{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.libinput ];

  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      xkbVariant = "";
      xkbOptions = "";
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus.enable = true;
  };
}
