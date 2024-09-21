{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.Wm;
in
{
  imports = [ ./gnome.nix ./wayland.nix ./hyprland.nix ./stylix.nix ];
  options.shu.Wm = with lib; {
    enable = mkEnableOption "Enable window manager.";
    manager = mkOption {
      type = types.str;
      default = "gnome";
    };
  };
  config = lib.mkIf cfg.enable {
    shu.Wayland.enable = true;
    shu.Stylix.enable = true;
    shu.Gnome.enable = if cfg.manager == "gnome" then true else false;
    shu.Hyprland.enable = if cfg.manager == "hyprland" then true else false;
  };
}
