{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.services.media;
  containerInterface = "ve-media";
  containerAddress = "192.168.254.251";
  hostAddress = "192.168.254.250";
in
{
  options.shu.services.media = {
    enable = lib.mkEnableOption "Enable media as systemd container";
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
    containers.media = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      enableTun = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      config ={
        networking.useHostResolvConf = true;
        services = {
          tailscale.enable = true;
          transmission.enable = true;
          transmission.package = pkgs.transmission_4;
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
