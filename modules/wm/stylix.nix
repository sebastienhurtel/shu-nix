{
  username,
  stylix,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.shu.stylix;
in
{
  options.shu.stylix.enable = lib.mkEnableOption "Enable shuStylix";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      imports = [ stylix.homeManagerModules.stylix ];
      stylix = {
        enable = true;
        image = ../../wallpaper.png;
        polarity = "dark";
        opacity.applications = 0.9;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
        targets = {
          alacritty.enable = false;
          tmux.enable = false;
          emacs.enable = false;
          waybar.enable = false;
          rofi.enable = false;
        };

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
          name = "apple_cursor";
          package = pkgs.apple-cursor;
        };
      };
    };
  };
}
