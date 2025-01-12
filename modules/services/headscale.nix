{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.services.shu.headscale;
  containerPort = hostPort;
  hostPort = 443;
  containerInterface = "ve-headscale";
  containerAddress = "192.168.254.254";
  hostAddress = "192.168.254.253";
  baseDomain = "shurtel.fr";
  fqdn = "${hostname}.${baseDomain}";
in
{
  options.services.shu.headscale = {
    enable = lib.mkEnableOption "Enable headscale as systemd container";
    interface = lib.mkOption {
      type = lib.types.str;
      default = "eth0";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };
    containers.headscale = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      bindMounts."/var/lib/headscale" = {
        hostPath = "/var/lib/headscale";
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
          headscale = {
            enable = true;
            port = containerPort;
            address = "0.0.0.0";
            settings = {
              server_url = "https://${fqdn}:${builtins.toString containerPort}";
              dns = {
                magic_dns = false;
                #                base_domain = "${baseDomain}";
              };
              derp.server.enabled = false;
              acme_url = "https://acme-v02.api.letsencrypt.org/directory";
              acme_email = "sebastienhurtel+acme@gmail.com";
              tls_letsencrypt_hostname = "aphex.shurtel.fr";
              tls_letsencrypt_challenge_type = "TLS-ALPN-01";
            };
          };
        };
        users.users.headscale = {
          name = "headscale";
          createHome = true;
          home = "/var/lib/headscale";
          isSystemUser = true;
          shell = "/usr/sbin/nologin";
        };
        system.stateVersion = config.system.stateVersion;
        systemd.services = {
          console-getty.enable = false;
          headscale.environment.SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        };
      };
    };
  };
}
