{
  config,
  lib,
  pkgs,
  self,
  stylix,
  ...
}:
let
  cfg = config.shu.stylix;
in
{
  imports = [ stylix.nixosModules.stylix ];
  options.shu.stylix.enable = lib.mkEnableOption "Enable shuStylix";
  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = "${self}/wallpaper.png";
      polarity = "dark";
      opacity.applications = 0.9;
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
      fonts = {
        monospace = {
          package = pkgs.meslo-lgs-nf;
          name = "MesloLGS NF";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "Cantarell";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sizes = {
          applications = 12;
          terminal = 10;
          desktop = 10;
          popups = 10;
        };
      };
      cursor = {
        name = "Vanilla-DMZ-AA";
        size = 24;
      };
    };
  };
}
