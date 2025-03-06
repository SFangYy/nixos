{ config, lib, ... }:
let
  matugenOptions = lib.types.submodule {
    options = {
      image = lib.mkOption {
        type = lib.types.either lib.types.str lib.types.path;
        description = "Path to the image";
      };
      scheme = lib.mkOption {
        type = lib.types.str;
        description = "The material you scheme to use";
        default = "scheme-tonal-spot";
      };
    };
  };

  colorScheme = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the color scheme";
      };
      isDefault = lib.mkOption {
        type = lib.types.bool;
        description = "Whether the color scheme is the default";
        default = false;
      };
      polarity = lib.mkOption {
        type = lib.types.enum [
          "dark"
          "light"
        ];
        description = "Polarity of the color scheme (dark or light)";
        default = "dark";
      };
      matugen = lib.mkOption {
        type = lib.types.nullOr matugenOptions;
        description = "Matugen options";
        default = null;
      };
    };
  };

in
{
  options.colorSchemes = lib.mkOption {
    type = lib.types.listOf (lib.types.either colorScheme lib.types.str);
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
