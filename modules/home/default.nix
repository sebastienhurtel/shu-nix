{ ... }:

{
  imports = [
    ./shell/shell.nix
    ./shell/term.nix
    ./tmux/tmux.nix
    ./emacs/emacs.nix
    ./dconf/dconf.nix
    ./git/git.nix
    ./stylix/stylix.nix
    ./mako/mako.nix
    ./swaync/swaync.nix
  ];
}
