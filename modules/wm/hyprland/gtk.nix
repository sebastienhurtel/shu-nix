{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.gtk;
in
{
  options.shu.gtk.enable = lib.mkEnableOption "Enable shu gtk";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      gtk = {
        enable = true;
        gtk3.extraConfig = {
          gtk-key-theme = "Emacs";
        };
        gtk4.extraConfig = {
          gtk-key-theme = "Emacs";
        };
      };
    };
  };
}
