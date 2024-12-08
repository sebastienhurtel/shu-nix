{
  config,
  ...
}:
{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ecdsa_age" ];
  shu = {
    dconf.enable = true;
    emacs.enable = true;
    git.enable = true;
    shell.enable = true;
    term.enable = true;
    tmux.enable = true;
  };
}
