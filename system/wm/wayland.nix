{ ... }:

{
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

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
  hardware.pulseaudio.enable = false;
}
