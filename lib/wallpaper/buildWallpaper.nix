{
  pkgs,
  lib,
  config,
  ...
}:
with builtins;
let
  getWallpaper =
    wallpaper:
    let
      wallpaperPkg = pkgs.fetchurl { inherit (wallpaper) name url sha256; };
    in
    {
      inherit (wallpaper) name convertMethod;
      path = "${wallpaperPkg}";
    };

  wallpapers = map getWallpaper config.wallpapers;

  goNord = wallpaper: import ./goNord.nix { inherit pkgs config wallpaper; };

  lutgen = wallpaper: import ./lutgen.nix { inherit pkgs config wallpaper; };

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

  generatedWallpapers = map generateWallpaper wallpapers;

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

  normalWallpapers = map setWallpaper generatedWallpapers |> listToAttrs;
  blurredWallpapers = map blurWallpaper generatedWallpapers |> listToAttrs;

  wallpaper = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the wallpaper";
      };
      url = lib.mkOption {
        type = lib.types.str;
        description = "URL of the wallpaper";
      };
      sha256 = lib.mkOption {
        type = lib.types.str;
        description = "SHA256 of the wallpaper";
      };
      convertMethod = lib.mkOption {
        type = lib.types.str;
        description = "Method to convert the wallpaper (gonord, lutgen, none)";
        default = "lutgen";
      };
    };
  };
in
{
  options.wallpapers = lib.mkOption {
    type = lib.types.listOf wallpaper;
    description = "List of wallpapers";
  };

  config = {
    home.file = normalWallpapers // blurredWallpapers;
  };
}
