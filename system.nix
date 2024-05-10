{ pkgs, username, hostname, wm, ... }: {

  imports = [
    ./system/wm/${wm}.nix
    ./system/${hostname}.nix
  ];

  home-manager.users.${username} = { imports = [ ./home.nix ]; };

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "${hostname}";
    firewall.enable = true;
    nftables = {
      enable = true;
      ruleset = ''
        table inet nixos-fw {
          chain input {
            ip saddr 192.168.1.0/24 ip daddr 192.168.1.0/24 accept comment "LAN"
          }
        }
      '';
    };
  };

  users = with pkgs; {
    defaultUserShell = zsh;
    users.${username} = {
      isNormalUser = true;
      shell = zsh;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYHRiFu4tx6wCtafUoGjVhBqDfVzoOmrcIBods8bmTYGbrbaqq3Mh71vbDrEOEVPNonGgzXFjLSs+l/spqUZ0630BY0Pjtiu/yAW33hqGvdx6T3Mv2+GFG+pHsbs4qEs0cfL6mVeGbLUMD7RUr1aZLNee2XMNMsXKEWjt1HD63/jhCBaD4eo3/uw1GsTAo8a2ijKEgbXMLaZrYIruQKVi7B0JnJo4ZVxWxk3ABC7eXEmwvumvIBQnYy7LLwJ9d5NwTw5v8nP51OeMhM6Uq1O5pnzATq4YIyKnzlhlfHcetdN+iLhl9SnjxPNYIKU1PCOiKlb305W6hx8peQYO/hyKo/MIYvN6+/ScpfQAAgZFrbzMzFe4z3sUD76sH5LA+BNZsXWAfORj/CfUFnezK09Umu/6RZ410cUK9WNRdmWcWvTrTNch6ckATgS7tbzIwPitPkq2JjS2Tf2iw/p9sMAf4eht7/H1UyGn9uJUG42n0lPc1/CtZDspaVwKm1hncpqwso6sb6jZtBnnnbxc1GmjHHXAuZ/2g34imLW/uiviQ3cL+bSyx8WflaU0ljGVFDgjVoD2N93wSyd57EzCYyehidpnPpYyMcH85CzY8mqzA9mmOeYdHDdJmzZOUqfDrHUIIwtUWK/exqaYiNVRiF5qSWZY2MvFbl1/MBJ0Jr8z2AQ== sebastienhurtel@gmail.com"
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

  environment = with pkgs; {
    systemPackages = [
      usbutils
      mesa
      ncdu
      neofetch
      nftables
      numactl
      ripgrep
      vim
    ];
  };

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

  services = {
    fwupd.enable = true;
    resolved.enable = true;
    avahi = {
      enable = true;
      openFirewall = true;
    };
  };
}
