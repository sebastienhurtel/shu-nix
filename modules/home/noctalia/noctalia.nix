{
  noctalia,
  config,
  lib,
  self,
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
      systemd.enable = true;
    };
  };
}
