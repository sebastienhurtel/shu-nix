{
  agenix,
  config,
  wm,
  pkgs,
  nix-index-database,
  lib,
  username,
  ...
}:
let
  cfg = config.shu.users.sebastien;
  hmConfig = config.home-manager.users.${username};
  packages = with pkgs; [
    bat
    bottom
    containerlab
    coreutils
    curl
    difftastic
    dig
    duf
    dust
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
    nix-tree
    nmap
    nvd
    pass
    procs
    pyang
    python3Packages.git-filter-repo
    python3Packages.ipython
    ripgrep
    sd
    tree
    unzip
    vim
    yt-dlp
    zip
  ];

  ui-packages = with pkgs; [
    audacity
    firefox
    google-chrome
    imagemagick
    libreoffice
    mpv
    plex-desktop
    poppler
    pwvucontrol
    resvg
    vlc
    wget
    wl-clipboard
  ];

  home-packages = if wm == "headless" then packages else packages ++ ui-packages;
in
{
  options.shu.users.sebastien.enable = lib.mkEnableOption "Enable sebastien user";

  config = lib.mkIf cfg.enable {
    users.users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "scanner"
        "lp"
        "wireshark"
      ];
    };

    security = {
      sudo.wheelNeedsPassword = false;
      rtkit.enable = true;
    };

    shu.home = {
      claude-code.enable = if wm != "headless" then true else false;
      dconf.enable = if wm == "gnome" then true else false;
      emacs.enable = if wm != "headless" then true else false;
      git.enable = true;
      shell.enable = true;
      stylix.enable = if wm != "headless" then true else false;
      term.enable = if wm == "headless" then false else true;
      tmux.enable = if wm == "headless" then false else true;
    };

    home-manager.users.${username} = {
      imports = [
        agenix.homeManagerModules.default
        nix-index-database.homeModules.default
      ];

      age.identityPaths = [
        "${hmConfig.home.homeDirectory}/.ssh/id_ecdsa_age"
      ];

      xdg.enable = true;

      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        packages = home-packages;
        # The state version is required and should stay at the version you
        # originally installed.
        stateVersion = "23.11";
      };

      programs = {
        home-manager.enable = true;
        nix-index.enable = true;
        nix-index.enableZshIntegration = true;
        nix-index-database.comma.enable = true;
        yazi = {
          enable = true;
          enableZshIntegration = true;
          shellWrapperName = "y";
        };
      };

      services = {
        gnome-keyring = {
          enable = true;
          components = [
            "pkcs11"
            "secrets"
          ];
        };
      };
    };
  };
}
