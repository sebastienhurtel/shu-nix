{ ... }:

{
  home.file.".config/tmux/shu-tmux.conf".source = ./shu-tmux.conf;
  home.file.".config/tmux/tmux.conf.local".source = ./tmux.conf.local;
  programs.tmux = {
    enable = true;
    extraConfig = ''
      source -q ~/.config/tmux/shu-tmux.conf
    '';
  };
}
