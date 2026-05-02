{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.khal;
in
{
  options.shu.home.khal.enable = lib.mkEnableOption "Enable Shu Khal";
  config = lib.mkIf cfg.enable {
    accounts.calendar = {
      basePath = ".calendars";
      accounts."shu" = {
        name = "shu";
        primary = true;
        khal = {
          enable = true;
          addresses = [ "sebastienhurtel@gmail.com" ];
        };
      };
    };
    programs.khal = {
      enable = true;
      locale = {
        timeformat = "%H:%M";
        dateformat = "%Y-%m-%d";
        longdateformat = "%Y-%m-%d";
        datetimeformat = "%Y-%m-%d %H:%M";
        longdatetimeformat = "%Y-%m-%d %H:%M";
      };
    };
  };
}
