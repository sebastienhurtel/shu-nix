{
  config,
  lib,
  pkgs,
  stylix,
  username,
  ...
}:
let
  cfg = config.shu.stylix;
in
{
  imports = [ stylix.nixosModules.stylix ];
  options.shu.stylix.enable = lib.mkEnableOption "Enable Stylix";
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
