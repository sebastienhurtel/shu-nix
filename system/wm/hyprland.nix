{
  username,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.Hyprland;
in
{
  options.shu.Hyprland.enable = lib.mkEnableOption "Enable shuHyprland";
  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config = {
          common = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };
      };
    };
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = {
        "$mod" = "SUPER";
        "exec-once" = "alacritty";
        bind =
          [
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            )
          );
      };
    };
  };
}
