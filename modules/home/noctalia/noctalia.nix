{
  config,
  lib,
  noctalia,
  self,
  username,
  ...
}:
let
  cfg = config.shu.home.noctalia;
  settings = lib.importJSON "${self}/modules/home/noctalia/noctalia.json";
in
{
  options.shu.home.noctalia.enable = lib.mkEnableOption "Enable Shu Noctalia";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      imports = [
        noctalia.homeModules.default
      ];
      programs.noctalia-shell = {
        inherit settings;
        enable = true;
        systemd.enable = true;
      };
    };
  };
}
