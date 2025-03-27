{ config, lib, ... }:
with lib;
with types;
with config.lib.wallpapers;
let
  wallpaper = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "Name of the wallpaper";
      };
      path = mkOption {
        type = nullOr path;
        description = "Path to the wallpaper, ${pkgs.wallpapers}/name by default";
        default = null;
      };
      convertMethod = mkOption {
        type = str;
        description = "Method to convert the wallpaper (gonord, lutgen, none)";
        default = "lutgen";
      };
    };
  };
in
{
  options.wallpapers = mkOption {
    type = listOf wallpaper;
    description = "List of wallpapers";
  };

  config =
    let
      wallpapers = map getWallpaper config.wallpapers;
      generatedWallpapers = map generateWallpaper wallpapers;
      normalWallpapers = map setWallpaper generatedWallpapers |> builtins.listToAttrs;
      blurredWallpapers = map blurWallpaper generatedWallpapers |> builtins.listToAttrs;
    in
    {
      home.file = normalWallpapers // blurredWallpapers;
    };
}
