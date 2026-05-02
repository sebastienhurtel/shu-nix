{
  pkgs,
  lib,
  ...
}:
with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "pyang";
  version = "2.7.1";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "mbj4668";
    repo = pname;
    rev = version;
    hash = "sha256-u43t/lacWgCtXAoPHGiAuSKQuwOjBNy09FHsEooPv1k=";
  };
  # setuptools is not needed if version > 2.6.1
  propagatedBuildInputs =
    if lib.versionOlder version "2.6.1" then
      [ lxml ]
    else
      [
        lxml
        setuptools
      ];
}
