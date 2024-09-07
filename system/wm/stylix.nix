{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = ../../wallpaper.png;
    fonts.packages = [ pkgs.meslo-lgs-nf ];
  };
}
