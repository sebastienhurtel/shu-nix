{
  config,
  lib,
  pkgs,
  username,
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
    preload = /home/${username}/.dotfiles/wallpaper.png
    wallpaper =, /home/${username}/.dotfiles/wallpaper.png
    exec = ${pkgs.zsh} -c "${pkgs.greetd.regreet}/bin/regreet; ${pkgs.hyprland}/bin/hyprctl dispatch exit"
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
    }
  '';

  greetd = {
    libinput.enable = true;
    greetd = {
      enable = true;
      package = pkgs.greetd.regreet;
      settings = {
        initial_session = {
          command = "{pkgs.hyprland}/bin/Hyprland --config ${hyprlandConfig}";
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
    services = if cfg.dm == "greetd" then greetd else if cfg.dm == "gdm" then gdm else "";
  };
}
