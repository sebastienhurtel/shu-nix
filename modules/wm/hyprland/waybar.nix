{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.Waybar;
  style = import ./style.nix { inherit config username lib; };
in
{
  options.shu.Waybar.enable = lib.mkEnableOption "Enable Shu Waybar";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.waybar = {
        enable = true;
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
              "window-rewrite" = {
                "title<(.*)YouTube(.*)>" = "";
                "class<firefox>" = "";
                "class<firefox> title<.*github.*>" = "";
                "class<.*chrome.*>" = "󰊯";
                "class<Alacritty>" = "";
                "code" = "󰨞";
                "class<Emacs>" = "";
                "class<(.*)Nautilus>" = "";
              };
              "all-output" = true;
              "format-icons" = {
                "default"= "";
                "empty" = "";
              };
              "persistent-workspaces" = {
                "*" = [ 1 2 3 4 ];
              };
            };

            modules-center = [
              "clock"
            ];

            clock = {
              "format" = "{:%H:%M %A}";
              "on-click" = "ags -t calendar";
              "tooltip" = false;
            };

            modules-right = [
              "tray"
              "backlight"
              "bluetooth"
              "network"
              "pulseaudio"
              "battery"
            ];

            tray = {
              "icon-size" = 21;
              "spacing" = 10;
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

            network = {
              "format" = "{ifname}";
              "format-wifi" = "{icon}";
              "format-icons" = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
              "format-ethernet" = "  {ipaddr}";
              "format-disconnected" = "Not connected";
              "tooltip-format" = " {ifname} via {gwaddri}";
              "tooltip-format-wifi" = "󰤨  ({signalStrength}%)";
              "tooltip-format-ethernet" = " {ifname}";
              "tooltip-format-disconnected" = "Disconnected";
              "max-length" = 50;
              "on-click" = "nm-connection-editor";
            };

            pulseaudio = {
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
                  "󰝟"
                  "󰕿"
                  "󰖀 "
                  "󰕾 "
                ];
              };
              "on-click" = "pavucontrol";
            };

            bluetooth = {
              "format-disabled" = "";
              "format-off" = "";
              "interval" = 30;
              "on-click" = "blueman-manager";
              "format-no-controller" = "";
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
