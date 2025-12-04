{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.gnome;
in
{
  options.shu.gnome.enable = lib.mkEnableOption "Enable shu gnome";
  config = lib.mkIf cfg.enable {
    services = {
      xserver.desktopManager.gnome.enable = true;
      power-profiles-daemon.enable = false;
      udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
      gnome.gnome-keyring.enable = true;
    };

    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-tour
        power-profiles-daemon
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gnome-terminal
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        gnome-software
        gnome-contacts
        gnome-clocks
        gnome-maps
        gnome-weather
      ]);
  };
}
