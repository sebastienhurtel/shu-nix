{
  pkgs,
  config,
  lib,
  wm,
  ...
}:
let
  cfg = config.services.shuWm;
  compositor = import ./wayland.nix { inherit config lib pkgs; };
  gnome = import ./gnome.nix { inherit pkgs; };
  hyprland = import ./hyprland.nix { inherit pkgs; };

  shuWm = {
    gnome = lib.recursiveUpdate compositor gnome;
    hyprland = lib.recursiveUpdate compositor hyprland;
    headless.services.xserver.enable = false;
  };
in
{
  options.services.shuWm.enable = lib.mkEnableOption "Enable window manager.";
  config = lib.mkIf cfg.enable shuWm.${wm};
}
