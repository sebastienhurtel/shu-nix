{ pkgs, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      xkbOptions = "caps:escape";
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
  };
  hardware.pulseaudio.enable = false;
}
