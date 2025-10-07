{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      luks.devices.luksroot = {
        device = "/dev/disk/by-uuid/46e63b6c-fcb1-49e9-b5e8-e865d1a300b0";
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
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
      mesa
    ];
  };

  fileSystems."/" = {
    device = "/dev/mapper/vgnixos-root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5503-6B09";
    fsType = "vfat";
  };

  fileSystems."/nix/store" = {
    device = "/dev/mapper/vgnixos-store";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/vgnixos-home";
    fsType = "ext4";
  };

  fileSystems."/tmp" = {
    device = "/dev/mapper/vgnixos-tmp";
    fsType = "ext4";
  };

  fileSystems."/var" = {
    device = "/dev/mapper/vgnixos-var";
    fsType = "ext4";
  };

  # Keyboardio
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2301", SYMLINK+="Model01",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2300", SYMLINK+="Model01",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="0006", SYMLINK+="Model100",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="0005", SYMLINK+="Model100",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="00a1", SYMLINK+="Preonic",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="00a3", SYMLINK+="Preonic",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="00a0", SYMLINK+="Preonic",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="00a3", SYMLINK+="Preonic",  ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_CANDIDATE}="0", TAG+="uaccess", TAG+="seat"
  '';

  services.hardware.bolt.enable = true;

  swapDevices = [ ];
  zramSwap.enable = true;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "23.11";
}
