{ pkgs }:

pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "sysrepo";
  version = "v3.7.11";
  src = pkgs.fetchFromGitHub {
    owner = "sysrepo";
    repo = "sysrepo";
    rev = finalAttrs.version;
    hash = "sha256-v3FXY33PuM4/TXH49M6JBKweIry17TxS2ksIBm9X9wg=";
  };
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];
  buildInputs = with pkgs; [ libyang ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DREPO_PATH=${placeholder "out"}/etc/sysrepo"
  ];
  outputs = [
    "out"
    "dev"
  ];
})
