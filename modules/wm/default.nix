{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.wm;
in
{
  imports = [ ./gnome.nix ./wayland.nix ./hyprland ];
  options.shu.wm = with lib; {
    enable = mkEnableOption "Enable window manager.";
    manager = mkOption {
      type = types.str;
      default = "gnome";
    };
  };
  config = lib.mkIf cfg.enable {
    shu.wayland.enable = true;
    shu.Gnome.enable = if cfg.manager == "gnome" then true else false;
    shu.hyprland.enable = if cfg.manager == "hyprland" then true else false;
  };
}
