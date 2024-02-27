{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${nixos-hardware}/lenovo/thinkpad/z/z13"
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      luks.devices.luksroot = {
        device = "/dev/disk/by-uuid/0fda6833-de3d-43e7-9861-ae1ba067a14d";
        preLVM = true;
      };
      kernelModules = [ "dm-snapshot" ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];

    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e7a36316-be66-4bfc-8c51-5d55c302ca7b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5503-6B09";
    fsType = "vfat";
  };

  fileSystems."/nix/store" = {
    device = "/dev/disk/by-uuid/c67747c8-f5da-48fd-8764-03e93c046c21";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/5b87ec1b-50c9-4389-bcec-d8ff1f43b398";
    fsType = "ext4";
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/db2bf8a1-9809-4330-bbd5-e5322b141811";
    fsType = "ext4";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/798f8a21-aeaa-434e-8969-7c699d726794";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
