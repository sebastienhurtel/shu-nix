{
  pkgs,
  config,
  lib,
  username,
  system,
  inputs,
  ...
}:
let
  cfg = config.services.shuWm;
  wm = cfg.wm;
  compositor = import ./wayland.nix { inherit config lib pkgs; };
  gnome = import ./gnome.nix { inherit pkgs; };
  hyprland = import ./hyprland.nix {
    inherit
      pkgs
      username
      system
      config
      inputs
      ;
  };
  stylix = import ./stylix.nix;

  WmSet = with lib; {
    gnome = (recursiveUpdate compositor gnome);
    hyprland = recursiveUpdate compositor hyprland;
    headless.services.xserver.enable = false;
  };

in
{
  options.services.shuWm = with lib; {
    enable = mkEnableOption "Enable window manager.";
    wm = mkOption {
      type = types.str;
      default = "gnome";
    };
  };
  config = WmSet.${wm};
}
