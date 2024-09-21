{
  username,
  stylix,
  ...
}:
{
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
}
