{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.shu.home.stylix;
in
{
  # Stylix is imported at system level, home-manager options are automagically detected
  options.shu.home.stylix.enable = lib.mkEnableOption "Enable shu home stylix";
  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = "${self}/wallpaper.png";
      polarity = "dark";
      opacity = {
        applications = 0.9;
        desktop = 0.5;
      };
      fonts = {
        monospace = {
          package = pkgs.meslo-lgs-nf;
          name = "MesloLGS NF";
        };
        sansSerif = {
          package = pkgs.cantarell-fonts;
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
        package = pkgs.vanilla-dmz;
      };
      iconTheme = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus";
      };
      targets = {
        alacritty.enable = false;
        tmux.enable = false;
        emacs.enable = false;
        rofi.enable = false;
      };
    };
  };
}
