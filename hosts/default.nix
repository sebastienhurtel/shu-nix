{ username, ... }:
{
  imports = [
    ./aphex
    ./deftones
    ./squarepusher
    ./marcus
  ];

  shu = {
    base.enable = true;
    users.${username}.enable = true;
  };
}
