{ pkgs, lib, config, ... }:

{
  security.pam.services = {
    login.fprintAuth = false;
  # similarly to how other distributions handle the fingerprinting login
    gdm-fingerprint =
      lib.mkIf (config.services.fprintd.enable) {
        text = ''
          auth       required                    pam_shells.so
          auth       requisite                   pam_nologin.so
          auth       requisite                   pam_faillock.so      preauth
          auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
          auth       optional                    pam_permit.so
          auth       required                    pam_env.so
          auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
          auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so

          account    include                     login

          password   required                    pam_deny.so

          session    include                     login
          session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
        '';
    };
  };
  services = {
    xserver.desktopManager.gnome.enable = true;
    power-profiles-daemon.enable = false;
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };
  environment.gnome.excludePackages =
    (with pkgs; [ gnome-tour power-profiles-daemon ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
}
