{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.wayland;
in
{
  options.shu.wayland.enable = lib.mkEnableOption "Enable shu Wayland";
  config = lib.mkIf cfg.enable {
    services = {
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
  };
}
