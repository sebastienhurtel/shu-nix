{
  config,
  lib,
  ...
}:
let
  cfg = config.shu.home.git;
  email = "sebastienhurtel+github@gmail.com";
  name = "shu";
in
{
  options.shu.home.git.enable = lib.mkEnableOption "Enable shu home git";
  config = lib.mkIf cfg.enable {
    age.secrets.emailPro = {
      file = ../../../secrets/emailPro.age;
      path = "${config.home.homeDirectory}/.config/git/config-free";
    };

    programs = {
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          side-by-side = true;
          navigate = true;
        };
      };
      git = {
        enable = true;
        settings = {
          user = {
            email = email;
            name = name;
          };
          extraConfig = {
            push = {
              default = "current";
              autoSetupRemote = true;
            };
            difftastic.enable = true;
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
            github = {
              user = "sebastienhurtel";
              name = name;
              email = email;
            };
          };
        };
        includes = [
          {
            condition = "gitdir:~/git/free/";
            path = "~/.config/git/config-free";
          }
        ];
      };
    };
  };
}
