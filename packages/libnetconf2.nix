{
  cmake,
  curl,
  fetchFromGitHub,
  libssh,
  libxcrypt,
  libyang,
  openssl,
  pkg-config,
  stdenv
}:
stdenv.mkDerivation (finalAttrs: {
  name = "libnetconf2";
  version = "v3.7.10";
  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libnetconf2";
    rev = finalAttrs.version;
    hash = "sha256-lqJqrXWlOTtwvqNNM7JjU45daCj1I7+d19reQT9isK4=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
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
