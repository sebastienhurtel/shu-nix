{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.wm;
in
{
  imports = [
    ./dm.nix
    ./gnome.nix
    ./hyprland
    ./stylix.nix
  ];
  options.shu.wm = with lib; {
    enable = mkEnableOption "Enable window manager.";
    manager = mkOption {
      type = types.str;
      default = "gnome";
    };
  };
  config = lib.mkIf cfg.enable {
    shu.dm = {
      enable = true;
      dm = if cfg.manager == "gnome" then "gdm" else "greetd";
    };
    shu.gnome.enable = cfg.manager == "gnome";
    shu.hyprland.enable = cfg.manager == "hyprland";
    shu.stylix.enable = cfg.manager != "headless";
  };
}
