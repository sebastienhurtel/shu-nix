{ pkgs, ... }:

{
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    pam.services.login.enableGnomeKeyring = true;
  };

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
      pulse.enable = true;
      jack.enable = true;
    };
  };

  #  programs = {
  #    hyprland = {
  #      enable = true;
  #      xwayland = { enable = true; };
  #      portalPackage = pkgs.xdg-desktop-portal-hyprland;
  #    };
  #    dconf.enable = true;
  #  };

}
