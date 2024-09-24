{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.Hyprland;
  workspaces = (
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
in
{
  options.shu.Hyprland.enable = lib.mkEnableOption "Enable shuHyprland";
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;

    home-manager.users.${username} = {
      programs.kitty.enable = true;
      home.sessionVariables.NIXOS_OZONE_WL = "1";
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.variables = [ "--all" ];
        settings = {
          "$mod" = "SUPER";
          bind = [
            "$mod, Q, killactive,"
            "$mod SHIFT, M, exit,"
            "$mod, F, togglefloating,"
            "$mod, G, togglegroup,"
            "$mod, bracketleft, changegroupactive, b"
            "$mod, bracketright, changegroupactive, f"

            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"

            "$mod SHIFT, h, movewindow, l"
            "$mod SHIFT, l, movewindow, r"
            "$mod SHIFT, k, movewindow, u"
            "$mod SHIFT, j, movewindow, d"
          ] ++ workspaces;
        };
      };
    };
  };
}
