{
  pkgs,
  config,
  ...
}:
let
  edenfetch = import ../../../pkgs/edenfetch.nix { inherit (pkgs) lib fetchFromGitHub rustPlatform; };
in
{
  home.packages = with pkgs; [
    cmatrix
    cbonsai
    edenfetch
  ];
  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.jsonc;
  home.file."Pictures/face.jpg".source = import ../../../lib/wallpaper/goNord.nix {
    inherit
      pkgs
      config
      ;
    wallpaper = {
      name = "face";
      path = pkgs.fetchurl {
        name = "face.jpg";
        url = "https://avatars.githubusercontent.com/EdenQwQ";
        sha256 = "1hxl459l3ni5yaj72dngy9wx9rd1yvb85v31nibv5mih4mp1p6cp";
      };

    };
  };
}
