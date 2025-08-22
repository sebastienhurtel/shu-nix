{
  username,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.shell;
in
{
  options.shu.home.shell.enable = lib.mkEnableOption "Enable shu home shell";
  config = lib.mkIf cfg.enable {
    home.file.".config/zsh/.p10k.zsh".source = ./p10k.zsh;

    age.secrets.shScripts = {
      file = ../../../secrets/shScripts.age;
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
          toclip = "wl-copy";
          tmate = "env -u TMUX tmate";
          q = "noglob qalc";
          clab = "containerlab";
        };
        plugins = [
          {
            name = "fzf-tab";
            src = pkgs.fetchFromGitHub {
              owner = "Aloxaf";
              repo = "fzf-tab";
              rev = "fc6f0dcb2d5e41a4a685bfe9af2f2393dc39f689";
              sha256 = "sha256-1g3kToboNGXNJTd+LEIB/j76VgPdYqG2PNs3u6Zke9s=";
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
        initContent = ''
          # Powerlevel10k Zsh theme
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh
          # Custom scripts
          test -f ~/.config/zsh/vpn.sh && source ~/.config/zsh/vpn.sh
          pssh () { ${pkgs.sshpass}/bin/sshpass -f <(${pkgs.pass}/bin/pass show free/ssh) ssh "$@"; }
          compdef pssh='ssh'
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
            "direnv"
            "fzf"
            "fzf-tab"
            "git"
            "git-extras"
            "jsontools"
            "pipenv"
            "python"
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
        icons = "auto";
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
  };
}
