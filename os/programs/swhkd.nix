{ pkgs, ... }:
let
  swhkd = pkgs.callPackage ../../pkgs/swhkd.nix { };
in
{
  environment.systemPackages = [
    swhkd
  ];
}
