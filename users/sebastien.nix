{
  agenix,
  config,
  pkgs,
  wm,
  ...
}:
{
  imports = [ agenix.homeManagerModules.default ];
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ecdsa_age" ];
  shu.home = {
    dconf.enable = if wm == "gnome" then true else false;
    emacs.enable = if wm != "headless" then true else true;
    git.enable = true;
    shell.enable = true;
    stylix.enable = if wm != "headless" then true else false;
    term.enable = if wm == "headless" then false else true;
    tmux.enable = if wm == "headless" then false else true;
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
