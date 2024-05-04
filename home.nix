{ pkgs, username, nix-index-database, ... }:
let

  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    containerlab
    coreutils
    curl
    dig
    duf
    du-dust
    fd
    findutils
    fx
    fzf
    git
    git-crypt
    htop
    jq
    killall
    libqalculate
    nmap
    procs
    ripgrep
    sd
    tree
    unzip
    vim
    wget
    xclip
    zip
  ];

  stable-packages = with pkgs; [
    ansible
    audacity
    eza
    firefox
    google-chrome
    gnumake
    meslo-lgs-nf
    nil
    nix-tree
    nvd
    nnn
    parsec-bin
    pavucontrol
  ];

in {
  imports = [
    nix-index-database.hmModules.nix-index
    ./home/shell/shell.nix
    ./home/shell/term.nix
    ./home/tmux/tmux.nix
    ./home/dconf/dconf.nix
    ./home/emacs/emacs.nix
  ];
  manual.manpages.enable = false;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
  };

  home.packages = stable-packages ++ unstable-packages;

  # required to autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
}
