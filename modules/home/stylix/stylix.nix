{
  config,
  lib,
  pkgs,
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
