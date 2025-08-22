{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.emacs;
  emacs = pkgs.emacs-pgtk;
  packages = with pkgs.unstable; [
    black
    dockerfile-language-server-nodejs
    dockfmt
    gcc
    gomodifytags
    gopls
    gore
    gotests
    gotools
    graphviz
    isort
    libtool
    libxml2
    nixd
    nixfmt-rfc-style
    pipenv
    poetry
    pyenv
    pyright
    shellcheck
    shfmt
    uv
  ];
  nodePackages = with pkgs.unstable.nodePackages_latest; [
    bash-language-server
  ];
  pythonPackages = with pkgs.python3Packages; [
    nose2pytest
    pyflakes
    pytest
  ];
  emacsPackages = with pkgs.emacsPackages; [
    editorconfig
    sqlite3
    vterm
  ];

in
{
  options.shu.home.emacs.enable = lib.mkEnableOption "Enable shu home emacs";
  config = lib.mkIf cfg.enable {
    home.packages = packages ++ pythonPackages ++ nodePackages ++ emacsPackages ++ [ emacs ];
    services.emacs = {
      enable = true;
      package = emacs;
      socketActivation.enable = true;
      startWithUserSession = "graphical";
      client.enable = true;
    };
  };
}
