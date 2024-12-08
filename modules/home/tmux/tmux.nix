{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.tmux;
in
{
  options.shu.tmux.enable = lib.mkEnableOption "Enable Shu tmux";
  config = lib.mkIf cfg.enable {
    home.file.".config/tmux/shu-tmux.conf".source = ./shu-tmux.conf;
    home.file.".config/tmux/tmux.conf.local".source = ./tmux.conf.local;
    programs.tmux = {
      enable = true;
      extraConfig = ''
        source -q ~/.config/tmux/shu-tmux.conf
      '';
    };
  };
}
