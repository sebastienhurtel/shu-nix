{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.mako;
in
{
  options.shu.home.mako.enable = lib.mkEnableOption "Enable shu home mako";
  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = false;
      anchor = "top-center";
      borderRadius = 3;
      borderSize = 2;
      defaultTimeout = 45;
      groupBy = "summary";
      iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
      layer = "overlay";
      padding = "5";
      sort = "-time";
      width = 400;
    };
  };
}
