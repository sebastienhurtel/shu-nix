{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.services.immich;
  containerAddress = "192.168.254.254";
  hostAddress = "192.168.254.253";
  containerInterface = "ve-immich";
  ports = {
    immich = 2283;
  };
in
{
  options.shu.services.immich.enable = lib.mkEnableOption "Enable immich as systemd container";

  config = lib.mkIf cfg.enable {
    shu.services.caddy = {
      enable = true;
      backends.immich = {
        host = containerAddress;
        port = ports.immich;
      };
    };
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };
    containers.immich = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      bindMounts = {
        "/etc/localtime" = {
          hostPath = "/etc/localtime";
          isReadOnly = true;
        };
        "/photos" = {
          hostPath = "/data/photos/immich";
          isReadOnly = false;
        };
        "/usr/src/app/upload" = {
          hostPath = "/data/photos/immich/upload";
          isReadOnly = false;
        };
        "/var/lib/postgresql" = {
          hostPath = "/var/lib/postgresql";
          isReadOnly = false;
        };
        "/dev/dri" = {
          hostPath = "/dev/dri";
          isReadOnly = false;
        };
      };
      allowedDevices = [
        {
          node = "/dev/dri/renderD128";
          modifier = "rw";
        }
      ];
      forwardPorts = lib.mapAttrsToList (_: port: {
        protocol = "tcp";
        hostPort = port;
        containerPort = port;
      }) ports;
      config = {
        networking.useHostResolvConf = false;
        services = {
          resolved.enable = true;
          postgresql.enable = true;
          immich = {
            enable = true;
            package = pkgs.unstable.immich;
            openFirewall = true;
            port = ports.immich;
            mediaLocation = "/photos";
            host = "0.0.0.0";
            environment = {
              IMMICH_INSTANCE_URL = "http://192.168.1.250:2283/api";
            };
            accelerationDevices = [ "/dev/dri/renderD128" ];
          };
        };
        users.users.immich = {
          name = "immich";
          createHome = true;
          home = "/photos";
          isSystemUser = true;
          shell = "/usr/sbin/nologin";
          extraGroups = [
            "video"
            "render"
          ];
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
