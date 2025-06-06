{
  username,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.waybar;
  style = import ./style.nix { inherit config username lib; };
in
{
  options.shu.waybar.enable = lib.mkEnableOption "Enable Shu Waybar";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      systemd.user.services.waybar = {
        Unit = {
          PartOf = lib.mkForce [ "graphical-session.target" ];
          After = lib.mkForce [ "graphical-session.target" ];
        };
        Service = {
          Slice = [ "app-graphical.slice" ];
        };
      };
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            margin-bottom = 0;
            margin-left = 0;
            margin-right = 0;
            spacing = 0;
            modules-left = [
              "custom/appmenu"
              "hyprland/workspaces"
            ];

            "custom/appmenu" = {
              "format" = "";
              "on-click" = "rofi -show drun -replace";
              "tooltip" = false;
            };

            "hyprland/workspaces" = {
              "active-only" = false;
              "all-outputs" = true;
              "format" = "{icon}{windows}";
              "format-window-separator" = " ";
              "window-rewrite-default" = "";
              "workspace-taskbar" = {
                  "enable" = true;
                  "update-active-window" = true;
                  "format" = "{icon}";
                  "icon-size" = 18;
              };
              "window-rewrite" = {
                "title<(.*)YouTube(.*)>" = "";
                "title<(.*)Twitch(.*)>" = "";
                "title<.*github.*>" = "";
                "title<(.*)Gmail(.*)>" = "󰊫";
                "code" = "󰨞";
                "class<firefox>" = "";
                "class<Google-chrome>" = "󰊯";
                "class<(.*)[aA]lacritty(.*)>" = "";
                "class<Emacs>" = "";
                "class<(.*)Nautilus>" = "";
                "class<steam>" = "󰓓";
                "class<vlc>" = "󰕼";
              };
              "all-output" = true;
              "format-icons" = {
                "default" = "";
                "empty" = "";
              };
              "persistent-workspaces" = {
                "*" = [
                  1
                  2
                  3
                  4
                ];
              };
              "on-scroll-up" = "hyprctl dispatch workspace m-1";
              "on-scroll-down" = "hyprctl dispatch workspace m+1";
            };

            modules-center = [
              "clock"
              "custom/notification"
            ];

            "custom/notification" = {
              "tooltip" = false;
              "format" = "{icon}";
              "format-icons" = {
                "notification" = "<span foreground='red'><sup></sup></span>";
                "none" = "";
                "dnd-notification" = "<span foreground='red'><sup></sup></span>";
                "dnd-none" = "";
                "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
                "inhibited-none" = "";
                "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
                "dnd-inhibited-none" = "";
              };
              "return-type" = "json";
              "exec-if" = "which swaync-client";
              "exec" = "swaync-client -swb";
              "on-click" = "swaync-client -t -sw";
              "on-click-right" = "swaync-client -d -sw";
              "escape" = true;
            };

            clock = {
              "format" = "{:%A %d %B  󰃰  %H:%M}";
              "on-click" = "ags -t calendar";
              "tooltip" = false;
              "tooltip-format" = "<span size='20pt'>{calendar}</span>";
              "calendar" = {
                "mode" = "month";
                "mode-mon-col" = 4;
                "weeks-pos" = "left";
                "on-scroll" = 1;
                "on-click-right" = "mode";
                "format" = {
                  "months" = "<span color='#ffead3'><b>{}</b></span>";
                  "days" = "<span color='#ecc6d9'><b>{}</b></span>";
                  "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
                  "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                  "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
                };
              };
            };

            modules-right = [
              "gamemode"
              "tray"
              "bluetooth"
              "backlight"
              "pulseaudio"
              "battery"
            ];

            gamemode = {
                "format" = "{glyph}";
                "format-alt" = "{glyph} {count}";
                "glyph" = "";
                "hide-not-running" = true;
                "use-icon" = true;
                "icon-name" = "input-gaming-symbolic";
                "icon-spacing" = 4;
                "icon-size" = 21;
                "tooltip" = true;
                "tooltip-format" = "Games running: {count}";
            };

            tray = {
              "icon-size" = 21;
              "spacing" = 12;
            };

            backlight = {
              "format" = "{icon}";
              "format-icons" = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
            };

            pulseaudio = {
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
                  "󰕿 "
                  "󰕿 "
                  "󰖀 "
                  "󰖀 "
                  "󰕾 "
                  "󰕾 "
                ];
              };
              "on-click" = "${pkgs.pwvucontrol}/bin/pwvucontrol";
            };

            bluetooth = {
              "format-disabled" = "";
              "format-off" = "";
              "interval" = 30;
              "on-click" = "${pkgs.overskride}/bin/overskride";
              "format-no-controller" = "";
              "format-connected-battery" = "{device_alias} {device_battery_percentage}% ";
            };

            battery = {
              "states" = {
                "good" = 95;
                "warning" = 40;
                "critical" = 20;
              };
              "format" = "{capacity}% {icon}";
              "format-charging" = "{capacity}% 󰂄";
              "format-plugged" = "{capacity}% ";
              "format-alt" = "{icon} {time}";
              # "format-good" = "";
              # "format-full" = "";
              "format-icons" = [
                "󱉞"
                "󰂃󰁻"
                "󰂃󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };
          };
        };
        style = style.waybar;
      };
    };
  };
}
