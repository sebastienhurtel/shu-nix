{ username, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "/etc/profiles/per-user/${username}/bin/zsh";
        args = [
          "-l"
          "-c"
          "tmux attach || tmux"
        ];
      };

      window = {
        decorations = "None";
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

      colors.draw_bold_text_with_bright_colors = true;

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
}
