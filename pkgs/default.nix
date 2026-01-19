{ pkgs, ... }:
{
  swhkd = pkgs.callPackage ./swhkd.nix { };
  hugmetight-font = pkgs.callPackage ./fonts/hugmetight.nix { };
  custom-colorschemes = pkgs.callPackage ./customColorSchemes { };
  wallpapers = pkgs.callPackage ./wallpapers.nix { };
  wechat = pkgs.callPackage ./wechat.nix { };
  mihomo-party = pkgs.callPackage ./mihomo-party.nix { };
  etxlauncher = pkgs.callPackage ./etxlauncher.nix { };
}
