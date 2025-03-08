{ pkgs, ... }:
let
  swhkd = import ../../pkgs/swhkd/swhkd.nix {
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
  systemd.packages = [ swhkd ];
}
