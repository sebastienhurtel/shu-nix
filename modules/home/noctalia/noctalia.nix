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
  settings = lib.importTOML "${self}/modules/home/noctalia/noctalia-config.toml";
in
{
  options.shu.home.noctalia.enable = lib.mkEnableOption "Enable Shu Noctalia";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      imports = [
        noctalia.homeModules.default
      ];
      programs.noctalia = {
        inherit settings;
        enable = true;
        systemd.enable = true;
      };
    };
  };
}
