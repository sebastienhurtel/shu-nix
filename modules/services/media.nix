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
    age.secrets.media.file = "${self}/secrets/media.age";
    containers.media = {
      bindMounts."/home/sebastien/.ssh/id_ecdsa_service_media" = {
        hostPath = "/etc/ssh";
        isReadOnly = true;
      };
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      enableTun = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      config ={
        imports = [ agenix.nixosModules.default ];
        age.identityPaths = [ "/etc/ssh/id_ecdsa_service_media" ];
        age.secrets.media.file = "${self}/secrets/media.age";
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
