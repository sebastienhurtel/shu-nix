{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.hypridle;
in
{
  options.shu.hypridle.enable = lib.mkEnableOption "Enable Shu Hypridle";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      systemd.user.services.hypridle = {
        Unit = {
          PartOf = lib.mkForce [ "graphical-session.target" ];
          After = lib.mkForce [ "graphical-session.target" ];
        };
        Service = {
          Slice = [ "background-graphical.slice" ];
        };
      };
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "noctalia-shell ipc call lockScreen lock"; # avoid starting multiple hyprlock instances.
            before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
            after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
          };
        };
      };
    };
  };
}
