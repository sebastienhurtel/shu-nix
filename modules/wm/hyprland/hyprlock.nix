{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.hyprlock;
in
{
  options.shu.hyprlock.enable = lib.mkEnableOption "Enable Shu Hyprlock";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            ignore_empty_input = true;
            hide_cursor = true;
          };

          auth = {
            fingerprint = {
              enabled = true;
              ready_message = "fingerprint reader is ready";
              present_message = "reading... ";
            };
            pam = {
              module = "/etc/pam.d/login";
            };
          };

          background = {
            blur_size = 4;
            blur_passes = 3;
            noise = 0.0117;
            contrast = 1.3000;
            brightness = 0.8000;
            vibrancy = 0.2100;
            vibrancy_darkness = 0.0;
          };

          label = [
            # Hours
            {
              monitor = "";
              text = ''cmd[update:1000] echo "<b><big> $(date +"%H") </big></b>"'';
              font_size = 112;
              font_family = "Geist Mono 10";
              shadow_passes = 3;
              shadow_size = 4;
              position = "0, 220";
              halign = "center";
              valign = "center";
            }

            # Minutes
            {
              monitor = "";
              text = ''cmd[update:1000] echo "<b><big> $(date +"%M") </big></b>"'';
              font_size = 112;
              font_family = "Geist Mono 10";
              shadow_passes = 3;
              shadow_size = 4;
              position = "0, 80";
              halign = "center";
              valign = "center";
            }

            # Today
            {
              monitor = "";
              text = ''cmd[update:18000000] echo "<b><big> "$(date +'%A')" </big></b>"'';
              font_size = 22;
              font_family = "JetBrainsMono Nerd Font 10";
              position = "0, 0";
              halign = "center";
              valign = "center";
            }

            # Week
            {
              monitor = "";
              text = ''cmd[update:18000000] echo "<b> "$(date +'%d %b')" </b>"'';
              font_size = 18;
              font_family = "JetBrainsMono Nerd Font 10";
              position = "0, -40";
              halign = "center";
              valign = "center";
            }
          ];

          input-field = {
            monitor = "";
            size = "200, 40";
            outline_thickness = 2;
            dots_size = 0.33;
            dots_spacing = 0.15;
            dots_center = true;
            fade_on_empty = true;
            fade_timeout = 4000;
            placeholder_text = "<i>Input Password...</i>";
            hide_input = false;
            rounding = "-1";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            position = "0, 80";
            halign = "center";
            valign = "bottom";
          };
        };
      };
    };
  };
}
