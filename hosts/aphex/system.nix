{ username, lib, ... }:
let
  sshKey = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXnexw7oCRiKGgbyyaoX5LnSJZeLl/P7/nI8i0DFIFd62xNx95KALDmXWNslVwJzBlnPwXqoNHol4hpJBwo15GVd1x+QOCTeo8P2mXlqBtpjee4JAu0ZRXopAWFtItX27PO7CiimMok85BtcExWHTntw5LUQtaK7bz/NB0B1RgolrxsHVmo7OXf9Y7FtXewkeZAtZzKIDZipTIeaw8Orpn14Su46fiabkni8g5pHEoskg7pRbyRbZ6QjUbdE8XCZOca0CfSOZoapoEtzeJSPomIPognHHpuGOuucGMai9iM2q15fLtTFoZH3JlQuaON8Rx0j5/2F59XzzeiBQI5PE/ Aphex"
  ];
in
{
  networking = {
    wireless.enable = false;
    networkmanager.enable = true;
    usePredictableInterfaceNames = false;
    useDHCP = false;
  };

  security.acme.defaults.dnsResolver = "1.1.1.1:53";
  boot.kernel.sysctl = {
    "net.ipv6.conf.eth0.accept_ra" = 0;
  };
  # disable X
  programs.ssh.setXAuthLocation = false;
  security.pam.services.su.forwardXAuth = lib.mkForce false;
  fonts.fontconfig.enable = false;

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = true;
    };
    shu.headscale = {
      enable = true;
    };
    avahi.enable = lib.mkForce false;
  };
  users.users = {
    root = {
      initialPassword = "ChangeMe!";
      openssh.authorizedKeys.keys = sshKey;
    };
    "${username}" = {
      openssh.authorizedKeys.keys = sshKey;
    };
  };
}
