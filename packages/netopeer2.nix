{
  cmake,
  fetchFromGitHub,
  libnetconf2,
  libssh,
  libyang,
  openssl,
  pkg-config,
  stdenv,
  sysrepo
}:
stdenv.mkDerivation (finalAttrs: {
  name = "netopeer2";
  version = "v2.4.5";
  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "netopeer2";
    rev = finalAttrs.version;
    hash = "sha256-Efnvl4Uu6HR8JLNUIBZPgyO5m8dMGyvDl8T2OCpqIIA=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libyang
    libnetconf2
    sysrepo
    libssh
    openssl
  ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DNP2_MODULE_DIR=${placeholder "out"}/share/yang/modules/netopeer2"
    "-DLN2_MODULE_DIR=${libnetconf2}/share/yang/modules/libnetconf2"
    "-DNP2_MODULE_OWNER=root"
    "-DNP2_MODULE_GROUP=root"
    "-DNP2_MODULE_PERMS=600"
  ];
  outputs = [ "out" ];
})
