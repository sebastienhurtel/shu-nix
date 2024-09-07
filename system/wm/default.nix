{
  config,
  lib,
  ...
}:
let
  cfg = config.services.shuWm;
in
{
  imports = [ ./gnome.nix ./wayland.nix ./hyprland.nix ./stylix.nix ];
  options.services.shuWm = with lib; {
    enable = mkEnableOption "Enable window manager.";
    manager = mkOption {
      type = types.str;
      default = "gnome";
    };
  };
  config = lib.mkIf cfg.enable {
    services.shuWayland.enable = true;
    services.shuGnome.enable = if cfg.manager == "gnome" then true else false;
    services.shuHyprland.enable = if cfg.manager == "hyprland" then true else false;
  };
}
