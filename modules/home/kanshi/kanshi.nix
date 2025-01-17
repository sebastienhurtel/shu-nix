{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.kanshi;
in
{
  options.shu.kanshi.enable = lib.mkEnableOption "Enable Shu kanshi";
  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "docked";
            outputs = [
              {
                criteria = "Samsung Electric Company LS27R75 H4ZN301143";
                status = "enable";
                mode = "2560x1440@144";
                position = "0,0";
              }
              {
                criteria = "eDP-1";
                status = "disable";
              }
            ];
          };
        }
      ];
      systemdTarget = "hyprland-session.target";
    };
  };
}
