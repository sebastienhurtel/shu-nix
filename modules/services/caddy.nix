{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.services.caddy;
  containerInterface = "ve-caddy";
  containerAddress = "192.168.254.248";
  hostAddress = "192.168.254.247";
  services = [
    "immich"
    "media"
  ];
  servicePorts = services: lib.mergeAttrsList (map (s: config.shu.services.${s}.ports) services);

in
{
  options.shu.services.caddy.enable = lib.mkEnableOption "Enable caddy as systemd container";

  config = lib.mkIf cfg.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };
    # Pin on the same cores as plex (see plex.nix --cpuset-cpus)
    containers.caddy = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      bindMounts = {
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
        };
        services = {
          resolved.enable = true;
          caddy = {
          };
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
