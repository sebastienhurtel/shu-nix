{
  agenix,
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.shu.services.caddy;
  containerInterface = "ve-caddy";
  containerAddress = "192.168.254.248";
  hostAddress = "192.168.254.247";
  ports = [
    80
    443
  ];
  upstream =
    b: if lib.hasInfix ":" b.host then "[${b.host}]:${toString b.port}" else "${b.host}:${toString b.port}";
  caddyPackage = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/gandi@v1.2.1" ];
    hash = "sha256-M9LUWmuujoJsx56V/mfj+LnLy7sSrtNJA1AnS8nK1R4=";
  };
in
{
  options.shu.services.caddy = {
    enable = lib.mkEnableOption "Enable caddy as systemd container";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "shurtel.fr";
      description = "Domain under which backends are published as <name>.<domain>.";
    };
    tailnetAddresses = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        A = "100.64.0.3";
        AAAA = "fd7a:115c:a1e0::3";
      };
      description = "This host's tailnet addresses by DNS record type, published by headscale for each backend.";
    };
    backends = lib.mkOption {
      default = { };
      description = "Backends to reverse proxy, keyed by subdomain. Services register their own entries.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              description = "Address of the backend, as reachable from the caddy container.";
            };
            port = lib.mkOption {
              type = lib.types.port;
              description = "Port of the backend.";
            };
          };
        }
      );
    };
  };

  imports = [ agenix.nixosModules.default ];
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.tailnetAddresses != { };
        message = "shu.services.caddy.tailnetAddresses must be set on hosts running caddy";
      }
    ];
    age.secrets.caddyDns.file = "${self}/secrets/caddyDns.age";
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };
    containers.caddy = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      bindMounts."${config.age.secrets.caddyDns.path}".isReadOnly = true;
      forwardPorts = map (port: {
        protocol = "tcp";
        hostPort = port;
        containerPort = port;
      }) ports;
      config = {
        networking = {
          useHostResolvConf = false;
          hosts."45.90.162.252" = [ "aphex.shurtel.fr" ];
          firewall.allowedTCPPorts = ports;
        };
        services = {
          resolved.enable = true;
          caddy = {
            enable = true;
            package = caddyPackage;
            environmentFile = config.age.secrets.caddyDns.path;
            globalConfig = ''
              acme_dns gandi {env.GANDI_BEARER_TOKEN}
            '';
            virtualHosts."*.${cfg.domain}".extraConfig = ''
              ${lib.concatStrings (
                lib.mapAttrsToList (name: b: ''
                  @${name} host ${name}.${cfg.domain}
                  handle @${name} {
                    reverse_proxy ${upstream b}
                  }
                '') cfg.backends
              )}
              handle {
                abort
              }
            '';
          };
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
