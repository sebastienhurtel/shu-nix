{ pkgs, username, ... }: {
  imports = [ ./shell/shell.nix ./shell/term.nix ./tmux/tmux.nix ];
  manual.manpages.enable = false;
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.packages = with pkgs; [
    ansible
    bat
    emacs
    eza
    fzf
    meslo-lgs-nf
    nil
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
