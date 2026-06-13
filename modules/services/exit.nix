{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.services.exitNode;
  containerInterface = "ve-exitNode";
  containerAddress = "192.168.254.251";
  hostAddress = "192.168.254.252";
in
{
  options.shu.services.exitNode = {
    enable = lib.mkEnableOption "Enable exitNode as systemd container";
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
    containers.exitNode = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      enableTun = true;

      config = {
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
          tailscale.enable = true;
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
