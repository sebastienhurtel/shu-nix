{ ... }:

{
  imports = [
    ./shell/shell.nix
    ./shell/term.nix
    ./tmux/tmux.nix
    ./emacs/emacs.nix
    ./dconf/dconf.nix
    ./git/git.nix
    ./kanshi/kanshi.nix
    ./stylix/stylix.nix
  ];
}
