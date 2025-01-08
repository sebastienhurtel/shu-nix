{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.syncthing;
in
{
  options.shu.home.syncthing.enable = lib.mkEnableOption "Enable shu home syncthing";
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
