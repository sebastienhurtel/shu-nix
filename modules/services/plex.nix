{
  config,
  lib,
  self,
  agenix,
  ...
}:
let
  cfg = config.shu.services.plex;
  stateDir = "/var/lib/plex";
  uid = toString config.ids.uids.plex;
  gid = toString config.ids.gids.users;
in
{
  imports = [ agenix.nixosModules.default ];
  options.shu.services.plex.enable = lib.mkEnableOption "Enable Plex running in container";

  config = lib.mkIf cfg.enable {
    age.secrets.plexClaim.file = "${self}/secrets/plexClaim.age";

    users.users.plex = {
      isSystemUser = true;
      uid = config.ids.uids.plex;
      group = "users";
    };
    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 ${uid} ${gid} -"
      "d ${stateDir}/config 0750 ${uid} ${gid} -"
      "d ${stateDir}/transcode 0750 ${uid} ${gid} -"
    ];

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
        image = "lscr.io/linuxserver/plex:latest";
        environment = {
          TZ = " Europe/Paris ";
          PUID = uid;
          PGID = gid;
          VERSION = "docker";
        };
        environmentFiles = [ config.age.secrets.plexClaim.path ];
        volumes = [
          "${stateDir}/config:/config"
          "${stateDir}/transcode:/transcode"
          "/data/movies:/movies:ro"
          "/data/photos:/photos:ro"
          "/data/series:/series:ro"
          "/data/music:/music:ro"

        ];
        devices = [
          "/dev/dri:/dev/dri"
        ];
        extraOptions = [
          "--network=host"
          "--cpuset-cpus=12-15"
        ];
      };
    };
  };
}
