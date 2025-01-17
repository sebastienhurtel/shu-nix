{
  pkgs,
  username,
  lib,
  ...
}:

{
  networking = {
    wireless.enable = false;
    networkmanager.enable = true;
    firewall.trustedInterfaces = [ "virbr0" ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    mdadm
  ];

  services = {
    shuPlex.enable = true;
    shuNFS.enable = true;
    shuUnbound.enable = true;
    resolved.enable = lib.mkForce false;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = true;
    };
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
