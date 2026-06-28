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

  imports = [ agenix.nixosModules.default ];
  config = lib.mkIf cfg.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = [ containerInterface ];
    };
    age.secrets.media.file = "${self}/secrets/media.age";
    containers.media = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      enableTun = true;
      hostAddress = "${hostAddress}";
      localAddress = "${containerAddress}";
      bindMounts."${config.age.secrets.media.path}".isReadOnly = true;
      config = {
        networking.useHostResolvConf = false;
        services = {
          resolved.enable = true;
          tailscale = {
            enable = true;
#            authKeyFile = config.age.secrets.media.path;
#            extraUpFlags = [
#              "--login-server=https://aphex.shurtel.fr"
#              "--accept-dns=false"
#            ];
          };
          transmission.enable = true;
          transmission.package = pkgs.transmission_4;
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
  };
}
