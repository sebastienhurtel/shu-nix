{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ttl;
in
{
  options = {
    programs.ttl = {
      enable = lib.mkEnableOption {
        default = false;
      };
      package = lib.mkPackageOption pkgs.unstable "ttl" { };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.ttl = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = "${cfg.package}/bin/ttl";
    };
  };
}
