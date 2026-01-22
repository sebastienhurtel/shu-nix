{
  config,
  lib,
  username,
  stylix,
  ...
}:
let
  cfg = config.shu.stylix;
  hmStylix = config.home-manager.users.${username}.stylix;
in
{
  options.shu.stylix.enable = lib.mkEnableOption "Enable Stylix";
  imports = [ stylix.nixosModules.stylix ];
  config = lib.mkIf cfg.enable {
    stylix = {
      inherit (hmStylix) image base16Scheme;
      enable = true;
      homeManagerIntegration = {
        autoImport = false;
        followSystem = false;
      };
      polarity = "dark";
    };
  };
}
