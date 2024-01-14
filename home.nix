{ pkgs, ... }: {
  imports = [ ./hyprland.nix ./shell.nix ./term.nix ];
  manual.manpages.enable = false;
  home.username = "sebastien";
  home.homeDirectory = "/home/sebastien";
  home.packages = with pkgs; [
    ansible
    alacritty
    emacs
    bat
    direnv
    eza
    fzf
    meslo-lgs-nf
    nil
    nix-direnv
    nnn
    tmux
    xclip
  ];
  # required to autoload fonts from packages installed via Home Manager
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
}
