{ config, pkgs, ... }: {
  networking.hostName = "vmarcus";
  time.timeZone = "Europe/Paris";

  users.users.sebastien = {
    isNormalUser = true;
    home = "/home/sebastien";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYHRiFu4tx6wCtafUoGjVhBqDfVzoOmrcIBods8bmTYGbrbaqq3Mh71vbDrEOEVPNonGgzXFjLSs+l/spqUZ0630BY0Pjtiu/yAW33hqGvdx6T3Mv2+GFG+pHsbs4qEs0cfL6mVeGbLUMD7RUr1aZLNee2XMNMsXKEWjt1HD63/jhCBaD4eo3/uw1GsTAo8a2ijKEgbXMLaZrYIruQKVi7B0JnJo4ZVxWxk3ABC7eXEmwvumvIBQnYy7LLwJ9d5NwTw5v8nP51OeMhM6Uq1O5pnzATq4YIyKnzlhlfHcetdN+iLhl9SnjxPNYIKU1PCOiKlb305W6hx8peQYO/hyKo/MIYvN6+/ScpfQAAgZFrbzMzFe4z3sUD76sH5LA+BNZsXWAfORj/CfUFnezK09Umu/6RZ410cUK9WNRdmWcWvTrTNch6ckATgS7tbzIwPitPkq2JjS2Tf2iw/p9sMAf4eht7/H1UyGn9uJUG42n0lPc1/CtZDspaVwKm1hncpqwso6sb6jZtBnnnbxc1GmjHHXAuZ/2g34imLW/uiviQ3cL+bSyx8WflaU0ljGVFDgjVoD2N93wSyd57EzCYyehidpnPpYyMcH85CzY8mqzA9mmOeYdHDdJmzZOUqfDrHUIIwtUWK/exqaYiNVRiF5qSWZY2MvFbl1/MBJ0Jr8z2AQ== sebastienhurtel@gmail.com"
    ];
  };
  security.sudo.extraRules = [{
    users = [ "sebastien" ];
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
    hyprland.enable = true;
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
    ripgrep
    tmux
    vim
  ];

  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  sound.enable = true;
  security.rtkit.enable = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    tarball-ttl = 300;
  };

  home-manager.useUserPackages = true;
  zramSwap.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

  system.stateVersion = "23.11";
}
