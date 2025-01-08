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
    enable = false;
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
    gnome.gnome-keyring.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = true;
    };
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "100.64.0.4:8384";
      settings = {
        devices.squarepusher = {
          autoAcceptFolders = true;
          addresses = [
            "tcp://100.64.0.3:22000"
          ];
          id = "34TQTWK-YQZSJRF-4DCRH65-ULWYVRD-PWJRBV2-OAGBPO5-6H3WZY7-IGNSNQX";
        };
        folders = {
          Documents = {
            type = "receiveonly";
            path = "/data/documents/squarepusher";
            devices = [ "squarepusher" ];
          };
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 8384 ];
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYHRiFu4tx6wCtafUoGjVhBqDfVzoOmrcIBods8bmTYGbrbaqq3Mh71vbDrEOEVPNonGgzXFjLSs+l/spqUZ0630BY0Pjtiu/yAW33hqGvdx6T3Mv2+GFG+pHsbs4qEs0cfL6mVeGbLUMD7RUr1aZLNee2XMNMsXKEWjt1HD63/jhCBaD4eo3/uw1GsTAo8a2ijKEgbXMLaZrYIruQKVi7B0JnJo4ZVxWxk3ABC7eXEmwvumvIBQnYy7LLwJ9d5NwTw5v8nP51OeMhM6Uq1O5pnzATq4YIyKnzlhlfHcetdN+iLhl9SnjxPNYIKU1PCOiKlb305W6hx8peQYO/hyKo/MIYvN6+/ScpfQAAgZFrbzMzFe4z3sUD76sH5LA+BNZsXWAfORj/CfUFnezK09Umu/6RZ410cUK9WNRdmWcWvTrTNch6ckATgS7tbzIwPitPkq2JjS2Tf2iw/p9sMAf4eht7/H1UyGn9uJUG42n0lPc1/CtZDspaVwKm1hncpqwso6sb6jZtBnnnbxc1GmjHHXAuZ/2g34imLW/uiviQ3cL+bSyx8WflaU0ljGVFDgjVoD2N93wSyd57EzCYyehidpnPpYyMcH85CzY8mqzA9mmOeYdHDdJmzZOUqfDrHUIIwtUWK/exqaYiNVRiF5qSWZY2MvFbl1/MBJ0Jr8z2AQ== sebastienhurtel@gmail.com"
    ];
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
