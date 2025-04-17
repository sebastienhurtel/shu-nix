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
        gtk2.extraConfig = ''
          gtk-key-theme-name = "Emacs";
          gtk-icon-theme-name = "Papirus-Dark";
        '';
        gtk3.extraConfig = {
          gtk-key-theme-name = "Emacs";
          gtk-icon-theme-name = "Papirus-Dark";
        };
        gtk4.extraConfig = {
          gtk-key-theme-name = "Emacs";
          gtk-icon-theme-name = "Papirus-Dark";
        };
      };
    };
  };
}
