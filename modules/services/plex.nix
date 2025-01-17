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
  options.services.shuPlex.enable = lib.mkEnableOption "Enable Plex running in container";

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
        image = "lscr.io/linuxserver/plex@sha256:a3a3a850a64fb747c59f85dbc19b157781c3b9c921a83799127894b0ebdf3a68";
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
