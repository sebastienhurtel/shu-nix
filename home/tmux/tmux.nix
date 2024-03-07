{ ... }:

{
  home.file.".config/tmux/shu-tmux.conf".source = ./shu-tmux.conf;
  home.file.".config/tmux/tmux.local.conf".source = ./tmux.local.conf;
  programs.tmux = {
    enable = true;
    extraConfig = ''
      source ~/.config/tmux/shu-tmux.conf
    '';
  };
}
