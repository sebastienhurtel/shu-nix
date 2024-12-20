{
  config,
  wm,
  ...
}:
{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ecdsa_age" ];
  shu = {
    dconf.enable = if wm == "headless" then false else true;
    emacs.enable = if wm == "headless" then false else true;
    git.enable = true;
    kanshi.enable = if wm == "headless" then false else true;
    shell.enable = true;
    stylix.enable = if wm == "headless" then false else true;
    term.enable = true;
    tmux.enable = true;
  };
  programs = {
    nnn.enable = true;
  };
}
