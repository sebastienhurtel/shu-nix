{ ... }:

{
  home.file.".config/tmux/tmux.conf".source = ./tmux.conf;
  home.file.".config/tmux/tmux.local.conf".source = ./tmux.local.conf;
  programs.tmux = {
    enable = true;
    shell = "\${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 10000;
    mouse = true;
  };
}
