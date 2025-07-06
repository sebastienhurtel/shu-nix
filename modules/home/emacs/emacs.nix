{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.emacs;
  emacs = pkgs.emacs-pgtk;
  packages =
    with pkgs;
    [
      black
      dockerfile-language-server-nodejs
      dockfmt
      gomodifytags
      gopls
      gore
      gotests
      gotools
      graphviz
      isort
      libxml2
      nixd
      nixfmt-rfc-style
      nodePackages_latest.bash-language-server
      pipenv
      poetry
      pyenv
      pyright
      shellcheck
      shfmt
      uv
      wl-clipboard
    ]
    ++ [ emacs ];
  nodePackages = with pkgs.nodePackages_latest; [
    bash-language-server
  ];
  pythonPackages = with pkgs.python313Packages; [
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
    home.packages = packages ++ pythonPackages ++ nodePackages ++ emacsPackages;
    services.emacs = {
      enable = true;
      package = emacs;
      socketActivation.enable = true;
      startWithUserSession = "graphical";
      client.enable = true;
    };
  };
}
