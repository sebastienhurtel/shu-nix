{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.dm;
  dmConfigs = {
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
        greeterManagesPlymouth = true;
      };
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
    services = dmConfigs.${cfg.dm};
  };
}
