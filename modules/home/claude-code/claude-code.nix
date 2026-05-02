{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.claude-code;
  wrappedClaudeCode = pkgs.mkBwrapper {
    imports = [
      # Enables common desktop functionality (bind sockets for audio, display, dbus, mount
      # directories for fonts, theming, etc.).
      pkgs.bwrapperPresets.desktop
    ];
    app = {
      package = pkgs.unstable.claude-code;
      runScript = "claude";
      env = {
        CLAUDE_CONFIG_DIR = "$HOME/.config/claude-code";
        SHELL = "${pkgs.bash}/bin/bash";
      };
    };
    mounts = {
      read = [
        "/run/systemd/resolve/stub-resolv.conf"
      ];
      readWrite = [
        "$PWD"
        "$HOME/.config/claude-code"
      ];
    };
    fhsenv.performDesktopPostInstall = false;
    sockets = {
      x11 = false;
      pipewire = false;
      pulseaudio = false;
      wayland = false;
    };
    dbus.enable = false;
    flatpak.enable = false;
  };
in
{
  options.shu.home.claude-code.enable = lib.mkEnableOption "Enable shu home claude-code";
  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      package = wrappedClaudeCode;
    };
  };
}
