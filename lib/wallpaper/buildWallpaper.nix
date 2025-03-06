{
  pkgs,
  lib,
  config,
  ...
}:
with builtins;
let
  inherit (config.lib.wallpapers) goNord lutgen;

  getWallpaper =
    wallpaper:
    let
      wallpaperPkg = pkgs.fetchurl { inherit (wallpaper) name url sha256; };
    in
    {
      inherit (wallpaper) name convertMethod;
      path = "${wallpaperPkg}";
    };

  getName =
    path:
    baseNameOf path |> match "(.*)\\..*" |> head |> lib.splitString "-" |> tail |> concatStringsSep "-";

  generateWallpaper =
    wallpaper:
    let
      inherit (wallpaper) path convertMethod;
      name = getName path;
      live = (toString path |> match ".*gif$") != null;
      thisWallpaper = { inherit name path live; };
    in
    {
      inherit name live;
      path =
        if lib.strings.hasPrefix name config.lib.stylix.colors.scheme then
          path
        else if convertMethod == "gonord" then
          goNord thisWallpaper
        else if convertMethod == "lutgen" then
          lutgen thisWallpaper
        else
          path;
    };

  setWallpaper =
    wallpaper:
    let
      inherit (wallpaper) name live path;
      ext = if live then ".gif" else ".jpg";
    in
    {
      name = "Pictures/Wallpapers/generated/${name}${ext}";
      value = {
        source = path;
      };
    };

  blurWallpaper =
    wallpaper:
    let
      inherit (wallpaper) name path live;
    in
    if live then
      null
    else
      {
        name = "Pictures/Wallpapers/generated/${name}-blurred.jpg";
        value = {
          source = pkgs.runCommand "${name}-blurred.jpg" { } ''
            ${pkgs.imagemagick}/bin/magick ${path} -blur 0x20 $out
          '';
        };
      };
in
{
  config.lib.wallpapers = {
    inherit
      getWallpaper
      convertWallpaper
      generateWallpaper
      setWallpaper
      blurWallpaper
      ;
  };
}
