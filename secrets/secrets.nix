let
  sebastien = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID29OciCljpOoDbhKiextIDShlq+hcd3MLvuiZm50tAh";
  squarepusher = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKTSzIZr/KS0Ry2Yt3ytRcvl3qUiF7VxIbeafmu7qfc";
  deftones = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyukD6dhooT96Vh70kNwMFgE+juZqtsfzCPAj0ol0r6";
  media = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkx+IM9XvK9KiBI3eEVog+Ra9dFJQwNC5hz8/MOqVoy";
  users = [ sebastien ];
in
{
  "emailPro.age".publicKeys = users;
  "plexClaim.age".publicKeys = [ deftones ];
  "shScripts.age".publicKeys = users;
  "media.age".publicKeys = [ media ];
}
