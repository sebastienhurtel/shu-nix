{
  pkgs,
  username,
  lib,
  config,
  ...
}:
let
  cfg = config.shu.hosts.squarepusher.system;
in
{
  options.shu.hosts.squarepusher.system.enable = lib.mkEnableOption "squarepusher system configuration";
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        bridge-utils
        linuxKernel.packages.linux_zen.cpupower
        openssl
        passh
        powertop
        python3
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
          extraArgs = "--keep 1 --keep-since 1d";
        };
      };
      wireshark.enable = true;
    };

    hardware.steam-hardware.enable = true;

    networking.networkmanager = {
      plugins = [ pkgs.networkmanager-strongswan ];
    };

    # required for Flatpak
    xdg.portal.enable = true;

    shu.services.nfsClient.enable = true;

    services = {
      upower.enable = true;
      tlp = {
        enable = true;
        package = pkgs.unstable.tlp;
        pd = {
          enable = true;
          package = pkgs.unstable.tlp-pd;
        };
        settings = {
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          RUNTIME_PM_ON_AC = "auto";

          START_CHARGE_THRESH_BAT0 = 50;
          STOP_CHARGE_THRESH_BAT0 = 80;

          AMDGPU_ABM_LEVEL_ON_BAT = 0;
        };
      };
      flatpak.enable = true;
      printing = {
        enable = true;
        browsed.enable = false;
        openFirewall = true;
        drivers = with pkgs; [
          dcp9020cdw-cupswrapper
          dcp9020cdwlpr
          cups-filters
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
              "tcp://100.64.0.3:22000"
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
  };
}
