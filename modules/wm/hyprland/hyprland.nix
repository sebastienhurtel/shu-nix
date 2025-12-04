{
  username,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.hyprland;

  volumeUpScript = pkgs.writeShellScriptBin "volumeUp" ''
    MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg -q MUTED && echo "yes" || echo "no")
    if [ "$MUTED" = "yes" ]; then
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+ --limit 1.8
  '';

  volumeUp = lib.getExe volumeUpScript;

  volumeDownScript = pkgs.writeShellScriptBin "volumeDown" ''
    MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg -q MUTED && echo "yes" || echo "no")
    if [ "$MUTED" = "yes" ]; then
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-
  '';

  volumeDown = lib.getExe volumeDownScript;

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

  windowrule = [
    "float, title:(rofi)"
    "float, class:(nm-connection-editor)"
    "float, class:((.*)Overskride(.*))"
    "size 50% 40%, class:((.*)Overskride(.*))"
    "float, class:(pwvucontrol)"
    "size 45% 35%, class:(pwvucontrol)"
    "float, class:(^.*copyq$)"
    "size 45% 35%, class:(^.*copyq$)"
    "workspace 1, class:^(emacs)$"
    "move 10 54, class:^(emacs)$"
    "workspace 1, initialTitle:^(Alacritty)$"
    "workspace 2, class:^(google-chrome)$"
    "workspace 3, class:^(firefox)$"
    "workspace 4, class:^(steam)$"
    "float,class:(nnn)"
    "centerwindow,class:(nnn)"
    "workspace special:nnn,class:^(nnn)$"
  ];

  binds = {
    bind = [
      "$mod, E, exec, rofi -show drun -replace"
      "$mod, ESCAPE, exec, hyprlock"
      "$mod, Q, killactive,"
      "$mod SHIFT, F, togglefloating,"
      "$mod, up, fullscreen, 1"
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
      "$mod, G, togglegroup,"
      "$mod, bracketleft, changegroupactive, b"
      "$mod, bracketright, changegroupactive, f"
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
      "$mod, F, exec, hyprctl dispatch togglespecialworkspace ${pkgs.alacritty}/bin/alacritty --class nnn -e ${pkgs.nnn}/bin/nnn || ${pkgs.alacritty}/bin/alacritty --class nnn -e ${pkgs.nnn}/bin/nnn"
    ]
    ++ binds.workspaces;

    bindl = [
      ", XF86AudioRaiseVolume, exec, ${volumeUp}"
      ", XF86AudioLowerVolume, exec, ${volumeDown}"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", switch:off:Lid Switch, exec, ${pkgs.kanshi}/bin/kanshictl switch docked-lid-open"
      ", switch:on:Lid Switch, exec, ${pkgs.kanshi}/bin/kanshictl switch docked-lid-closed"
      ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"
      ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%"
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

  gestures = [
    "3, horizontal, workspace"
  ];

  exec-once = [
    "uwsm app -- ${pkgs.alacritty}/bin/alacritty -e zsh -c 'tmux new-session -A -s 0'"
    "uwsm app -- ${pkgs.alacritty}/bin/alacritty -e zsh -c 'tmux new-session -A -s 1'"
    "uwsm app -- ${pkgs.google-chrome}/bin/google-chrome-stable"
  ];

in
{
  options.shu.hyprland.enable = lib.mkEnableOption "Enable shuHyprland";
  config = lib.mkIf cfg.enable {
    services.gnome.gcr-ssh-agent.enable = true;
    programs = {
      uwsm.package = pkgs.uwsm;
      hyprland = {
        enable = true;
        withUWSM = true;
      };
      regreet.enable = true;
      seahorse.enable = true;
    };
    networking.networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-strongswan ];
    };
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.logind.settings.Login.HandlePowerKey = "suspend";
    shu = {
      gtk.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      rofi.enable = true;
      waybar.enable = true;
      swaync.enable = true;
    };

    home-manager.users.${username} = {
      shu.home.kanshi.enable = true;
      services = {
        copyq.enable = true;
        hyprpaper.enable = true;
        hyprpolkitagent.enable = true;
        network-manager-applet.enable = true;
        udiskie.enable = true;
        gnome-keyring = {
          enable = true;
          components = [
            "pkcs11"
            "secrets"
          ];
        };
      };
      home = {
        packages = with pkgs; [
          brightnessctl
          fira
          font-awesome
          geist-font
          grimblast
          jetbrains-mono
          nautilus
          nerd-fonts.jetbrains-mono
          overskride
          papirus-icon-theme
          playerctl
        ];
        sessionVariables.NIXOS_OZONE_WL = "1";
      };
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        settings = {
          "$mod" = "SUPER";
          exec-once = exec-once;
          bind = binds.bind;
          bindl = binds.bindl;
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

          windowrule = windowrule;

          gesture = gestures;

          misc = {
            always_follow_on_dnd = true;
            animate_manual_resizes = false;
            disable_autoreload = true;
            disable_hyprland_logo = true;
            focus_on_activate = true;
            layers_hog_keyboard_focus = true;
            middle_click_paste = false;
            new_window_takes_over_fullscreen = 2;
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
              "myBezier, 0.02, 0.7, 0.1, 1.02"
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
