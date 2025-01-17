{ hostname, config, lib, self, ... }:
let
  cfg = config.services.shuNfs;
in
{
  options.services.shuNfs.enable = lib.mkEnableOption "Enable NFS server";

  config = lib.mkIf cfg.enable {
    services = {
      nfs.server = {
        enable = true;
        hostName = hostname;
        statdPort = 4000;
        lockdPort = 4001;
        mountdPort = 4002;
        exports = ''
          /data 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
          /data/movies 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
          /data/photos 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
          /data/series 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
          /data/music 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
          /data/documents 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
          /data/downloads 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
          /data/windows 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000,sync,no_subtree_check,insecure)
        '';
      };
    };
    networking.firewall = {
      allowedTCPPorts = [
        config.services.nfs.server.statdPort
        config.services.nfs.server.lockdPort
        config.services.nfs.server.mountdPort
        111
      ];
    };
  };
}
