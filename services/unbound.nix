{ config, lib, self, ... }:
let
  cfg = config.services.shuUnbound;
  volumePath = "${config.home-manager.users.sebastien.home.homeDirectory}/git/my-unbound/data";
in
{
  options = {
    services.shuPlex.enable = lib.mkEnableOption "Enable Plex running in container";
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
        volumes = [
          "${volumePath}/opt:/opt:ro"
        ];
        extraOptions = [
          "--cpuset-cpus=12-15"
        ];
      };
    };
  };
}
