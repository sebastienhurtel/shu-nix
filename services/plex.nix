{ config
, lib
, self
, ...
}:
let
  cfg = config.services.shu-plex;
  volumePath = "$HOME/git/pms-docker";
in
{
  options = {
    services.shu-plex.enable = lib.mkEnableOption "Enable Plex running in container";
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
        # https://fleet.linuxserver.io/image?name=linuxserver/plex
        image = "lscr.io/linuxserver/plex:1.40.2@sha256:e934dade4d3dd253836e0232e10eb1fce91047de3f988cbefe138fe23ac729df";
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
          "--cpuset-cpu='12-15'"
        ];
      };
    };
  };
}
