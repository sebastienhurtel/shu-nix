{ pkgs }:
pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "libnetconf2";
  version = "v3.7.10";
  src = pkgs.fetchFromGitHub {
    owner = "CESNET";
    repo = "libnetconf2";
    rev = finalAttrs.version;
    hash = "sha256-lqJqrXWlOTtwvqNNM7JjU45daCj1I7+d19reQT9isK4=";
  };
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];
  buildInputs = with pkgs; [
    libyang
    libssh
    openssl
    curl
    libxcrypt
  ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];
  outputs = [
    "out"
    "dev"
  ];
})
