{
  agenix,
  hostname,
  pkgs,
  username,
  wm,
  ...
}:
{

  imports = [
    ./modules
    ./hosts/${hostname}
  ];

  home-manager = {
    users.${username} = {
      imports = [ ./home.nix ];
    };
    backupFileExtension = "backup";
  };

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "${hostname}";
    firewall.enable = true;
    nftables.enable = true;
  };

  users = {
    users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
  };

  programs = {
    # donf is enable to use GTK in home.nix
    dconf.enable = true;
    mtr.enable = true;
    zsh.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      agenix.packages.${system}.default
      cmake
      fastfetch
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
  services = {
    avahi = {
      enable = true;
      openFirewall = true;
    };
    fwupd.enable = true;
    resolved.enable = true;
    tailscale.enable = true;
  };
}
