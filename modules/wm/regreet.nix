{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.regreet;
in
{
  options.shu.regreet.enable = lib.mkEnableOption "Enable shu regreet";
  config = lib.mkIf cfg.enable {
    programs.regreet = {
      enable = true;
    };
  };
}
