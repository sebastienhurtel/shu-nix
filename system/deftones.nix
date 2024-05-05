{ pkgs, username, ... }:

{
  networking = {
    wireless.enable = false;
    networkmanager.enable = true;
    interfaces.enp3s0.useDHCP = false;
    interfaces.wlp4s0.useDHCP = false;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs;
    [
      docker-compose
      libguestfs
      mdadm
    ];

  services = {
    nfs.server = {
      enable = true;
      statdPort = 4000;
      lockdPort = 4001;
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
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = true;
    };
  };
  sound.enable = false;

  systemd.services.myUnbound = {
    enable = true;
    description = "My personnal unbound docker container";
    unitConfig = {
      After = "podman.service network-online.target";
      Requires = "podman.service network-online.target";
    };
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/opt/my-unbound";
      RemainAfterExit = "yes";
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose pull --quiet";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      ExecReload = "${pkgs.docker-compose}/bin/docker-compose pull --quiet && ${pkgs.docker-compose}/bin/docker-compose up -d";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.plex = {
    enable = true;
    description = "My Plex media server";
    unitConfig = {
      After = "podman.service network-online.target";
      Requires = "podman.service network-online.target";
    };
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/opt/pms-docker";
      RemainAfterExit = "yes";
      ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose pull --quiet";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      ExecReload = "${pkgs.docker-compose}/bin/docker-compose pull --quiet && ${pkgs.docker-compose}/bin/docker-compose up -d";
    };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
     };
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
  };

  users.extraUsers.${username}.extraGroups = [ "libvirtd" ];
}