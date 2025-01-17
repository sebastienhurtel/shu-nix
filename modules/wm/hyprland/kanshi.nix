{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.kanshi;
in
{
  options.shu.kanshi.enable = lib.mkEnableOption "Enable shu kanshi";
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
            name = "docked-lid-closed";
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
        {
          profile = {
            name = "docked-lid-open";
            outputs = [
              {
                criteria = "Samsung Electric Company LS27R75 H4ZN301143";
                status = "enable";
                mode = "2560x1440@144";
                position = "0,0";
              }
              {
                criteria = "eDP-1";
                status = "enable";
              }
            ];
          };
        }
      ];
      systemdTarget = "graphical-session.target";
    };
  };
}
