{
  lib,
  modulesPath,
  disko,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    disko.nixosModules.disko
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "uhci_hcd"
        "ehci_pci"
        "ahci"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader.grub = {
      # devices = [];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  disko.devices = {
    disk.vda = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          ESP = {
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "45.90.162.252";
          prefixLength = 32;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a0c:8881:5:b::1";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway = {
      address = "100.100.100.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "24.11";
}
