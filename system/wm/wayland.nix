{
  pkgs,
  lib,
  config,
  ...
}:
{
  services = {
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    xserver = {
      enable = true;
      xkb.variant = "";
      xkb.options = "";
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus.enable = true;
  };
}
