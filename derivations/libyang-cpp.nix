{
  cmake,
  fetchFromGitHub,
  git,
  libyang,
  pkg-config,
  stdenv
}:
stdenv.mkDerivation (finalAttrs: {
  name = "libyang-cpp";
  version = "v4";
  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang-cpp";
    rev = finalAttrs.version;
    hash = "sha256-RoApm3gSNDRaC2hKmCAon2q9OVQQ8Xg4+NUNmb6aUT0=";
  };
  nativeBuildInputs = [
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
