{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.git;
in
{
  options.shu.home.git.enable = lib.mkEnableOption "Enable shu home git";
  config = lib.mkIf cfg.enable {
    age.secrets.emailPro = {
      file = ../../../secrets/emailPro.age;
      path = "${config.home.homeDirectory}/.config/git/config-free";
    };

    programs.git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          side-by-side = true;
          navigate = true;
        };
      };
      userEmail = "sebastienhurtel+github@gmail.com";
      userName = "shu";
      extraConfig = {
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
        pull = {
          ff = "only";
        };
        init = {
          defaultBranch = "main";
        };
        alias = {
          glog = "log --graph --decorate --online --all";
        };
        branch = {
          sort = "authordate";
        };
        "includeIf ${''"gitdir:~/git/free"''}" = {
          path = "~/.config/git/config-free";
        };
      };
    };
  };
}
