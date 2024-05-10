{ pkgs, modulesPath, ... }:

{
  imports = [
    #inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  networking.hostName = "vmarcus";

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
      availableKernelModules =
        [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];

    };
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/91FD-06F1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/23b5724d-954f-4621-9c6b-87da8435307f";
    fsType = "ext4";
  };

  fileSystems."/nix/store" = {
    device = "/dev/disk/by-uuid/16db1c97-e9e2-4fe7-81cc-7cf86b716a90";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/10b9daeb-0211-49cb-9695-c9c60ecc6c4e";
    fsType = "ext4";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/44d3125c-70ac-47b0-b680-7fc827ac80a1";
    fsType = "ext4";
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/138dd09d-c5e7-4f95-829b-200ce0da4947";
    fsType = "ext4";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };
  system.stateVersion = "23.05";
}
