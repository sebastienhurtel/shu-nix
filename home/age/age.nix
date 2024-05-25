{ config, ... }:

{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ecdsa_age" ];
}
