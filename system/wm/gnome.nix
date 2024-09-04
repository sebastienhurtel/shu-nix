{ config, lib, pkgs, ... }:
let
  cfg = config.services.shuGnome;
in
{
  options.services.shuGnome.enable = lib.mkEnableOption "Enable shuGnome";
  config = lib.mkIf cfg.enable {
    services = {
      xserver.desktopManager.gnome.enable = true;
      power-profiles-daemon.enable = false;
      udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
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
