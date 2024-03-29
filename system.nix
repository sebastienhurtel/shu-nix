{ pkgs, username, hostname, wm, ... }: {

  imports = [ ./system/wm/${wm}.nix ./system/wm/wayland.nix ];

  home-manager.users.${username} = { imports = [ ./home.nix ]; };

  time.timeZone = "Europe/Paris";
  networking.hostName = "${hostname}";

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYHRiFu4tx6wCtafUoGjVhBqDfVzoOmrcIBods8bmTYGbrbaqq3Mh71vbDrEOEVPNonGgzXFjLSs+l/spqUZ0630BY0Pjtiu/yAW33hqGvdx6T3Mv2+GFG+pHsbs4qEs0cfL6mVeGbLUMD7RUr1aZLNee2XMNMsXKEWjt1HD63/jhCBaD4eo3/uw1GsTAo8a2ijKEgbXMLaZrYIruQKVi7B0JnJo4ZVxWxk3ABC7eXEmwvumvIBQnYy7LLwJ9d5NwTw5v8nP51OeMhM6Uq1O5pnzATq4YIyKnzlhlfHcetdN+iLhl9SnjxPNYIKU1PCOiKlb305W6hx8peQYO/hyKo/MIYvN6+/ScpfQAAgZFrbzMzFe4z3sUD76sH5LA+BNZsXWAfORj/CfUFnezK09Umu/6RZ410cUK9WNRdmWcWvTrTNch6ckATgS7tbzIwPitPkq2JjS2Tf2iw/p9sMAf4eht7/H1UyGn9uJUG42n0lPc1/CtZDspaVwKm1hncpqwso6sb6jZtBnnnbxc1GmjHHXAuZ/2g34imLW/uiviQ3cL+bSyx8WflaU0ljGVFDgjVoD2N93wSyd57EzCYyehidpnPpYyMcH85CzY8mqzA9mmOeYdHDdJmzZOUqfDrHUIIwtUWK/exqaYiNVRiF5qSWZY2MvFbl1/MBJ0Jr8z2AQ== sebastienhurtel@gmail.com"
    ];
  };

  security.sudo.extraRules = [{
    users = [ "${username}" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  # hyprland has to be enable as a nix module as well as home-manager
  # donf is enable to use GTK in home.nix
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dig
    duf
    fd
    git
    htop
    mdadm
    mesa
    mpv
    mtr
    ncdu
    neofetch
    nftables
    numactl
    powertop
    python3
    ripgrep
    tmux
    vim
    linuxKernel.packages.linux_zen.cpupower
  ];

  services.fwupd.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  sound.enable = true;
  security.rtkit.enable = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      tarball-ttl = 300;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  zramSwap.enable = true;

  system.stateVersion = "23.11";

  networking = {
    firewall.enable = false;
    nftables.enable = false;
  };

  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        RADEON_POWER_PROFILE_ON_AC = "default";
        RADEON_POWER_PROFILE_ON_BAT = "low";

        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 50; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 65; # 60 and above it stops charging

      };
    };
    flatpak.enable = true;
  };

}
