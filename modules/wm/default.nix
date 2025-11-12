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
    shu.gnome.enable = if cfg.manager == "gnome" then true else false;
    shu.hyprland.enable = if cfg.manager == "hyprland" then true else false;
    shu.stylix.enable = if cfg.manager != "headless" then true else false;
  };
}
