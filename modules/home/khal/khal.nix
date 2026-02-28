{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.khal;
in
{
  options.shu.home.khal.enable = lib.mkEnableOption "Enable Shu Khal";
  config = lib.mkIf cfg.enable {
    programs.khal = {
      enable = true;
    };
  };
}
