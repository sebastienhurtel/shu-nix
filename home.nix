{
  pkgs,
  username,
  nix-index-database,
  agenix,
  wm,
  ...
}:
let

  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    containerlab
    coreutils
    curl
    difftastic
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
    libreoffice
    nmap
    procs
    pyright
    python3Packages.ipython
    ripgrep
    sd
    tree
    unzip
    vim
    vlc
    wget
    xclip
    zip
  ];

  stable-packages = with pkgs; [
    ansible
    gnumake
    meslo-lgs-nf
    nix-tree
    nvd
    nnn
    pass
    python3Packages.git-filter-repo
  ];

  graphical-packages = with pkgs; [
    audacity
    darktable
    firefox
    google-chrome
    parsec-bin
    pavucontrol
  ];

  home-packages =
    if wm != "headless" then
      stable-packages ++ unstable-packages ++ graphical-packages
    else
      stable-packages ++ unstable-packages;
in
{
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

  home.packages = home-packages;

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
