{ ... }:

{
  imports = [
    ./plex.nix
    ./nfs.nix
    ./nfs-client.nix
    ./unbound.nix
    ./headscale.nix
  ];
}
