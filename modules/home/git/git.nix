{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shu.git;
in
{
  options.shu.git.enable = lib.mkEnableOption "Enable Shu git";
  config = lib.mkIf cfg.enable {
    home.activation.removeOlgConfig = lib.hm.dag.entryBefore [ "checkFilesChanged" ] ''
      rm -f .config/git/config*
    '';

    home.activation."git-secrets" = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
      secretGH=$(cat "${config.age.secrets.emailGithub.path}")
      config="${config.home.homeDirectory}/.config/git/config"
      ${pkgs.gnused}/bin/sed -i "s/@emailGithub@/$secretGH/" "$config"
      secretPro=$(cat "${config.age.secrets.emailPro.path}")
      configPro="${config.home.homeDirectory}/.config/git/config-free"
      ${pkgs.gnused}/bin/sed -i "s/@emailPro@/$secretPro/" "$configPro"
    '';

    age.secrets.emailGithub.file = ../../../secrets/emailGithub.age;
    age.secrets.emailPro.file = ../../../secrets/emailPro.age;

    home.file.".config/git/config-free".text = ''
      [user]
              name = shurtel
              email = "@emailPro@"
    '';

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
      userEmail = "@emailGithub@";
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
