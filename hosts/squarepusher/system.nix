{
  pkgs,
  username,
  lib,
  ...
}:

{
  environment = {
    systemPackages = with pkgs; [
      bridge-utils
      linuxKernel.packages.linux_zen.cpupower
      openssl
      passh
      powertop
      python313
      simple-scan
      virt-manager
    ];
  };
  nix.gc.automatic = lib.mkForce false;
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    nh = {
      enable = true;
      flake = "/home/${username}/.dotfiles";
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
  hardware.steam-hardware.enable = true;

  networking.networkmanager = {
    plugins = [ pkgs.networkmanager_strongswan ];
  };

  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";

        RUNTIME_PM_ON_AC = "auto";

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 50; # bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # above it stops charging
      };
    };
    flatpak.enable = true;
    printing = {
      enable = true;
      browsed.enable = true;
      openFirewall = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        dcp9020cdw-cupswrapper
      ];
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    shu.nfsClient.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    pulseaudio.enable = false;
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "${username}";
      dataDir = "/home/${username}";
      systemService = true;
      settings = {
        devices.deftones = {
          addresses = [
            "tcp://100.64.0.4:22000"
          ];
          id = "VHHCLVW-W3VTEAY-X4OXNAF-EEZJ6C2-O57ZPEC-2NU73WV-2WSERQV-BZBRJAY";
        };
        folders = {
          Documents = {
            type = "sendonly";
            path = "/home/${username}/Documents";
            devices = [ "deftones" ];
          };
        };
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      daemon.settings = {
        features = {
          buildkit = true;
        };
        default-address-pools = [
          {
            base = "128.66.0.0/17";
            size = 24;
          }
        ];
        bip = "192.0.0.1/24";
      };
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
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
  boot.plymouth.enable = true;
}
