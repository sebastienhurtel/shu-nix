{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.shu.home.alacritty;
in
{
  options.shu.home.alacritty.enable = lib.mkEnableOption "enable shu home alacritty";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal = {
            shell = {
              program = "${pkgs.zsh}/bin/zsh";
              args = [
                "-l"
                "-c"
                "tmux attach || tmux"
              ];
            };
          };

          window = {
            decorations = "none";
            blur = true;
            dimensions = {
              columns = 110;
              lines = 80;
            };
            padding = {
              x = 5;
              y = 4;
            };
          };

          keyboard = {
            bindings = [
              {
                key = "N";
                mods = "Control";
                action = "SpawnNewInstance";
              }
            ];
          };
        };
      };
    };
  };
}
