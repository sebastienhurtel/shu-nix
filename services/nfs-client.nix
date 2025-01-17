{ hostname, config, lib, self, ... }:
let
  cfg = config.services.shuNFSClient;
in
{
  options.services.shuNFSClient.enable = lib.mkEnableOption "Enable NFS server";

  config = lib.mkIf cfg.enable {
    services.rpcbind.enable = true;

    fileSystems."/mnt/data" = {
      device = "192.168.1.250:/data";
      fsType = "nfs";
    };

    systemd.mounts = [{
      type = "nfs";
      mountConfig = {
        Options = "noatime,nfsvers=4.2";
      };
      what = "192.168.1.250:/data";
      where = "/mnt/data";
    }];

    systemd.automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/mnt/data";
    }];
  };
}
