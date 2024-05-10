{ wm, pkgs, lib, config, ... }:
let
  windowManager = {
    environment.systemPackages = [ pkgs.libinput ];
    services = {
      gnome.gnome-keyring.enable = true;
      xserver = {
        enable = true;
        xkbVariant = "";
        xkbOptions = "";
        displayManager.gdm = {
          enable = true;
          wayland = true;
        };
      };
      dbus.enable = true;
    };
    security.pam.services = {
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
  };
  headless = {
    services.xserver.enable = false;
  };
in
{
  config = if lib.isString wm then windowManager else headless;
}
