{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.dm;
  gdm = {
    libinput.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus.enable = true;
  };

  greetd = {
    libinput.enable = true;
    greetd = {
      enable = true;
      restart = true;
    };
  };

in
{
  options.shu.dm = {
    enable = lib.mkEnableOption "Enable shu dm";
    dm =
      with lib;
      mkOption {
        type = types.enum [
          "greetd"
          "gdm"
        ];
        default = "gdm";
      };
  };
  config = lib.mkIf cfg.enable {
    security.pam.services.gdm.enableGnomeKeyring = if config.shu.wm == "gnome" then true else false;
    services =
      if cfg.dm == "greetd" then
        greetd
      else if cfg.dm == "gdm" then
        gdm
      else
        "";
  };
}
