{ wm, ... }:

{
  imports = [ ./${wm}.nix ./wayland.nix ];
}
