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
    with pkgs.unstable;
    [
      black
      dockerfile-language-server
      dockfmt
      gcc
      gomodifytags
      gore
      graphviz
      isort
      libtool
      libxml2
      shellcheck
      shfmt
    ]
    ++ nodePackages
    ++ emacsPackages
    ++ pythonPackages
    ++ rustPackges
    ++ goPackages
    ++ nixPackages
    ++ [ emacs ];
  nixPackages = with pkgs.unstable; [
    nixd
    nixfmt-rfc-style
  ];
  goPackages = with pkgs.unstable; [
    go
    gopls
    gotests
    gotools
  ];
  rustPackges = with pkgs.unstable; [
    cargo
    rust-analyzer
    rustc
    rustfmt
  ];
  nodePackages = with pkgs.unstable; [
    nodePackages_latest.bash-language-server
  ];
  pythonPackages = with pkgs; [
    uv
    pipenv
    poetry
    pyenv
    pyright
    python3Packages.nose2pytest
    python3Packages.pyflakes
    python3Packages.pytest
  ];
  emacsPackages = with pkgs.emacsPackages; [
    editorconfig
    sqlite3
    vterm
  ];
  file =
    let
      tree-sitter-languages =
        let
          langs = [
            "dockerfile"
            "go"
            "gomod"
            "gowork"
            "nix"
            "python"
            "rust"
            "yaml"
            "yang"
          ];
        in
        pkgs.runCommand "tree-sitter-languages" { } ''
          mkdir -p $out
          ${lib.concatMapStringsSep "\n" (lang: ''
            cp ${pkgs.tree-sitter-grammars."tree-sitter-${lang}"}/parser $out/libtree-sitter-${lang}.so
          '') langs}
        '';
    in
    {
      ".config/emacs/.local/etc/tree-sitter".source = tree-sitter-languages;
    };
in
{
  options.shu.home.emacs.enable = lib.mkEnableOption "Enable shu home emacs";
  config = lib.mkIf cfg.enable {
    home = {
      inherit file packages;
    };
    services.emacs = {
      enable = true;
      package = emacs;
      startWithUserSession = "graphical";
      client = {
        enable = true;
        arguments = [
          "-c"
          "-n"
        ];
      };
    };
  };
}
