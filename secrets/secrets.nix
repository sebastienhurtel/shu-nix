let
  sebastien = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJz4KjSHOW5LuUPn7kaOgvj/pZWg0EmPrqiS5N3Bx0X4";
  squarepusher = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKTSzIZr/KS0Ry2Yt3ytRcvl3qUiF7VxIbeafmu7qfc";
  deftones = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyukD6dhooT96Vh70kNwMFgE+juZqtsfzCPAj0ol0r6";
  users = [ sebastien ];
  systems = [ squarepusher deftones ];
in
{
  "emailPro.age".publicKeys = users ++ systems;
  "emailGithub.age".publicKeys = users ++ systems;
}
