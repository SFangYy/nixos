{
  pkgs,
  config,
  ...
}:
let
  edenfetch = pkgs.callPackage ../../../pkgs/edenfetch.nix { };
in
{
  home.packages = with pkgs; [
    cmatrix
    cbonsai
    edenfetch
  ];
  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.jsonc;
  home.file."Pictures/face.jpg".source = config.lib.wallpapers.goNord {
    name = "face";
    path = pkgs.fetchurl {
      name = "face.jpg";
      url = "https://avatars.githubusercontent.com/EdenQwQ";
      sha256 = "1hxl459l3ni5yaj72dngy9wx9rd1yvb85v31nibv5mih4mp1p6cp";
    };
  };
}
