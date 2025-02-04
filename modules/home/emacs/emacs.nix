{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.emacs;
  stable = with pkgs; [
    black
    dockerfile-language-server-nodejs
    dockfmt
    emacs29-pgtk
    emacsPackages.sqlite3
    emacsPackages.vterm
    gomodifytags
    gopls
    gore
    gotests
    gotools
    graphviz
    isort
    libvterm
    nodePackages_latest.bash-language-server
    pipenv
    poetry
    pyenv
    wl-clipboard
    pyright
  ];
  unstable = with pkgs.unstable; [
    python3Packages.pytest
    python3Packages.pyflakes
    nixfmt-rfc-style
    nixd
  ];
in
{
  options.shu.home.emacs.enable = lib.mkEnableOption "Enable shu home emacs";
  config = lib.mkIf cfg.enable {
    home.packages = stable ++ unstable;
    services.emacs = {
      enable = true;
      socketActivation.enable = true;
      startWithUserSession = "graphical";
    };
  };
}
