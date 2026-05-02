inputs: final: prev:
let
  unstable = import ./unstable.nix;
  shuPackages = import ../derivations;
in
(shuPackages final) // (unstable inputs.nixpkgs-unstable final prev)
