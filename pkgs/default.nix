{ pkgs, ... }:
{
  swhkd = pkgs.callPackage ./swhkd.nix { };
  hugmetight-font = pkgs.callPackage ./fonts/hugmetight.nix { };
  custom-colorschemes = pkgs.callPackage ./customColorSchemes { };
  wallpapers = pkgs.callPackage ./wallpapers.nix { };
  ue = pkgs.callPackage ./unitychip-env.nix { };
  wechat = pkgs.callPackage ./wechat.nix { };
  mihomo-party = pkgs.callPackage ./mihomo-party.nix { };
}
