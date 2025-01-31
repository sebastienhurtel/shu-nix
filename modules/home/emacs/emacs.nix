{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.emacs;
  emacs = pkgs.emacs29-pgtk;
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
    libvterm
    libxml2
    nodePackages_latest.bash-language-server
    pipenv
    poetry
    pyenv
    pyright
    shellcheck
    shfmt
    wl-clipboard
  ];
  emacsPackages = with pkgs.emacsPackages; [
    editorconfig
    sqlite3
    vterm
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
    home.packages = stable ++ unstable ++ [ emacs ] ++ emacsPackages;
    services.emacs = {
      package = emacs;
      socketActivation.enable = true;
      startWithUserSession = "graphical";
    };
  };
}
