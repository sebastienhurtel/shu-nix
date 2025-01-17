{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.services.shuPlex;
  volumePath = "${config.home-manager.users.sebastien.home.homeDirectory}/git/pms-docker";
in
{
  options = {
    services.shuPlex.enable = lib.mkEnableOption "Enable Plex running in container";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.plexClaim.file = "${self}/secrets/plexClaim.age";

    networking = {
      firewall.allowedTCPPorts = [
        32400 # Web Interface/ Remote Access
      ];
      firewall.allowedUDPPorts = [
        1900 # DLNA
        5353 # Bonjour/Avahi
        32410 # GDM network discovery
        32412 # GDM network discovery
        32413 # GDM network discovery
        32414 # GDM network discovery
        32469 # Plex DLNA Server
      ];
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers."plex" = {
        autoStart = true;
        image = "lscr.io/linuxserver/plex:1.40.4@sha256:f15541bfa94eae032cb3c8392f800aba6b6068cb663b5bd1d12f559b5308f9eb";
        environment = {
          TZ = " Europe/Paris ";
          PUID = "1000";
          PGID = "100";
          VERSION = "docker";
        };
        environmentFiles = [ config.age.secrets.plexClaim.path ];
        volumes = [
          "${volumePath}/config:/config"
          "${volumePath}/transcode:/transcode"
          "/data/movies:/movies"
          "/data/photos:/photos"
          "/data/series:/series"
          "/data/music:/music"

        ];
        extraOptions = [
          "--network=host"
          "--cpuset-cpus=12-15"
        ];
      };
    };
  };
}
