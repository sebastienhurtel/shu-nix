{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
    # Enable kvm nested configuration
    # extraModprobeConfig = "options kvm_amd nested=1";
    # Virtualization related
    ## Enable AMD iommu and hudge pages
    kernelParams = [ "amd_iommu=on" "hugepagesz=2048k" "hugepages=12288" ];
    ## load kernel modules for PCI passthrough
    kernelModules = [ "kvm-amd" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    extraModprobeConfig = "options vfio-pci ids=10de:2504,10de:228e";
    kernel.sysctl = {
      "vm.nr_hugepages" = 12288;
    };
    # Prevent host to load nvidia driver module
    blacklistedKernelModules = [ "nouveau" "nvidia" ];
    extraModulePackages = [ ];
  };

  hardware.pulseaudio.enable = false;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
      mesa.drivers
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/69286327-b566-42ed-92ae-c4e02b535da1";
    fsType = "ext4";
  };
  fileSystems."/nix/store" = {
    device = "/dev/disk/by-uuid/a40cd959-bbef-4089-b5ae-2b21057eef88";
    fsType = "ext4";
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/b47dc2d0-ff88-481d-be2f-ac9a7c5509da";
    fsType = "ext4";
  };
  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/8795e40e-2fc0-4144-bde5-0fb5b6e09871";
    fsType = "ext4";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2edf35be-2831-4d8f-bd09-b90f1fb196c4";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F156-5041";
    fsType = "vfat";
  };
  fileSystems."/data/documents" = {
    device = "/dev/raid_5/documents";
    fsType = "ext4";
    options = [ "bind" ];
  };
  fileSystems."/data/downloads" = {
    device = "/dev/raid_5/downloads";
    fsType = "ext4";
    options = [ "bind" ];
  };
  fileSystems."/data/movies" = {
    device = "/dev/raid_5/movies";
    fsType = "ext4";
    options = [ "bind" ];
  };
  fileSystems."/data/music" = {
    device = "/dev/raid_5/music";
    fsType = "ext4";
    options = [ "bind" ];
  };
  fileSystems."/data/photos" = {
    device = "/dev/raid_5/photos";
    fsType = "ext4";
    options = [ "bind" ];
  };
  fileSystems."/data/series" = {
    device = "/dev/raid_5/series";
    fsType = "ext4";
    options = [ "bind" ];
  };
  fileSystems."/data/windows" = {
    device = "/dev/raid_5/windows";
    fsType = "ext4";
    options = [ "bind" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/dea4ac40-af5a-4b53-8a2f-6240608226eb"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "23.05";
}
