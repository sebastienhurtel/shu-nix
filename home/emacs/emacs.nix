{ pkgs, ... }:
let
  stable = with pkgs; [
    black
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
    nixpkgs-fmt
    pipenv
    poetry
    pyenv
    wl-clipboard
    python3Packages.nose
    dockerfile-language-server-nodejs
  ];
  unstable = with pkgs.unstable; [
    python3Packages.pytest
    python3Packages.pyflakes
  ];
in
{ home.packages = stable ++ unstable; }
