{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.swaync;
in
{
  options.shu.home.swaync.enable = lib.mkEnableOption "Enable shu home swaync";
  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = {
        control-center-layer = "top";
        cssPriority = "application";
        fit-to-screen = false;
        layer = "overlay";
        layer-shell = true;
        notification-2fa-action = true;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        positionX = "center";
        positionY = "top";
      };
    };
  };
}
