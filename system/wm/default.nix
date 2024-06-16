{ pkgs, config, lib, wm, ... }:
with lib;
let
  cfg = config.services.shu-wm;
  compositor = import ./wayland.nix { inherit config lib pkgs; };
  gnome = import ./gnome.nix { inherit pkgs; };
  hyprland = import ./hyprland.nix { inherit pkgs; };

  shu-wm = {
    gnome = recursiveUpdate compositor gnome;
    hyprland = recursiveUpdate compositor hyprland;
    headless.services.xserver.enable = false;
  };
in
{
  options.services.shu-wm.enable = mkEnableOption "Enable window manager.";
  config = mkIf cfg.enable shu-wm.${wm};
}
