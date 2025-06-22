{ pkgs, ... }:
{
  inherit (pkgs.callPackage ./R.nix { }) myR myRstudio;
  zju-connect = pkgs.callPackage ./zju-connect.nix { };
  swhkd = pkgs.callPackage ./swhkd.nix { };
  kose-font = pkgs.callPackage ./fonts/kose.nix { };
  hugmetight-font = pkgs.callPackage ./fonts/hugmetight.nix { };
  custom-colorschemes = pkgs.callPackage ./customColorSchemes { };
  hellwm = pkgs.callPackage ./hellwm.nix { };
  wallpapers = pkgs.callPackage ./wallpapers.nix { };
  wechat = pkgs.callPackage ./wechat.nix { };
  maple-mono-variable = pkgs.callPackage ./maple-mono-variable.nix { };
}
