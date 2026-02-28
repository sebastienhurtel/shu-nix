{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.home.claude-code;
  claude-code-unwrapped = pkgs.unstable.claude-code.overrideAttrs (old: {
    postInstall = "";
  });
  wrappedClaudeCode = pkgs.mkBwrapper {
    app = {
      package = claude-code-unwrapped;
      runScript = "claude";
      renameDesktopFile = false;
      overwriteExec = false;
      env = {
        CLAUDE_CONFIG_DIR = "$HOME/.config/claude-code";
        DISABLE_AUTOUPDATER = "1";
        DISABLE_INSTALLATION_CHECKS = "1";
      };
    };
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
