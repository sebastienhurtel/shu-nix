{
  config,
  lib,
  username,
  self,
  ...
}:
let
  cfg = config.shu.home.git;
  email = "sebastienhurtel+github@gmail.com";
  name = "shu";
  hmConfig = config.home-manager.users.${username};
in
{
  options.shu.home.git.enable = lib.mkEnableOption "Enable shu home git";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      age.secrets.emailPro = {
        file = "${self}/secrets/emailPro.age";
        path = "${hmConfig.xdg.configHome}/git/config-free";
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
              condition = "gitdir:${hmConfig.xdg.configHome}/git/free/";
              path = "${hmConfig.xdg.configHome}/git/config-free";
            }
          ];
        };
      };
    };
  };
}
