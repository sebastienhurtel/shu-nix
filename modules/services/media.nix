{
  agenix,
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.shu.services.media;
  containerInterface = "ve-media";
  containerAddress = "192.168.254.250";
  hostAddress = "192.168.254.249";
  lanSubnet = "192.168.1.0/24";
  ports = {
    transmission = 9091;
    radarr = 7878;
    sonarr = 8989;
    prowlarr = 9696;
  };
in
{
  options.shu.services.media = {
    enable = lib.mkEnableOption "Enable media as systemd container";
    interface = lib.mkOption {
      type = lib.types.str;
      default = "eth0";
    };
  };

  imports = [ agenix.nixosModules.default ];
  config = lib.mkIf cfg.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };
    age.secrets.media.file = "${self}/secrets/media.age";
    systemd.tmpfiles.rules = [
      "d /data/downloads 2775 ${toString config.ids.uids.transmission} ${toString config.ids.gids.users} -"
    ];
    containers.media = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      bindMounts = {
        "${config.age.secrets.media.path}".isReadOnly = true;
        "/data/downloads" = {
          hostPath = "/data/downloads";
          isReadOnly = false;
        };
        "/data/movies" = {
          hostPath = "/data/movies";
          isReadOnly = false;
        };
        "/data/series" = {
          hostPath = "/data/series";
          isReadOnly = false;
        };
      };
      forwardPorts = lib.mapAttrsToList (_: port: {
        protocol = "tcp";
        hostPort = port;
        containerPort = port;
      }) ports;
      config = {
        networking.useHostResolvConf = false;
        systemd.services = {
          tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
          lan-route = {
            description = "Route LAN outside of tailscale exit node";
            wantedBy = [ "multi-user.target" ];
            before = [ "tailscaled.service" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.iproute2}/bin/ip rule add to ${lanSubnet} lookup main priority 5200";
              ExecStop = "${pkgs.iproute2}/bin/ip rule del to ${lanSubnet} lookup main priority 5200";
            };
          };
        };
        services = {
          resolved.enable = true;
          tailscale = {
            enable = true;
            authKeyFile = config.age.secrets.media.path;
            extraDaemonFlags = [ "--no-logs-no-support" ];
            extraUpFlags = [
              "--login-server=https://aphex.shurtel.fr"
              "--exit-node=100.64.0.7"
              "--exit-node-allow-lan-access"
            ];
          };
          transmission = {
            enable = true;
            package = pkgs.transmission_4;
            group = "users";
            openRPCPort = true;
            settings = {
              rpc-port = ports.transmission;
              download-dir = "/data/downloads/complete";
              incomplete-dir = "/data/downloads/incomplete";
              incomplete-dir-enabled = true;
              umask = "002";
              rpc-bind-address = "0.0.0.0";
              rpc-whitelist = "127.0.0.1,192.168.1.*";
              rpc-host-whitelist = config.networking.hostName;
            };
          };
          radarr = {
            enable = true;
            openFirewall = true;
            group = "users";
            settings.server.port = ports.radarr;
          };
          sonarr = {
            enable = true;
            openFirewall = true;
            group = "users";
            settings.server.port = ports.sonarr;
          };
          prowlarr = {
            enable = true;
            openFirewall = true;
            settings.server.port = ports.prowlarr;
          };
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
