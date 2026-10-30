{ host, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./beitong-kp70.nix
  ];
  system.stateVersion = "23.11";
  networking.hostName = host;
}
