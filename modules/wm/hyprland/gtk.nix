{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.Gtk;
in
{
  options.shu.Gtk.enable = lib.mkEnableOption "Enable Shu Gtk";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      gtk = {
        enable = true;
        gtk3.extraConfigs = {
          
        };
        gtk4.extraConfigs = {
          
        };
      };
    };
  };
}
