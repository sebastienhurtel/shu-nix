{
  config,
  wm,
  pkgs,
  ...
}:
{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ecdsa_age" ];
  shu.home = {
    dconf.enable = if wm != "headless" then true else true;
    emacs.enable = if wm != "headless" then true else true;
    git.enable = true;
    kanshi.enable = if wm == "hyprland" then true else false;
    mako.enable = false;
    shell.enable = true;
    stylix.enable = if wm != "headless" then true else true;
    term.enable = if wm != "headless" then true else true;
    tmux.enable = if wm != "headless" then true else true;
  };
  programs = {
    nnn = {
      enable = true;
      package = pkgs.nnn.override {
        withEmojis = true;
      };
    };
  };
}
