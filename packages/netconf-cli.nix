{ pkgs }:
pkgs.stdenv.mkDerivation (finalAttrs: {
  name = "netconf-cli";
  version = "v1";
  src = pkgs.fetchFromGitHub {
    owner = "CESNET";
    repo = "netconf-cli";
    rev = finalAttrs.version;
    hash = "sha256-DEzNt/LMYryusOM2jxTAsTrrEi3ps6gvtXoCy9zfkNI=";
  };
  nativeBuildInputs = with pkgs; [
    boost183
    cmake
    docopt_cpp
    git
    pkg-config
    replxx
    libnetconf2
    libyang-cpp
    libnetconf2-cpp
    libyang
  ];

  outputs = [ "out" ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=/"
  ];
})
