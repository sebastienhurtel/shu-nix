{ pkgs }:
pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "libyang-cpp";
  version = "v4";
  src = pkgs.fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang-cpp";
    rev = finalAttrs.version;
    hash = "sha256-RoApm3gSNDRaC2hKmCAon2q9OVQQ8Xg4+NUNmb6aUT0=";
  };
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    git
    libyang
  ];

  outputs = [ "out" ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];
})
