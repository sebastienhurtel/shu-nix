{
  username,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.Mako;
in
{
  options.shu.Mako.enable = lib.mkEnableOption "Enable Shu Mako";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      services.mako = {
        enable = true;
        anchor = "top-center";
        borderRadius = 3;
        borderSize = 2;
        defaultTimeout = 20000;
        groupBy = "summary";
        iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
        layer = "overlay";
        padding = "5";
        sort = "-time";
        width = 400;
      };
    };
  };
}
