{ config, ... }:
{
  age.identityPaths = [
    "${config.home.homeDirectory}/.ssh/id_rsa"
  ];
}
