{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.services.shu.plex;
  volumePath = "${config.home-manager.users.sebastien.home.homeDirectory}/git/pms-docker";
in
{
  options.services.shu.plex.enable = lib.mkEnableOption "Enable Plex running in container";

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
        image = "lscr.io/linuxserver/plex@sha256:535b88a993e3bfe7693edab81346817cd128794eb6fdae0eab02a953823d02f2";
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
