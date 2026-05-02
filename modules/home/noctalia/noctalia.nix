{
  noctalia,
  config,
  lib,
  self,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.noctalia;
  settings = lib.importJSON "${self}/modules/home/noctalia/noctalia.json";
in
{
  imports = [
    noctalia.homeModules.default
  ];
  options.shu.home.noctalia.enable = lib.mkEnableOption "Enable Shu Noctalia";
  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      inherit settings;
      enable = true;
      package = (
        noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          calendarSupport = true;
        }
      );
    };
  };
}
