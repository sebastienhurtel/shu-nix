{ pkgs, self, config, username, ... }:
{

  home.file.".config/zsh/.p10k.zsh".source = ./p10k.zsh;

  age.secrets.shScripts = {
    file = ../../secrets/shScripts.age;
    path = "/home/${username}/.config/zsh/vpn.sh";
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";
      shellAliases = {
        l = "eza";
        e = "emacsclient -n";
        toclip = "xclip -selection c";
        tmate = "env -u TMUX tmate";
        q = "noglob qalc";
        clab = "containerlab";
        pssh = ''{ ${pkgs.passh} -p <(pass show free/ssh) ssh "$@"; }'';
      };
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "bf3ef5588af6d3bf7cc60f2ad2c1c95bca216241";
            sha256 = "0hv21mp6429ny60y7fyn4xbznk31ab4nkkdjf6kjbnf6bwphxxnk";
          };
        }
        {
          name = "clab";
          src = pkgs.fetchFromGitHub {
            owner = "sebastienhurtel";
            repo = "clab-zsh-completion";
            rev = "e28ace10b210bf0a054367faf5834151ca04e3c4";
            sha256 = "0ilj010nv6vch56ckp28vyz9s4cr39fql04d73gzfqjjz2iz43im";
          };
        }
      ];
      initExtra = ''
        # Powerlevel10k Zsh theme
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh
        # Custom scripts
        test -f ~/.config/zsh/vpn.sh && source ~/.config/zsh/vpn.sh
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
          "clab"
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
          compdef pssh='ssh'
        '';
      };
    };

    eza = {
      package = pkgs.unstable.eza;
      enable = true;
      icons = true;
      git = true;
      extraOptions = [
        "--all"
        "--git"
        "--group"
        "--long"
        "--reverse"
        "--sort=date"
      ];
    };
  };
}
