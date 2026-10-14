{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.shu.services.headscale;
  hostPort = 443;
  derpPort = 3478;
  containerPort = hostPort;
  containerInterface = "ve-headscale";
  localAddress = "192.168.254.254";
  hostAddress = "192.168.254.253";
  baseDomain = "shurtel.fr";
  fqdn = "${hostname}.${baseDomain}";
in
{
  options.shu.services.headscale.enable = lib.mkEnableOption "Enable headscale as systemd container";

  config = lib.mkIf cfg.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };

    containers.headscale = {
      inherit hostAddress localAddress;
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
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
        {
          protocol = "udp";
          hostPort = derpPort;
          containerPort = derpPort;
        }
      ];

      config = {
        networking = {
          useHostResolvConf = false;
          firewall = {
            allowedTCPPorts = [
              containerPort
            ];
            allowedUDPPorts = [
              derpPort
            ];
          };
        };

        services = {
          resolved.enable = true;
          headscale = {
            package = pkgs.unstable.headscale;
            enable = true;
            port = containerPort;
            address = "0.0.0.0";
            settings = {
              derp = {
                urls = [ ];
                paths = [ ];
                auto_update_enabled = false;
                server = {
                  enabled = true;
                  region_id = 999;
                  region_code = "shu";
                  region_name = "shurtel";
                  stun_listen_addr = "0.0.0.0:${toString derpPort}";
                  automatically_add_embedded_derp_region = true;
                };
              };
              server_url = "https://${fqdn}:${toString containerPort}";
              dns = {
                magic_dns = true;
                nameservers.global = [
                  "45.90.28.29"
                  "45.90.30.29"
                ];
                base_domain = "ts.${baseDomain}";
              };
              acme_url = "https://acme-v02.api.letsencrypt.org/directory";
              acme_email = "sebastienhurtel+acme@gmail.com";
              tls_letsencrypt_hostname = fqdn;
              tls_letsencrypt_challenge_type = "TLS-ALPN-01";
              policy = {
                mode = "file";
                path = pkgs.writeText "policy.hujson" (
                  builtins.toJSON {
                    tagOwners = {
                      "tag:media" = [ "shu@" ];
                      "tag:exit" = [ "shu@" ];
                    };
                    autoApprovers.exitNode = [ "tag:exit" ];
                    grants = [
                      {
                        src = [ "tag:media" ];
                        dst = [
                          "autogroup:internet"
                        ];
                        ip = [ "*" ];
                      }
                      {
                        src = [ "shu@" ];
                        dst = [
                          "autogroup:internet"
                          "autogroup:self"
                        ];
                        ip = [ "*" ];
                      }
                    ];
                  }
                );
              };
            };
          };
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
