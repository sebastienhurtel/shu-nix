{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.tmux;
in
{
  options.shu.home.tmux.enable = lib.mkEnableOption "Enable shu home tmux";
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
