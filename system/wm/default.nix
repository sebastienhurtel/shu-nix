{ pkgs, config, lib, wm, ... }:
let
  cfg = config.services.shu-wm;
  compositor = import ./wayland.nix { inherit config lib pkgs; };
  gnome = import ./gnome.nix { inherit pkgs; };
  hyprland = import ./hyprland.nix { inherit pkgs; };

  mkWm = wm: {
    gnome = lib.recursiveUpdate compositor gnome;
    hyprland = lib.recursiveUpdate compositor hyprland;
    headless.services.xserver.enable = false;
  };

  shu-wm = mkWm wm;
in
{
  options.services.shu-wm.enable = lib.mkEnableOption "Enable window manager.";
  config = lib.mkIf cfg.enable shu-wm.${wm};
}
