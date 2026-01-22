{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.term;
in
{
  options.shu.home.term.enable = lib.mkEnableOption "enable shu home term";
  config = lib.mkIf cfg.enable {
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

        font = {
          size = 10.5;
          normal = {
            family = "meslolgs nf";
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

        colors = {
          draw_bold_text_with_bright_colors = true;
          primary = {
            background = "#1a1c1c";
            foreground = "#f99d32";
          };
          normal = {
            black = "#1d1f21";
            red = "#c01c28";
            green = "#26a269";
            yellow = "#f0c674";
            blue = "#0874be";
            magenta = "#a347ba";
            cyan = "#2aa1b3";
            white = "#c5c8c6";
          };
          bright = {
            black = "#5e5c64";
            red = "#f66151";
            green = "#33da7a";
            yellow = "#e9ad0c";
            blue = "#2a7bde";
            magenta = "#c061cb";
            cyan = "#33c7de";
            white = "#ffffff";
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
}
