{ pkgs, username, ... }: {
  imports = [
    ./home/shell/shell.nix
    ./home/shell/term.nix
    ./home/tmux/tmux.nix
    ./home/dconf/dconf.nix
    ./home/emacs/emacs.nix
  ];
  manual.manpages.enable = false;
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.packages = with pkgs; [
    ansible
    audacity
    bat
    eza
    firefox
    fzf
    google-chrome
    libqalculate
    meslo-lgs-nf
    nil
    nnn
    parsec-bin
    pavucontrol
    tmux
    xclip
  ];
  # required to autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
}
