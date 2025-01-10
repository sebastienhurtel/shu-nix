{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.swaync;
in
{
  options.shu.home.swaync.enable = lib.mkEnableOption "Enable shu home swaync";
  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = {
        control-center-height = 1000;
        control-center-layer = "top";
        cssPriority = "application";
        fit-to-screen = false;
        hide-on-action = true;
        hide-on-clear = false;
        image-visibility = "when-available";
        layer = "overlay";
        layer-shell = true;
        notification-2fa-action = true;
        positionX = "center";
        positionY = "top";
        script-fail-notify = true;
        timeout = 20;
        transition-time = 200;
        widgets = [
          "title"
          "dnd"
          "volume"
          "backlight"
          "notifications"
          "mpris"
          "buttons-grid"
        ];
        widget-config = {
          title = {
            text = "Notification Center";
            clear-all-button = true;
            button-text = "󰆴 Clear All";
          };
          dnd = {
            text = "Do Not Disturb";
          };
          label = {
            max-lines = 1;
            text = "Notification Center";
          };
          mpris = {
            image-size = 96;
            image-radius = 7;
          };
          volume = {
            label = "󰕾";
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
                label = "󰌾";
                command = "hyprlock";
              }
              {
                label = "󰍃";
                command = "uwsm stop";
              }
              {
                label = "󰏥";
                command = "systemctl suspend";
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
            ];
          };
        };
      };
    };
  };
}
