{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.dm;
  gdm = {
    libinput.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus.enable = true;
  };

  hyprlandConfig = pkgs.writeText "greetd-hyprland-config" ''
    execr-once = ${pkgs.zsh}/bin/zsh -c ${config.programs.regreet.package}/bin/regreet; ${config.programs.hyprland.package}/bin/hyprctl dispatch exit/hyprland
    monitor=eDP-1, 1920x1200@60, 0x0, 1
    monitor=, prefered, auto-left, 1
    monitor=FALLBACK, 1920x1080@60, auto, 1
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
    }
  '';

  greetd = {
    libinput.enable = true;
    greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.hyprland} --config ${hyprlandConfig}";
          user = "greeter";
        };
      };
    };
  };

in
{
  options.shu.dm = {
    enable = lib.mkEnableOption "Enable shu dm";
    dm =
      with lib;
      mkOption {
        type = types.enum [
          "greetd"
          "gdm"
        ];
        default = "gdm";
      };
  };
  config = lib.mkIf cfg.enable {
    security.pam.services.gdm.enableGnomeKeyring = if config.shu.wm == "gnome" then true else false;
    services =
      if cfg.dm == "greetd" then
        greetd
      else if cfg.dm == "gdm" then
        gdm
      else
        "";
  };
}
