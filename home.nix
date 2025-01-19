{
  agenix,
  nix-index-database,
  pkgs,
  username,
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
    du-dust
    duf
    fd
    findutils
    fx
    fzf
    git-crypt
    htop
    immich-cli
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
    vlc
    wget
    yt-dlp
    zip
  ];

  stable-packages = with pkgs; [
    ansible
    gnumake
    gopass
    meslo-lgs-nf
    nix-tree
    nvd
    pass
    python3Packages.git-filter-repo
  ];

  ui-packages =
    with pkgs;
    [
      audacity
      darktable
      firefox
      google-chrome
      pwvucontrol
      libreoffice
      xclip
    ];

  home-packages =
    if wm == "headless" then
      stable-packages ++ unstable-packages
    else
      stable-packages ++ unstable-packages ++ ui-packages;
in
{
  imports = [
    ./modules/home
    ./users/${username}.nix
    agenix.homeManagerModules.default
    nix-index-database.hmModules.nix-index
  ];
  manual.manpages.enable = false;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = home-packages;
  };

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
