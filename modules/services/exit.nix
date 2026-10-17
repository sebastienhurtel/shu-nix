{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.shu.services.exitNode;
  containerInterface = "ve-exitNode";
  containerAddress = "192.168.254.251";
  hostAddress = "192.168.254.252";
in
{
  options.shu.services.exitNode.enable = lib.mkEnableOption "Enable exitNode as systemd container";

  config = lib.mkIf cfg.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };
    age.secrets.exit.file = "${self}/secrets/exit.age";
    systemd.tmpfiles.rules = [ "d /var/lib/tailscale-exit 0700 root root -" ];
    containers.exitNode = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      enableTun = true;
      bindMounts = {
        "${config.age.secrets.exit.path}".isReadOnly = true;
        "/var/lib/tailscale" = {
          hostPath = "/var/lib/tailscale-exit";
          isReadOnly = false;
        };
      };
      config = {
        systemd.services = {
          tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
          tc-gro = {
            description = "Enable UDP GRO forwarding for tailscale";
            wantedBy = [ "multi-user.target" ];
            before = [ "tailscaled.service" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.ethtool}/bin/ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off";
            };
          };
        };
        networking = {
          useHostResolvConf = false;
        };
        environment = {
          systemPackages = with pkgs; [
            ethtool
          ];
        };
        services = {
          resolved.enable = true;
          tailscale = {
            enable = true;
            useRoutingFeatures = "server";
            authKeyFile = config.age.secrets.exit.path;
            extraDaemonFlags = [ "--no-logs-no-support" ];
            extraUpFlags = [
              "--login-server=https://aphex.shurtel.fr"
              "--advertise-exit-node"
            ];
          };
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
