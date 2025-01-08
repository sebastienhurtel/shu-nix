{
  config,
  lib,
  modulesPath,
  pkgs,
  options,
  ...
}:
let
  cfg = config.shu.syncthing;
  syncthingModule = import (modulesPath + "/services/networking/syncthing.nix") { inherit config lib options pkgs; };
  devicesType = syncthingModule.options.services.syncthing;
in
{
  options.shu.syncthing = {
    enable = lib.mkEnableOption "Enable shu syncthing";
    devices = lib.mkOption {
      type = devicesType;
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      devices = cfg.devices;
    };
  };
}
