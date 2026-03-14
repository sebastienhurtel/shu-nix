{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.claude-code;
  wrappedClaudeCode = pkgs.mkBwrapper {
    app = {
      package = pkgs.unstable.claude-code;
      runScript = "claude";
      env = {
        CLAUDE_CONFIG_DIR = "$HOME/.config/claude-code";
      };
    };
    mounts = {
      readWrite = [
        "$PWD"
      ];
    };
    fhsenv.skipExtraInstallCmds = true;
    sockets.x11 = false;
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
