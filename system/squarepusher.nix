{ pkgs, username, ... }:

{
  environment = with pkgs; {
    systemPackages = [
      linuxKernel.packages.linux_zen.cpupower
      powertop
      python3
      virt-manager
    ];
  };

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
  };
  hardware.steam-hardware.enable = false;

  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        RADEON_POWER_PROFILE_ON_AC = "default";
        RADEON_POWER_PROFILE_ON_BAT = "low";

        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

        RUNTIME_PM_ON_AC = "auto";

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 50; # bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # above it stops charging

      };
    };
    flatpak.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
    };
  };
  hardware.pulseaudio.enable = false;

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        ovmf.enable = true;
      };
    };
  };

  users.users.${username}.extraGroups = [
    "docker"
    "libvirtd"
  ];

  networking.nftables = {
    ruleset = ''
      table inet nixos-fw {
        chain input-allow {
          ip saddr 192.168.1.0/24 ip daddr 192.168.1.0/24 accept comment "LAN"
        }
      }
    '';
  };
}
