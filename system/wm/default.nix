{
  pkgs,
  config,
  lib,
  wm,
  ...
}:
with lib;
let
  cfg = config.services.shuWm;
  compositor = import ./wayland.nix { inherit config lib pkgs; };
  gnome = import ./gnome.nix { inherit pkgs; };
  hyprland = import ./hyprland.nix { inherit pkgs; };

  shuWm = {
    gnome = recursiveUpdate compositor gnome;
    hyprland = recursiveUpdate compositor hyprland;
    headless.services.xserver.enable = false;
  };
in
{
  options.services.shuWm.enable = mkEnableOption "Enable window manager.";
  config = mkIf cfg.enable shuWm.${wm};
}
