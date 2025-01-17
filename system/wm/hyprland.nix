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
  autostarts = [
    "alacritty"
    "google-chrome-stable"
    "emacs"
    "waybar"
  ];
  exec-once = [
    (lib.getExe generalStartScript)
  ] ++ autostarts;
in
{
  options.shu.Hyprland.enable = lib.mkEnableOption "Enable shuHyprland";
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    networking.networkmanager.enable = true;
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        brightnessctl
        networkmanagerapplet
        networkmanager_strongswan
        gnome.nautilus
        gnome.seahorse
      ];
      home.sessionVariables.NIXOS_OZONE_WL = "1";
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          exec-once = exec-once;
          monitor = "eDP-1, 1920x1200@60, 0x0, 1";
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
            ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
            ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+ --limit 1.8"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-"
          ] ++ workspaces;
        };
      };
      programs.rofi = {
        enable = true;
      };

      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            margin-bottom = 0;
            margin-left = 0;
            margin-right = 0;
            spacing = 0;
            # Modules Left
            modules-left = [
              "custom/appmenu"
              #   "custom/settings"
              #   "custom/waybarthemes"
              #   "custom/wallpaper"
              "wlr/taskbar"
              "hyprland/window"
              #   "custom/starter"
            ];

            "custom/appmenu" = {
              "format" = "Apps";
              "on-click" = "rofi -show drun -replace";
              "tooltip" = false;
            };

            "wlr/taskbar" = {
              "format" = "{icon}";
              "icon-size" = 18;
              "tooltip-format" = "{title}";
              "on-click" = "activate";
              "on-click-middle" = "close";
              "ignore-list" = [
                "Alacritty"
              ];
            };

            "hyprland/window" = {
              "rewrite" = {
                "(.*) - Chrome" = "$1";
              };
              "separate-outputs" = true;
            };

            # Modules Center
            modules-center = [
              "hyprland/workspaces"
            ];

            "hyprland/workspaces" = {
              "on-click" = "activate";
              "active-only" = false;
              "all-outputs" = true;
              "format" = "{}";
              "format-icons" = {
                "urgent" = "";
                "active" = "";
                "default" = "";
              };
              "persistent-workspaces" = {
                "*" = 5;
              };
            };

            # Modules Right
            modules-right = [
              # "custom/updates"
              "pulseaudio"
              # "backlight"
              "bluetooth"
              "battery"
              "network"
              # "group/hardware"
              # "custom/cliphist"
              # "custom/hypridle"
              # "custom/hyprshade"
              "tray"
              # "custom/exit"
              # "custom/ml4w-welcome"
              "custom/system"
              "clock"
            ];

            "network" = {
              "format" = "{ifname}";
              "format-wifi" = "   {signalStrength}%";
              "format-ethernet" = "  {ipaddr}";
              "format-disconnected" = "Not connected";
              "tooltip-format" = " {ifname} via {gwaddri}";
              "tooltip-format-wifi" = "   {essid} ({signalStrength}%)";
              "tooltip-format-ethernet" = "  {ifname} ({ipaddr}/{cidr})";
              "tooltip-format-disconnected" = "Disconnected";
              "max-length" = 50;
              "on-click" = "nm-connection-editor";
            };

            "tray" = {
              "icon-size" = 21;
              "spacing" = 10;
            };

            "clock" = {
              "format" = "{:%H:%M %a}";
              "on-click" = "ags -t calendar";
              "tooltip" = false;
            };

            "pulseaudio" = {
              # "scroll-step" = 1; // %, can be a float
              "format" = "{icon} {volume}%";
              "format-bluetooth" = "{volume}%  {icon} {format_source}";
              "format-bluetooth-muted" = "  {icon} {format_source}";
              "format-muted" = "  {format_source}";
              "format-source" = "{volume}% ";
              "format-source-muted" = "";
              "format-icons" = {
                "headphone" = "";
                "hands-free" = "";
                "headset" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = [
                  ""
                  " "
                  " "
                ];
              };
              "on-click" = "pavucontrol";
            };
            "bluetooth" = {
              "format-disabled" = "";
              "format-off" = "";
              "interval" = 30;
              "on-click" = "blueman-manager";
              "format-no-controller" = "";
            };
            "battery" = {
              "states" = {
                "good" = 95;
                "warning" = 30;
                "critical" = 15;
              };
              "format" = "{icon}   {capacity}%";
              "format-charging" = "  {capacity}%";
              "format-plugged" = "  {capacity}%";
              "format-alt" = "{icon}  {time}";
              # "format-good" = "";
              # "format-full" = "";
              "format-icons" = [
                " "
                " "
                " "
                " "
                " "
              ];
            };
            "custom/system" = {
              "format" = "";
              "tooltip" = false;
            };
          };
        };
        style = ''
          @define-color backgroundlight #FFFFFF;
          @define-color backgrounddark #FFFFFF;
          @define-color workspacesbackground1 #FFFFFF;
          @define-color workspacesbackground2 #CCCCCC;
          @define-color bordercolor #FFFFFF;
          @define-color textcolor1 #000000;
          @define-color textcolor2 #000000;
          @define-color textcolor3 #FFFFFF;
          @define-color iconcolor #FFFFFF;

          /* -----------------------------------------------------
           * General
           * ----------------------------------------------------- */

          * {
              font-family: "Fira Sans Semibold", "Font Awesome 6 Free", FontAwesome,  Roboto, Helvetica, Arial, sans-serif;
              border: none;
              border-radius: 0px;
          }

          window#waybar {
              background-color: rgba(0,0,0,0.2);
              border-bottom: 0px solid #ffffff;
              /* color: #FFFFFF; */
              transition-property: background-color;
              transition-duration: .5s;
          }

          /* -----------------------------------------------------
           * Workspaces
           * ----------------------------------------------------- */

          #workspaces {
              margin: 5px 1px 6px 1px;
              padding: 0px 1px;
              border-radius: 15px;
              border: 0px;
              font-weight: bold;
              font-style: normal;
              font-size: 16px;
              color: @textcolor1;
          }

          #workspaces button {
              padding: 0px 5px;
              margin: 4px 3px;
              border-radius: 15px;
              border: 0px;
              color: @textcolor3;
              transition: all 0.3s ease-in-out;
          }

          #workspaces button.active {
              color: @textcolor1;
              background: @workspacesbackground2;
              border-radius: 15px;
              min-width: 40px;
              transition: all 0.3s ease-in-out;
          }

          #workspaces button:hover {
              color: @textcolor1;
              background: @workspacesbackground2;
              border-radius: 15px;
          }

          /* -----------------------------------------------------
           * Tooltips
           * ----------------------------------------------------- */

          tooltip {
              border-radius: 10px;
              background-color: @backgroundlight;
              opacity:0.8;
              padding:20px;
              margin:0px;
          }

          tooltip label {
              color: @textcolor2;
          }

          /* -----------------------------------------------------
           * Window
           * ----------------------------------------------------- */

          #window {
              background: @backgroundlight;
              margin: 10px 15px 10px 0px;
              padding: 2px 10px 0px 10px;
              border-radius: 12px;
              color:@textcolor2;
              font-size:16px;
              font-weight:normal;
          }

          window#waybar.empty #window {
              background-color:transparent;
          }

          /* -----------------------------------------------------
           * Taskbar
           * ----------------------------------------------------- */

          #taskbar {
              background: @backgroundlight;
              margin: 6px 15px 6px 0px;
              padding:0px;
              border-radius: 15px;
              font-weight: normal;
              font-style: normal;
              border: 3px solid @backgroundlight;
          }

          #taskbar button {
              margin:0;
              border-radius: 15px;
              padding: 0px 5px 0px 5px;
          }

          /* -----------------------------------------------------
           * Modules
           * ----------------------------------------------------- */

          .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
          }

          .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
          }

          /* -----------------------------------------------------
           * Custom Quicklinks
           * ----------------------------------------------------- */

          #custom-brave,
          #custom-browser,
          #custom-keybindings,
          #custom-outlook,
          #custom-filemanager,
          #custom-teams,
          #custom-chatgpt,
          #custom-calculator,
          #custom-windowsvm,
          #custom-cliphist,
          #custom-settings,
          #custom-wallpaper,
          #custom-system,
          #custom-hyprshade,
          #custom-hypridle,
          #custom-quicklink1,
          #custom-quicklink2,
          #custom-quicklink3,
          #custom-quicklink4,
          #custom-quicklink5,
          #custom-quicklink6,
          #custom-quicklink7,
          #custom-quicklink8,
          #custom-quicklink9,
          #custom-quicklink10,
          #custom-waybarthemes {
              margin-right: 23px;
              font-size: 20px;
              font-weight: bold;
              color: @iconcolor;
          }

          #custom-hyprshade {
              margin-right:12px;
          }

          #custom-hypridle {
              margin-right:16px;
          }

          #custom-hypridle.active {
              color: @iconcolor;
          }

          #custom-hypridle.notactive {
              color: #dc2f2f;
          }

          #custom-waybarthemes,#custom-system {
               margin-right:15px;
          }

          #custom-ml4w-welcome {
              margin-right: 12px;
              background-image: url("../assets/ml4w-icon.svg");
              background-position: center;
              background-repeat: no-repeat;
              background-size: contain;
              padding-right: 24px;
          }

          /* -----------------------------------------------------
           * Idle Inhibator
           * ----------------------------------------------------- */

           #idle_inhibitor {
              margin-right: 15px;
              font-size: 22px;
              font-weight: bold;
              opacity: 0.8;
              color: @iconcolor;
          }

          #idle_inhibitor.activated {
              margin-right: 15px;
              font-size: 20px;
              font-weight: bold;
              opacity: 0.8;
              color: #dc2f2f;
          }

          /* -----------------------------------------------------
           * Custom Modules
           * ----------------------------------------------------- */

          #custom-appmenu {
              background-color: @backgrounddark;
              font-size: 16px;
              color: @textcolor1;
              border-radius: 15px;
              padding: 2px 10px 0px 10px;
              margin: 10px 15px 10px 10px;
          }

          /* -----------------------------------------------------
           * Custom Exit
           * ----------------------------------------------------- */

          #custom-exit {
              margin: 0px 20px 0px 0px;
              padding:0px;
              font-size:20px;
              color: @iconcolor;
          }

          /* -----------------------------------------------------
           * Custom Updates
           * ----------------------------------------------------- */

          #custom-updates {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              padding: 2px 10px 0px 10px;
              margin: 10px 15px 10px 0px;
          }

          #custom-updates.green {
              background-color: @backgroundlight;
          }

          #custom-updates.yellow {
              background-color: #ff9a3c;
              color: #FFFFFF;
          }

          #custom-updates.red {
              background-color: #dc2f2f;
              color: #FFFFFF;
          }

          /* -----------------------------------------------------
           * Hardware Group
           * ----------------------------------------------------- */

           #disk,#memory,#cpu,#language {
              margin:0px;
              padding:0px;
              font-size:16px;
              color:@iconcolor;
          }

          #language {
              margin-right:10px;
          }

          /* -----------------------------------------------------
           * Clock
           * ----------------------------------------------------- */

          #clock {
              background-color: @backgrounddark;
              font-size: 16px;
              color: @textcolor1;
              border-radius: 15px;
              padding: 2px 10px 0px 10px;
              margin: 10px 15px 10px 0px;
          }

          /* -----------------------------------------------------
           * Backlight
           * ----------------------------------------------------- */

           #backlight {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              padding: 2px 10px 0px 10px;
              margin: 10px 15px 10px 0px;
          }

          /* -----------------------------------------------------
           * Pulseaudio
           * ----------------------------------------------------- */

          #pulseaudio {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              padding: 2px 10px 0px 10px;
              margin: 10px 15px 10px 0px;
          }

          #pulseaudio.muted {
              background-color: @backgrounddark;
              color: @textcolor1;
          }

          /* -----------------------------------------------------
           * Network
           * ----------------------------------------------------- */

          #network {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              padding: 2px 10px 0px 10px;
              margin: 10px 15px 10px 0px;
          }

          #network.ethernet {
              background-color: @backgroundlight;
              color: @textcolor2;
          }

          #network.wifi {
              background-color: @backgroundlight;
              color: @textcolor2;
          }

          /* -----------------------------------------------------
           * Bluetooth
           * ----------------------------------------------------- */

           #bluetooth, #bluetooth.on, #bluetooth.connected {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              padding: 2px 10px 0px 10px;
              margin: 10px 15px 10px 0px;
          }

          #bluetooth.off {
              background-color: transparent;
              padding: 0px;
              margin: 0px;
          }

          /* -----------------------------------------------------
           * Battery
           * ----------------------------------------------------- */

          #battery {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              padding: 2px 15px 0px 10px;
              margin: 10px 15px 10px 0px;
          }

          #battery.charging, #battery.plugged {
              color: @textcolor2;
              background-color: @backgroundlight;
          }

          @keyframes blink {
              to {
                  background-color: @backgroundlight;
                  color: @textcolor2;
              }
          }

          #battery.critical:not(.charging) {
              background-color: #f53c3c;
              color: @textcolor3;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
          }

          /* -----------------------------------------------------
           * Tray
           * ----------------------------------------------------- */

          #tray {
              margin:0px 10px 0px 0px;
          }

          #tray > .passive {
              -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
              -gtk-icon-effect: highlight;
              background-color: #eb4d4b;
          }

          /* -----------------------------------------------------
           * Other
           * ----------------------------------------------------- */

          label:focus {
              background-color: #000000;
          }

          #backlight {
              background-color: #90b1b1;
          }

          #network {
              background-color: #2980b9;
          }

          #network.disconnected {
              background-color: #f53c3c;
          }
        '';
      };
    };
  };
}
