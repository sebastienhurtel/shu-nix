{ pkgs, username, ... }:

{
  environment = with pkgs; {
    systemPackages = [
      linuxKernel.packages.linux_zen.cpupower
      mesa
      mpv
      mtr
      powertop
      python3
    ];
  };

  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        RADEON_POWER_PROFILE_ON_AC = "default";
        RADEON_POWER_PROFILE_ON_BAT = "low";

        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 50; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 65; # 60 and above it stops charging

      };
    };
    flatpak.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
  hardware.pulseaudio.enable = false;

  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
}
