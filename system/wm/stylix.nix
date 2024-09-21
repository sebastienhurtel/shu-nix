{
  username,
  stylix,
  config,
  lib,
  ...
}:

let
  cfg = config.shu.Stylix;
in
{
  options.shu.Stylix.enable = lib.mkEnableOption "Enable shuStylix";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      imports = [ stylix.homeManagerModules.stylix ];
      stylix = {
        enable = true;
        image = ../../wallpaper.png;
        polarity = "dark";
        targets = {
          gtk.enable = true;
          gnome.enable = true;
          alacritty.enable = false;
        };
      };
    };
  };
}
