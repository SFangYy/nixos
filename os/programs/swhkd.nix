{ pkgs, ... }:
let
  swhkd = import ../../pkgs/swhkd.nix {
    inherit (pkgs)
      lib
      rustPlatform
      fetchFromGitHub
      pkg-config
      udev
      ;
  };
in
{
  environment.systemPackages = [
    swhkd
  ];
}
