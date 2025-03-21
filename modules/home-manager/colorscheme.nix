{ config, lib, ... }:
with lib;
with types;
let
  matugenOptions = submodule {
    options = {
      image = mkOption {
        type = either str path;
        description = "Path to the image";
      };
      scheme = mkOption {
        type = str;
        description = "The material you scheme to use";
        default = "scheme-tonal-spot";
      };
    };
  };

  colorScheme = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "Name of the color scheme";
      };
      isDefault = mkOption {
        type = bool;
        description = "Whether the color scheme is the default";
        default = false;
      };
      polarity = mkOption {
        type = enum [
          "dark"
          "light"
        ];
        description = "Polarity of the color scheme (dark or light)";
        default = "dark";
      };
      matugen = mkOption {
        type = nullOr matugenOptions;
        description = "Matugen options";
        default = null;
      };
    };
  };

in
{
  options.colorSchemes = mkOption {
    type = listOf (either colorScheme str);
    description = "List of colorschemes";
  };

  config =
    with config.lib.colorScheme;
    let
      colorSchemes = config.colorSchemes |> map convertColorScheme;
    in
    {
      stylix = {
        enable = true;
        inherit (builtins.filter (c: c.isDefault) colorSchemes |> builtins.head |> buildColorScheme)
          base16Scheme
          polarity
          ;
      };
      specialisation =
        builtins.filter (c: !c.isDefault) colorSchemes |> map buildSpecialisation |> builtins.listToAttrs;
    };
}
