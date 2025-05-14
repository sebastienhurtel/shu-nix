{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.shu.swaync;
  # style = import ./style.nix { inherit config username lib; };
in
{
  options.shu.swaync.enable = lib.mkEnableOption "Enable shu home swaync";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      services.swaync = {
        enable = true;
        # style = style.swaync;
        settings = {
          control-center-width = 600;
          control-center-layer = "top";
          control-center-margin-top = 0;
          control-center-margin-bottom = 0;
          control-center-margin-right = 0;
          control-center-margin-left = 0;
          cssPriority = "application";
          hide-on-action = true;
          hide-on-clear = false;
          image-visibility = "when-available";
          layer = "overlay";
          layer-shell = true;
          notification-2fa-action = true;
          notification-inline-replies = true;
          notification-body-image-height = 100;
          notification-body-image-width = 200;
          positionX = "right";
          positionY = "top";
          script-fail-notify = true;
          timeout = 20;
          transition-time = 200;
          widgets = [
            "title"
            "dnd"
            "buttons-grid"
            "volume"
            "backlight"
            "notifications"
            "mpris"
          ];
          widget-config = {
            title = {
              text = "Notifications";
              clear-all-button = true;
              button-text = "󰆴 Clear All";
            };
            dnd = {
              text = "Do Not Disturb";
            };
            label = {
              max-lines = 1;
              text = "Notifications";
            };
            mpris = {
              image-size = 96;
              image-radius = 7;
            };
            volume = {
              label = "󰕾";
              show-per-app = true;
            };
            backlight = {
              label = "󰃟";
              device = "amdgpu_bl1";
            };
            buttons-grid = {
              actions = [
                {
                  label = "󰐥";
                  command = "systemctl poweroff";
                }
                {
                  label = "󰜉";
                  command = "systemctl reboot";
                }
                {
                  label = "󰏥";
                  command = "systemctl suspend";
                }
                {
                  label = "󰌾";
                  command = "hyprlock";
                }
                {
                  label = "󰍃";
                  command = "uwsm stop";
                }
                {
                  label = "󰕾";
                  command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                }
                {
                  label = "󰍬";
                  command = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                }
                {
                  label = "󰂯";
                  command = "overskride";
                }
                {
                  label = " ";
                  type = "toggle";
                  active = true;
                  command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'";
                  update_command = "sh -c '[[ $(nmcli radio wifi) == \"enabled\" ]] && echo true || echo false'";
                }
              ];
            };
          };
        };
      };
    };
  };
}
