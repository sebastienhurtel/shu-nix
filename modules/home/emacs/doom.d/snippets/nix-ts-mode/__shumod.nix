# -*- mode: snippet -*-
# --
{
   ${1:pkgs,
    lib,
    config
    }
}:
let
  cfg = config.shu.$2;
in
{
  options.shu.$2.enable = lib.mkEnableOption "${3:Module description}";
  config = lib.mkIf cfg.enable {

  };
}

