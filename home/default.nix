{ ... }:

{
  imports = [
    ./shell/shell.nix
    ./shell/term.nix
    ./tmux/tmux.nix
    ./emacs/emacs.nix
    ./dconf/dconf.nix
    ./age/age.nix
    ./git/git.nix
  ];
}
