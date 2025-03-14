{ pkgs, lib, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../../pkgs/fonts/kose.nix { })
    (pkgs.callPackage ../../../pkgs/fonts/hugmetight.nix { })
  ];
}
