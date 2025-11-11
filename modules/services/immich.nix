{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.shu.immich;
  containerAddress = "192.168.254.254";
  hostAddress = "192.168.254.253";
  containerInterface = "ve-immich";
  containerPort = hostPort;
  hostPort = 2283;
in
{
  options.services.shu.immich.enable = lib.mkEnableOption "Enable immich as systemd container";

  config = lib.mkIf cfg.enable {
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
      bindMounts."/etc/localtime" = {
        hostPath = "/etc/localtime";
        isReadOnly = true;
      };
      bindMounts."/photos" = {
        hostPath = "/data/photos/immich";
        isReadOnly = false;
      };
      bindMounts."/usr/src/app/upload" = {
        hostPath = "/data/photos/immich/upload";
        isReadOnly = false;
      };
      bindMounts."/var/lib/postgresql" = {
        hostPath = "/var/lib/postgresql";
        isReadOnly = false;
      };
      forwardPorts = [
        {
          protocol = "tcp";
          hostPort = hostPort;
          containerPort = containerPort;
        }
      ];
      config = {
        networking = {
          useHostResolvConf = false;
          firewall.allowedTCPPorts = [
            containerPort
          ];
        };
        services = {
          resolved.enable = true;
          postgresql.enable = true;
          immich = {
            enable = true;
            package = pkgs.unstable.immich;
            openFirewall = true;
            port = hostPort;
            mediaLocation = "/photos";
            host = "0.0.0.0";
            environment = {
              IMMICH_INSTANCE_URL = "http://192.168.1.250:2283/api";
            };
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
