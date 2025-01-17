{
  username,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.Hyprland;

  generalStartScript = pkgs.writeShellScriptBin "start" ''
    systemctl --user import-environment PATH &
    systemctl --user restart xdg-desktop-portal.service &
    sleep 2
  '';

  windowrulev2 = [
    "float, title:(rofi)"
    "float, class:(nm-connection-editor)"
    "float, class:((.*)blueman-manager(.*))"
    "size 30% 20%, class:((.*)blueman-manager(.*))"
    "float, class:(pavucontrol)"
    "size 40% 30%, class:(pavucontrol)"
    "workspace 1, class:^(Emacs)$"
    "workspace 1, class:^(Alacritty)$"
    "workspace 2, class:^(Google-chrome)$"
    "workspace 2, class:^(firefox)$"
  ];

  bind = {
    bind = [
      "$mod, E, exec, rofi -show drun -replace"
      "$mod, ESCAPE, exec, hyprlock"
      "$mod, Q, killactive,"
      "$mod SHIFT, M, exit,"
      "$mod, F, togglefloating,"
      "$mod, G, togglegroup,"
      "$mod, up, fullscreen,"
      "$mod, bracketleft, changegroupactive, b"
      "$mod, bracketright, changegroupactive, f"

      "$mod, O, layoutmsg, rollprev"
      "$mod SHIFT, O, layoutmsg, rollnext"

      "$mod, h, movefocus, l"
      "$mod, l, movefocus, r"
      "$mod, k, movefocus, u"
      "$mod, j, movefocus, d"

      "$mod SHIFT, h, movewindow, l"
      "$mod SHIFT, l, movewindow, r"
      "$mod SHIFT, k, movewindow, u"
      "$mod SHIFT, j, movewindow, d"
      "$mod, page_up, workspace, -1"
      "$mod, page_down, workspace, +1"

      ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
    ] ++ bind.workspaces;

    bindl = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+ --limit 1.8"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

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
  };

  exec-once = [
    (lib.getExe generalStartScript)
  ] ++ autostarts;

  autostarts = [
    "alacritty"
    "google-chrome-stable"
    "hypridle"
    "emacs"
    "waybar"
    "mako"
  ];
in
{
  options.shu.Hyprland.enable = lib.mkEnableOption "Enable shuHyprland";
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    shu = {
      Gtk.enable = false;
      Hypridle.enable = true;
      Hyprlock.enable = true;
      Mako.enable = true;
      Rofi.enable = true;
      Waybar.enable = true;
    };
    networking.networkmanager.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    security.pam.services.gdm.enableGnomeKeyring = true;

    home-manager.users.${username} = {
      services.udiskie.enable = true;
      services.gnome-keyring = {
        enable = true;
      };
      home.packages = with pkgs; [
        blueman
        brightnessctl
        fira
        font-awesome
        nautilus
        seahorse
        jetbrains-mono
        nerdfonts
        networkmanager_strongswan
        networkmanagerapplet
        papirus-icon-theme
        playerctl
        geist-font
      ];
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          exec-once = exec-once;
          bind = bind.bind;
          bindl = bind.bindl;
          monitor = [
            "eDP-1, 1920x1200@60, 0x0, 1"
            ", prefered, auto-left, 1"
          ];
          input = {
            kb_layout = "us_qwerty-fr";
          };
          general = {
            gaps_in = 5;
            gaps_out = [
              1
              8
              8
              8
            ];
            border_size = 2;
            resize_on_border = true;
            allow_tearing = false;
            layout = "master";
          };

          windowrulev2 = windowrulev2;

          gestures = {
            workspace_swipe = true;
            workspace_swipe_invert = true;
          };

          misc = {
            disable_autoreload = true;
            disable_hyprland_logo = true;
            always_follow_on_dnd = true;
            layers_hog_keyboard_focus = true;
            animate_manual_resizes = false;
            enable_swallow = true;
            focus_on_activate = true;
            new_window_takes_over_fullscreen = 2;
            middle_click_paste = false;
          };

          master = {
            special_scale_factor = 1.0;
            mfact = 0.54;
          };

          decoration = {
            rounding = 5;
            active_opacity = 0.99;
            inactive_opacity = 0.9;
            # fullscreen_opacity = 1.0;

            blur = {
              enabled = true;
              size = 2;
              passes = 2;
              brightness = 1;
              contrast = 1.4;
              ignore_opacity = true;
              noise = 0;
              new_optimizations = true;
              xray = true;
            };
          };
          animations = {
            enabled = true;
            bezier = [
              "myBezier, 0.05, 0.9, 0.1, 1.05"
            ];

            animation = [
              # name, enable, speed, curve, style
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 7, default"
              "borderangle, 1, 8, default"
              "fade, 1, 5, default"
              "workspaces, 1, 5, default, slide"
              "layersIn, 1, 4, default"
            ];
          };
        };
      };
    };
  };
}
