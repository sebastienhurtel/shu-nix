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
      nixfmt
      pipenv
      poetry
      pyenv
      wl-clipboard
      python311Packages.nose
    ];
    unstable = with pkgs.unstable; [
      python312Packages.pytest
      python312Packages.pyflakes
    ];
  in {
    home.packages = stable ++ unstable;
}
