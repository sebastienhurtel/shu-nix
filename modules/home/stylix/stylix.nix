{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.stylix;
in
{
  # Stylix is imported at system level, home-manager options are automagically detected
  options.shu.home.stylix.enable = lib.mkEnableOption "Enable shu home stylix";
  config = lib.mkIf cfg.enable {
    stylix.targets = {
      alacritty.enable = false;
      tmux.enable = false;
      emacs.enable = false;
      waybar.enable = false;
      rofi.enable = false;
    };
  };
}
