{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.shuNFSClient;
in
{
  options.services.shuNFSClient.enable = lib.mkEnableOption "Enable NFS server";

  config = lib.mkIf cfg.enable {

    environment = with pkgs; {
      systemPackages = [ nfs-utils ];
    };

    services.rpcbind.enable = true;

    systemd.mounts = [{
      type = "nfs";
      mountConfig = {
        Options = "noatime,nfsvers=4.2,x-systemd.automount,x-systemd.idle-timeout=600,noauto";
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
