{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.Wayland;
in
{
  options.shu.Wayland.enable = lib.mkEnableOption "Enable shuWayland";
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
