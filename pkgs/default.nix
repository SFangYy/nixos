{ pkgs, ... }:
{
  inherit (pkgs.callPackage ./R.nix { }) myR;
  inherit (pkgs.callPackage ./R.nix { }) myRstudio;
  zju-connect = pkgs.callPackage ./zju-connect.nix { };
  swhkd = pkgs.callPackage ./swhkd.nix { };
  kose-font = pkgs.callPackage ./fonts/kose.nix { };
  hugmetight-font = pkgs.callPackage ./fonts/hugmetight.nix { };
  custom-colorschemes = pkgs.callPackage ./customColorSchemes { };
  fiz = pkgs.callPackage ./fiz.nix { };
}
