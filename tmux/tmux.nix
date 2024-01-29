{ ... }:

{
  home.file.".tmux.conf".source = ./tmux.conf;
  programs.tmux = {
    enable = true;
    shell = "\${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 10000;
    mouse = true;
  };
}
