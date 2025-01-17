{
  config,
  wm,
  pkgs,
  ...
}:
{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ecdsa_age" ];
  shu.home = {
    dconf.enable = if wm == "headless" then false else true;
    emacs.enable = if wm == "headless" then false else true;
    git.enable = true;
    kanshi.enable = if wm == "headless" then false else true;
    mako.enable = false;
    shell.enable = true;
    stylix.enable = if wm == "headless" then false else true;
    swaync.enable = true;
    term.enable = true;
    tmux.enable = true;
  };
  programs = {
    nnn = {
      enable = true;
      plugins = {
        mappings = {
          i = "imgview";
        };
        src =
          (pkgs.fetchFromGitHub {
            owner = "jarun";
            repo = "nnn";
            rev = "v5.0";
            sha256 = "sha256-HShHSjqD0zeE1/St1Y2dUeHfac6HQnPFfjmFvSuEXUA=";
          })
          + "/plugins";
      };
    };
  };
}
