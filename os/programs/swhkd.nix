{ pkgs, ... }:
let
  swhkd = import ../../pkgs/swhkd/swhkd.nix {
    inherit (pkgs)
      lib
      rustPlatform
      fetchFromGitHub
      makeWrapper
      pkg-config
      systemd
      libgcc
      ;
  };
in
{
  environment.systemPackages = [
    swhkd
  ];
  systemd.packages = [ swhkd ];
}
