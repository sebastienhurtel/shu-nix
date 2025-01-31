{
  username,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.hyprland;

  generalStartScript = pkgs.writeShellScriptBin "start" ''
    systemctl --user enable --now hyprpaper.service
    systemctl --user enable --now hyprpolkitagent.service
  '';

  mainWorkspaceScript = pkgs.writeShellScriptBin "mainWorkspace" ''
    EMACS_WINDOW_NAME="emacs"
    ALACRITTY_WINDOW_TOP="alacritty_top"
    ALACRITTY_WINDOW_BOTTOM="alacritty_bottom"
    sleep 3
    ${pkgs.alacritty}/bin/alacritty --class "$ALACRITTY_WINDOW_TOP" -e zsh -c "tmux new-session -A -s 0"
    ${pkgs.alacritty}/bin/alacritty --class "$ALACRITTY_WINDOW_BOTTOM" -e zsh -c "tmux new-session -A -s 1"
    ${pkgs.emacs29-pgtk}/bin/emacsclient -n
    ${pkgs.hyprland}/bin/hyprctl --batch '\
        keyword windowrule "workspace unset, $EMACS_WINDOW_NAME";\
        keyword windowrule "workspace unset, $ALACRITTY_WINDOW_TOP";\
        keyword windowrule "workspace unset, $ALACRITTY_WINDOW_BOTTOM";\
        dispatch focuswindow "$EMACS_WINDOW_NAME";\
        dispatch movewindow to 0 0;\
        dispatch focuswindow "$ALACRITTY_WINDOW_TOP";\
        dispatch movewindow to 60% 0;\
        dispatch focuswindow "$ALACRITTY_WINDOW_BOTTOM";\
        dispatch movewindow to 60% 50%'
  '';

  toggleAnimationsScript = pkgs.writeShellScriptBin "toggleAnimations" ''
    HYPRGAMEMODE=$(${pkgs.hyprland}/bin/hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        ${pkgs.hyprland}/bin/hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        exit
    fi
    ${pkgs.hyprland}/bin/hyprctl reload
  '';

  toggleAnimations = lib.getExe toggleAnimationsScript;

  windowrulev2 = [
    "float, title:(rofi)"
    "float, class:(nm-connection-editor)"
    "float, class:((.*)Overskride(.*))"
    "size 45% 35%, class:((.*)Overskride(.*))"
    "float, class:(pwvucontrol)"
    "size 40% 30%, class:(pwvucontrol)"
    "workspace 1, class:^(Emacs)$"
    "workspace 1, initialTitle:^(Alacritty)$"
    "workspace 2, class:^(google-chrome)$"
    "workspace 3, class:^(firefox)$"
    "workspace 4, class:^(steam)$"
  ];

  bind = {
    bind = [
      "$mod, E, exec, rofi -show drun -replace"
      "$mod, ESCAPE, exec, hyprlock"
      "$mod, Q, killactive,"
      "$mod, F, togglefloating,"
      "$mod, G, togglegroup,"
      "$mod, up, fullscreen, 1"
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
      "Control_L&SHIFT, h, movewindoworgroup, l"
      "Control_L&SHIFT, l, movewindoworgroup, r"
      "Control_L&SHIFT, k, movewindoworgroup, u"
      "Control_L&SHIFT, j, movewindoworgroup, d"
      "$mod, page_up, workspace, -1"
      "$mod, page_down, workspace, +1"
      "$mod, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
      ", Print, exec, ${pkgs.grimblast}/bin/grimblast --notify copysave area /home/${username}/Pictures/Screenshots/$(${pkgs.coreutils}/bin/coreutils --coreutils-prog=date --iso-8601=seconds).png"
      "SHIFT, Print, exec, ${pkgs.grimblast}/bin/grimblast --notify copysave output /home/${username}/Pictures/Screenshots/$(${pkgs.coreutils}/bin/coreutils --coreutils-prog=date --iso-8601=seconds).png"
      "$mod, A, exec, ${toggleAnimations}"
    ] ++ bind.workspaces;

    bindl = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+ --limit 1.8"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86PowerOff, exec, systemctl suspend"
      ", switch:off:Lid Switch, exec, ${pkgs.kanshi}/bin/kanshictl switch docked-lid-open"
      ", switch:on:Lid Switch, exec, ${pkgs.kanshi}/bin/kanshictl switch docked-lid-closed"
      ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
      ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +10%"
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
    (lib.getExe mainWorkspaceScript)
  ] ++ autostarts;

  autostarts = [
    "${pkgs.google-chrome}/bin/google-chrome-stable"
  ];

in
{
  options.shu.hyprland.enable = lib.mkEnableOption "Enable shuHyprland";
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    shu = {
      gtk.enable = true;
      Hypridle.enable = true;
      Hyprlock.enable = true;
      Rofi.enable = true;
      Waybar.enable = true;
      swaync.enable = true;
    };
    networking.networkmanager.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    home-manager.users.${username} = {
      services = {
        udiskie.enable = true;
        gnome-keyring = {
          enable = true;
          components = [
            "ssh"
            "pkcs11"
            "secrets"
          ];
        };
      };
      home.packages = with pkgs; [
        brightnessctl
        fira
        font-awesome
        geist-font
        grimblast
        hyprpolkitagent
        jetbrains-mono
        nautilus
        nerdfonts
        networkmanager_strongswan
        networkmanagerapplet
        overskride
        papirus-icon-theme
        playerctl
        seahorse
      ];
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      };
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        settings = {
          "$mod" = "SUPER";
          exec-once = exec-once;
          bind = bind.bind;
          bindl = bind.bindl;
          monitor = [
            "eDP-1, 1920x1200@60, 0x0, 1"
            ", prefered, auto-left, 1"
            #prevent hyprlock from crashing
            # https://github.com/hyprwm/hyprlock/issues/434
            "FALLBACK, 1920x1080@60, auto, 1"
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
            focus_on_activate = true;
            new_window_takes_over_fullscreen = 2;
            middle_click_paste = false;
          };

          master = {
            special_scale_factor = 1.0;
            mfact = 0.54;
          };

          decoration = {
            rounding = 6;
            active_opacity = 0.99;
            inactive_opacity = 0.89;
            fullscreen_opacity = 1.0;

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
