{ pkgs, username, hostname, ... }:

{
  networking = {
    wireless.enable = false;
    networkmanager.enable = true;
    firewall.trustedInterfaces = [ "virbr0" ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs;
    [
      docker-compose
      mdadm
    ];

  services = {
    shuPlex.enable = true;
    shuNfs.enable = true;
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
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        ovmf.enable = true;
      };
    };
  };

  users.extraUsers.${username}.extraGroups = [ "libvirtd" ];
}
