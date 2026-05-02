{
  agenix,
  config,
  hostname,
  lib,
  pkgs,
  username,
  wm,
  ...
}:
let
  cfg = config.shu.base;
in
{
  options.shu.base.enable = lib.mkEnableOption "Enable base linux configuration";
  config = lib.mkIf cfg.enable {
    time.timeZone = "Europe/Paris";
    networking = {
      hostName = "${hostname}";
      firewall.enable = true;
      nftables.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [
        agenix.packages.${pkgs.stdenv.hostPlatform.system}.default # agenix CLI
        bat
        cmake
        fastfetch
        fd
        file
        findutils
        mesa
        ncdu
        numactl
        pciutils
        qwerty-fr
        ripgrep
        usbutils
        vim
      ];
    };

    nix = {
      settings = {
        trusted-users = [ username ];
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        auto-optimise-store = true;
        tarball-ttl = 300;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1d";
      };
    };

    shu.wm = {
      enable = if wm == "headless" then false else true;
      manager = wm;
    };

    programs = {
      ttl.enable = true;
      zsh.enable = true;
    };

    services = {
      avahi = {
        enable = lib.mkDefault true;
        openFirewall = lib.mkDefault true;
        nssmdns4 = lib.mkDefault true;
      };
      fwupd.enable = lib.mkDefault true;
      resolved.enable = lib.mkDefault true;
      tailscale.enable = lib.mkDefault true;
    };
  };
}
