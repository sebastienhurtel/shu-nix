{ pkgs }:
pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "netopeer2";
  version = "v2.4.5";
  src = pkgs.fetchFromGitHub {
    owner = "CESNET";
    repo = "netopeer2";
    rev = finalAttrs.version;
    hash = "sha256-Efnvl4Uu6HR8JLNUIBZPgyO5m8dMGyvDl8T2OCpqIIA=";
  };
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];
  buildInputs = [
    pkgs.libyang
    pkgs.libnetconf2
    pkgs.sysrepo
    pkgs.libssh
    pkgs.openssl
  ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DNP2_MODULE_DIR=${placeholder "out"}/share/yang/modules/netopeer2"
    "-DLN2_MODULE_DIR=${pkgs.libnetconf2}/share/yang/modules/libnetconf2"
    "-DNP2_MODULE_OWNER=root"
    "-DNP2_MODULE_GROUP=root"
    "-DNP2_MODULE_PERMS=600"
  ];
  outputs = [ "out" ];
})
