{ pkgs, ... }: {

  home.file.".config/zsh/.p10k.zsh".source = ./p10k.zsh;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
      l = "ls -larth";
      e = "emacsclient -n";
      toclip = "xclip -selection c";
      tmate = "env -u TMUX tmate";
      q = "noglob qalc";
    };
    plugins = [{
      name = "fzf-tab";
      src = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
        sha256 = "1b4pksrc573aklk71dn2zikiymsvq19bgvamrdffpf7azpq6kxl2";
      };
    }];
    initExtra = ''
      # Powerlevel10k Zsh theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh
    '';
    envExtra = ''
      # Add doom to path
      export PATH="$HOME/.config/emacs/bin:$PATH"
    '';
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/zsh";
      plugins = [
        "ansible"
        "docker"
        "docker-compose"
        "fd"
        "fzf"
        "fzf-tab"
        "git"
        "git-extras"
        "jsontools"
        "pipenv"
        "python"
        "ripgrep"
        "sudo"
        "tmux"
        "vagrant"
        "virtualenv"
      ];
    extraConfig = ''
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    '';
    };
  };
}
