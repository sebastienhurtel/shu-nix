{ username, ... }:
{
  imports = [
    ./aphex
    ./deftones
    ./squarepusher
  ];

  shu = {
    base.enable = true;
    users.${username}.enable = true;
  };
}
