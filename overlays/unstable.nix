nixpkgs-unstable: final: prev: {
  # this allows us to reference pkgs.unstable
  unstable = import nixpkgs-unstable {
    inherit (final) config;
    inherit (final.stdenv.hostPlatform) system;
  };
}
