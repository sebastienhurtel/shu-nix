# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B7B9-F6F4";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6a88af82-4f51-47f7-a03e-aaec7b002951";
      fsType = "ext4";
    };

  fileSystems."/nix/store" =
    { device = "/dev/disk/by-uuid/5b638f69-96c2-4fa3-ab0f-39519a6d5850";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/a91dbb08-6230-4fbe-9c66-751547ddd649";
      fsType = "ext4";
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/60e4b883-d1d5-44b0-9d50-0024b4ea2a33";
      fsType = "ext4";
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/2bc43e60-4cd7-423d-afb3-ffacdebedc98";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
