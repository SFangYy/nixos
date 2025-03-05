{ pkgs, ... }:
let
  swhkd = import ../../pkgs/swhkd/swhkd.nix {
    inherit (pkgs)
      lib
      rustPlatform
      fetchFromGitHub
      makeWrapper
      pkg-config
      ;
  };
in
{
  environment.systemPackages = [
    swhkd
  ];
  systemd.packages = [ swhkd ];
}
