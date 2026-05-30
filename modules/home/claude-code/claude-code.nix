{
  config,
  lib,
  pkgs,
  username,
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
  # Clear inherited/ambient caps before the bwrap call
  claudeCodeNoCaps = pkgs.writeShellScriptBin "claude-code" ''
    exec ${pkgs.util-linux}/bin/setpriv \
      --ambient-caps=-all --inh-caps=-all \
      -- ${wrappedClaudeCode}/bin/claude-code "$@"
  '';
in
{
  options.shu.home.claude-code.enable = lib.mkEnableOption "Enable shu home claude-code";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.claude-code = {
        enable = true;
        package = claudeCodeNoCaps;
      };
    };
  };
}
