{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.shu.home.kitty;
in
{
  options.shu.home.kitty.enable = lib.mkEnableOption "enable shu home term";
  config = lib.mkIf cfg.enable {
    home-manager.users."${username}" = {
      programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        enableGitIntegration = true;
        keybindings = {
          "ctrl+n" = "new_os_window";
        };
        settings = {
          confirm_os_window_close = 0;
          text_composition_strategy = "1.7 30";
          shell = "${pkgs.tmux}/bin/tmux new-session -A -s main";
        };
      };
    };
  };
}
