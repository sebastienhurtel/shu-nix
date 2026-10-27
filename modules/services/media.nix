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
  bypassExitNode = [
    lanSubnet
    hostAddress
  ];
  ports = {
    transmission = 9091;
    radarr = 7878;
    sonarr = 8989;
    prowlarr = 9696;
  };
  fqdn = name: "${name}.${config.shu.services.caddy.domain}";
  allowedHosts = lib.concatStringsSep "," (
    [
      "deftones"
      "192.168.1.250"
    ]
    ++ map fqdn (lib.attrNames ports)
  );
in
{
  options.shu.services.media.enable = lib.mkEnableOption "Enable media as systemd container";

  imports = [ agenix.nixosModules.default ];
  config = lib.mkIf cfg.enable {
    shu.services.caddy = {
      enable = true;
      backends = lib.mapAttrs (_: port: {
        inherit port;
        host = containerAddress;
      }) ports;
    };

    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };

    age.secrets.media.file = "${self}/secrets/media.age";

    systemd = {
      tmpfiles.rules = [
        "d /var/lib/tailscale-media 0700 root root -"
        "d /data/downloads 2775 ${toString config.ids.uids.transmission} ${toString config.ids.gids.users} -"
      ];
      services."container@media".serviceConfig.AllowedCPUs = "12-15";
    };

    containers.media = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      bindMounts = {
        "${config.age.secrets.media.path}".isReadOnly = true;
        "/var/lib/tailscale" = {
          hostPath = "/var/lib/tailscale-media";
          isReadOnly = false;
        };
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
        networking = {
          useHostResolvConf = false;
          hosts."45.90.162.252" = [ "aphex.shurtel.fr" ];
          nftables = {
            enable = true;
            tables.isolation = {
              family = "inet";
              content = ''
                chain output {
                  type filter hook output priority filter; policy drop;
                  oifname { "lo", "tailscale0" } accept
                  meta mark & 0x00ff0000 == 0x00080000 accept
                  oifname "eth0" ct direction reply accept
                }
              '';
            };
          };
        };
        systemd.services = {
          # To be removed?
          tailscaled-autoconnect.serviceConfig = {
            Type = lib.mkForce "exec";
            NotifyAccess = "main";
          };
          transmission.serviceConfig.RootDirectory = lib.mkForce "";
          lan-route = {
            description = "Route LAN outside of tailscale exit node";
            wantedBy = [ "multi-user.target" ];
            before = [ "tailscaled.service" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = map (
                to: "${pkgs.iproute2}/bin/ip rule add to ${to} lookup main priority 5200"
              ) bypassExitNode;
              ExecStop = map (
                to: "${pkgs.iproute2}/bin/ip rule del to ${to} lookup main priority 5200"
              ) bypassExitNode;
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
            useRoutingFeatures = "client";
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
              umask = "002";
              rpc-bind-address = "0.0.0.0";
              rpc-whitelist = "127.0.0.1,192.168.1.*,${hostAddress}";
              rpc-host-whitelist = "${config.networking.hostName},${fqdn "transmission"}";
            };
          };
          radarr = {
            enable = true;
            openFirewall = true;
            group = "users";
            settings.server = {
              port = ports.radarr;
              allowedhosts = allowedHosts;
            };
          };
          sonarr = {
            enable = true;
            openFirewall = true;
            group = "users";
            settings.server = {
              port = ports.sonarr;
              allowedhosts = allowedHosts;
            };
          };
          prowlarr = {
            enable = true;
            openFirewall = true;
            settings.server = {
              port = ports.prowlarr;
              allowedhosts = allowedHosts;
            };
          };
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
