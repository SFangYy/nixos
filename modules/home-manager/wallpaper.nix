{ config, lib, ... }:
with lib;
with types;
with config.lib.wallpapers;
let
  cfg = config.wallpapers;
  wallpaper = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "Name of the wallpaper";
      };
      baseImageName = mkOption {
        type = nullOr str;
        description = "Name of the base image";
        default = null;
      };
      path = mkOption {
        type = nullOr path;
        description = "Path to the wallpaper, ${pkgs.wallpapers}/name by default";
        default = null;
      };
      convertMethod = mkOption {
        type = str;
        description = "Method to convert the wallpaper (gonord, lutgen, none)";
        default = "gonord";
      };
      effects = mkOption {
        type = nullOr (
          listOf (submodule {
            options = {
              name = mkOption {
                type = nullOr str;
                description = "Name of the effect to apply";
                default = null;
              };
              passthru = mkOption {
                type = attrs;
                description = "Extra arguments to pass to the effect";
                default = { };
              };
            };
          })
        );
        description = "List of effects to apply to the wallpaper";
        default = null;
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
      wallpapers = map getWallpaper cfg;
      wallpapersWithEffects = map applyEffects wallpapers;
      generatedWallpapers = map generateWallpaper wallpapersWithEffects;
      normalWallpapers = map setWallpaper generatedWallpapers |> builtins.listToAttrs;
      blurredWallpapers = map blurWallpaper generatedWallpapers |> builtins.listToAttrs;
    in
    {
      home.file = normalWallpapers // blurredWallpapers;
    };
}
