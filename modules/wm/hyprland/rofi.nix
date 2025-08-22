{
  username,
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.shu.rofi;
  style = import ./style.nix { inherit config username lib self; };
in
{
  options.shu.rofi.enable = lib.mkEnableOption "Enable Shu rofi";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs = {
        rofi = {
          enable = true;
          theme = style.rofi;
        };
      };
    };
  };
}
