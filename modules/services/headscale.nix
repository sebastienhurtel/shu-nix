{
  config,
  lib,
  pkgs,
  hostname,
  self,
  ...
}:
let
  cfg = config.shu.services.headscale;
  containerInterface = "ve-headscale";
  localAddress = "192.168.254.254";
  hostAddress = "192.168.254.253";
  baseDomain = "shurtel.fr";
  fqdn = "${hostname}.${baseDomain}";
  nextDns = [
    "45.90.28.29"
    "45.90.30.29"
  ];
  caddyRecords = lib.concatMap (
    host:
    let
      caddy = host.config.shu.services.caddy;
    in
    lib.optionals caddy.enable (
      lib.concatLists (
        lib.mapAttrsToList (
          name: _:
          lib.mapAttrsToList (type: value: {
            name = "${name}.${caddy.domain}";
            inherit type value;
          }) caddy.tailnetAddresses
        ) caddy.backends
      )
    )
  ) (lib.attrValues self.nixosConfigurations);
  ports = {
    headscale = 443;
    derp = 3478;
  };
in
{
  options.shu.services.headscale = {
    enable = lib.mkEnableOption "Enable headscale as systemd container";
    # Not read anywhere: headscale terminates its own TLS and is not behind caddy.
    # Kept for consistency with the other service modules.
    ports = lib.mkOption {
      type = lib.types.attrsOf lib.types.port;
      default = ports;
      readOnly = true;
      description = "Ports used by headscale container";
    };
  };

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
          hostPort = ports.headscale;
          containerPort = ports.headscale;
        }
        {
          protocol = "udp";
          hostPort = ports.derp;
          containerPort = ports.derp;
        }
      ];

      config = {
        networking = {
          useHostResolvConf = false;
          firewall = {
            allowedTCPPorts = [ ports.headscale ];
            allowedUDPPorts = [ ports.derp ];
          };
        };
        services = {
          resolved.enable = true;
          headscale = {
            package = pkgs.unstable.headscale;
            enable = true;
            port = ports.headscale;
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
                  stun_listen_addr = "0.0.0.0:${toString ports.derp}";
                  automatically_add_embedded_derp_region = true;
                };
              };
              server_url = "https://${fqdn}:${toString ports.headscale}";
              dns = {
                magic_dns = true;
                nameservers = {
                  global = nextDns;
                  split.${baseDomain} = nextDns;
                };
                base_domain = "ts.${baseDomain}";
                extra_records = caddyRecords;
              };
              acme_url = "https://acme-v02.api.letsencrypt.org/directory";
              acme_email = "sebastienhurtel+acme@gmail.com";
              tls_letsencrypt_hostname = fqdn;
              tls_letsencrypt_challenge_type = "TLS-ALPN-01";
              policy = {
                mode = "file";
                path = pkgs.writeText "policy.hujson" (
                  builtins.toJSON {
                    autoApprovers.exitNode = [ "tag:exit" ];
                    groups = {
                      "group:nas_admin" = [
                        "shu@"
                        "thomas@"
                      ];
                    };
                    tagOwners = {
                      "tag:media" = [ "shu@" ];
                      "tag:exit" = [ "shu@" ];
                      "tag:nas" = [ "group:nas_admin" ];
                    };
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
                          "tag:media"
                        ];
                        ip = [ "*" ];
                      }
                      {
                        src = [
                          "group:nas_admin"
                        ];
                        dst = [
                          "tag:nas"
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
