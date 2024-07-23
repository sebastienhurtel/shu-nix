{ username, ... }: {
  home-manager.users.${username} = {
    stylix.targets.xyz.enable = false;
  };
}
