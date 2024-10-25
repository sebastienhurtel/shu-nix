{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.Rofi;
in
{
  options.shu.Rofi.enable = lib.mkEnableOption "Enable Shu Rofi";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.rofi = {
        enable = true;
      };
    };
  };
}
