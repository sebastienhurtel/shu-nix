{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.shu.Hyprlock;
in
{
  options.shu.Hyprlock.enable = lib.mkEnableOption "Enable Shu Hyprlock";
  config = lib.mkIf cfg.enable {
    security.pam.services.hyprlock = { };
    home-manager.users.${username} = {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            ignore_empty_input = true;
            enable_fingerprint = true;
            fingerprint_ready_message = "fingerprint reader is ready";
            fingerprint_present_message = "reading... ";
            pam_module = "/etc/pam.d/login";
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
              color = "rgb(010204)";
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
              color = "rgb(010204)";
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
              color = "rgb(010204)";
              font_size = 18;
              font_family = "JetBrainsMono Nerd Font 10";
              position = "0, -40";
              halign = "center";
              valign = "center";
            }
          ];

          input-field = {
            monitor = "";
            size = "200, 50";
            outline_thickness = 2;
            dots_size = 0.26;
            dots_spacing = 0.64;
            dots_center = true;
            dots_rounding = -1;
            fade_on_empty = true;
            fade_timeout = 1500;
            font_family = "JetBrainsMono Nerd Font Bold";
            placeholder_text = "<i>Enter Password...</i>";
            hide_input = false;
            rounding = 15;
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            fail_timeout = 2000;
            fail_transition = 200;
          };
        };
      };
    };
  };
}
