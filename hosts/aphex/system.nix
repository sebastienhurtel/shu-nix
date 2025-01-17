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
  };

  services = {
    gnome.gnome-keyring.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      openFirewall = true;
    };
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
