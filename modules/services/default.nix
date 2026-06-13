{ ... }:

{
  imports = [
    ./headscale.nix
    ./immich.nix
    ./media.nix
    ./nfs-client.nix
    ./nfs.nix
    ./plex.nix
    ./syncthing.nix
    ./unbound.nix
    ./exit.nix
  ];
}
