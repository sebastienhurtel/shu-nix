{ username, ... }:
{
  imports = [
    ./sebastien.nix
  ];

  home-manager.users.${username} = {
    manual.manpages.enable = false;
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
    # required to autoload fonts from packages installed via Home Manager
    fonts.fontconfig.enable = true;
  };
}
