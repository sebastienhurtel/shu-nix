{
  config,
  lib,
  pkgs,
  username,
  stylix,
  ...
}:
let
  cfg = config.shu.stylix;
in
{
  options.shu.stylix.enable = lib.mkEnableOption "Enable Stylix";
  imports = [ stylix.nixosModules.stylix ];
  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      homeManagerIntegration.autoImport = true;
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
      image = config.home-manager.users.${username}.stylix.image;
      polarity = "dark";
    };
  };
}
