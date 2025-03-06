{ config, lib, ... }:
with config.lib.wallpapers;
let
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
