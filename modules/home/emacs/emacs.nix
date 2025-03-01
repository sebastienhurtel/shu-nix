{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.emacs;
  emacs = pkgs.emacs30-pgtk;
  stable = with pkgs; [
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
    nodePackages_latest.bash-language-server
    pipenv
    poetry
    pyenv
    pyright
    shellcheck
    shfmt
    uv
    wl-clipboard
  ];
  emacsPackages = with pkgs.emacsPackages; [
    editorconfig
    sqlite3
    vterm
  ];
  unstable = with pkgs.unstable; [
    python313Packages.pytest
    python313Packages.pyflakes
    nixfmt-rfc-style
    nixd
  ];
in
{
  options.shu.home.emacs.enable = lib.mkEnableOption "Enable shu home emacs";
  config = lib.mkIf cfg.enable {
    home.packages = stable ++ unstable ++ emacsPackages ++ [ emacs ];
    services.emacs = {
      enable = true;
      package = emacs;
      socketActivation.enable = true;
      startWithUserSession = "graphical";
    };
  };
}
