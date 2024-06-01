{ pkgs, username, nix-index-database, agenix, ... }:
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
    git-crypt
    htop
    jq
    killall
    libqalculate
    nmap
    procs
    python3Packages.ipython
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
    darktable
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
    python3Packages.git-filter-repo
  ];

in {
  imports = [
    nix-index-database.hmModules.nix-index
    agenix.homeManagerModules.default
    ./home
  ];
  manual.manpages.enable = false;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
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
