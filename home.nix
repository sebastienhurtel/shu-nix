{
  agenix,
  nix-index-database,
  pkgs,
  username,
  wm,
  ...
}:
let
  pyangPackage =
    with pkgs.python3Packages;
    buildPythonPackage rec {
      pname = "pyang";
      version = "2.6.1";
      pyproject = true;

      src = pkgs.fetchFromGitHub {
        owner = "mbj4668";
        repo = pname;
        rev = "pyang-${version}";
        hash = "sha256-sZokdBegfkDUXuf9lHIZ7AJzjomxSRpwyX+myquQy3Y=";
      };
      # setuptools is not needed if version > 2.6.1
      inputs =
        if lib.versionOlder version "2.6.1" then
          [ lxml ]
        else
          [
            lxml
            setuptools
          ];
      propagatedBuildInputs = inputs;
    };

  packages = with pkgs.unstable; [
    bat
    bottom
    cargo
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
    gnumake
    gopass
    htop
    immich-cli
    ipcalc
    jq
    killall
    libqalculate
    meslo-lgs-nf
    mpv
    nix-tree
    nmap
    nvd
    pass
    procs
    python3Packages.git-filter-repo
    python3Packages.ipython
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    sd
    tree
    unzip
    vim
    vlc
    wget
    yt-dlp
    zip
  ];

  ui-packages = with pkgs; [
    audacity
    darktable
    firefox
    google-chrome
    imagemagick
    libreoffice
    pwvucontrol
    wl-clipboard
  ];

  home-packages =
    if wm == "headless" then
      packages
    else
      packages ++ ui-packages;
in
{
  imports = [
    ./modules/home
    ./users/${username}.nix
    agenix.homeManagerModules.default
    nix-index-database.homeModules.nix-index
  ];
  manual.manpages.enable = false;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = home-packages ++ [ pyangPackage ];
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
