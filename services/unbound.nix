{ config, lib, ... }:
let
  cfg = config.services.shuUnbound;
  volumePath = "${config.home-manager.users.sebastien.home.homeDirectory}/git/my-unbound";
in
{
  options = {
    services.shuUnbound.enable = lib.mkEnableOption "Enable Unbound running in container";
  };

  config = lib.mkIf cfg.enable {
#    age.secrets.unbound.file = "${self}/secrets/unboud.age";
    networking = {
      firewall.allowedTCPPorts = [
        53
      ];
      firewall.allowedUDPPorts = [
        53
      ];
    };
    virtualisation.oci-containers = {
      backend = "podman";
      containers."unbound" = {
        autoStart = true;
        image = "mvance/unbound:latest";
#        environmentFiles = [ config.age.secrets.unbound.path ];
        ports = [ "192.168.1.250:53:53/udp" ];
        volumes = [
          "${volumePath}/data/opt/unbound/etc/unbound/forward-records.conf:/opt/unbound/etc/unbound/forward-records.conf:ro"
          "${volumePath}/data/opt/unbound/etc/unbound/a-records.conf:/opt/unbound/etc/unbound/a-records.conf:ro"
        ];
        extraOptions = [
          "--cpuset-cpus=12-15"
        ];
      };
    };
  };
}
