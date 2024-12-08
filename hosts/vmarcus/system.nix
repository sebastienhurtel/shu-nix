{ username, pkgs, ... }:
{
  users.groups.admin = { };
  users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "admin";
      group = "admin";
  };

# virt-install \
#   --graphics spice,listen=none,gl.enable=yes,rendernode=/dev/dri/renderD128 \
#   --name hypr-vm \
#   --memory 8192 \
#   --os-variant nixos-24.05 \
#   --disk ./vmarcus.qcow2 \
#   --import

  # virtualisation.vmVariantWithBootLoader = {
  #   # following configuration is added only when building VM with build-vm
  #   virtualisation = {
  #     memorySize = 8192; # Use 2048MiB memory.
  #     cores = 6;
  #     graphics = true;
  #     diskSize = 10000;

  #   };
  # };

  programs.dconf.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  hardware = {
    pulseaudio = {
      enable = false;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
    bluetooth = { enable = true; };
  };
  # Enable audio through pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
