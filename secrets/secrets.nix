let
  sebastien = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID29OciCljpOoDbhKiextIDShlq+hcd3MLvuiZm50tAh";
  squarepusher = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKTSzIZr/KS0Ry2Yt3ytRcvl3qUiF7VxIbeafmu7qfc";
  deftones = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyukD6dhooT96Vh70kNwMFgE+juZqtsfzCPAj0ol0r6";
  users = [ sebastien ];
  systems = [
    squarepusher
    deftones
  ];
in
{
  "emailPro.age".publicKeys = users;
  "emailGithub.age".publicKeys = users;
  "plexClaim.age".publicKeys = users ++ systems;
  "shScripts.age".publicKeys = users;
}
