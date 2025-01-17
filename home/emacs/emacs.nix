{ pkgs, ... }:
let
  stable = with pkgs; [
    black
    dockerfile-language-server-nodejs
    dockfmt
    emacs
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
  ];
  unstable = with pkgs.unstable; [
    python3Packages.pytest
    python3Packages.pyflakes
    nixfmt-rfc-style
    nixd
  ];
in
{
  home.packages = stable ++ unstable;
}
