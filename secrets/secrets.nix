let
  sebastien = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID29OciCljpOoDbhKiextIDShlq+hcd3MLvuiZm50tAh";
  squarepusher = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKTSzIZr/KS0Ry2Yt3ytRcvl3qUiF7VxIbeafmu7qfc";
  deftones = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyukD6dhooT96Vh70kNwMFgE+juZqtsfzCPAj0ol0r6";
in
{
  "emailPro.age".publicKeys = [ sebastien ];
  "plexClaim.age".publicKeys = [ deftones ];
  "shScripts.age".publicKeys = [ sebastien ];
  "media.age".publicKeys = [ deftones ];
}
