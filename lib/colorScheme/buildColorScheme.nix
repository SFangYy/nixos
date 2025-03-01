{
  pkgs,
  config,
  lib,
  ...
}:
let
  matugenOptions = lib.types.submodule {
    options = {
      image = lib.mkOption {
        type = lib.types.either lib.types.str lib.types.path;
        description = "Path to the image";
      };
      polarity = lib.mkOption {
        type = lib.types.enum [
          "dark"
          "light"
        ];
        description = "Polarity of the color scheme (dark or light)";
        default = "dark";
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
      matugen = lib.mkOption {
        type = lib.types.nullOr matugenOptions;
        description = "Matugen options";
        default = null;
      };
    };
  };

  convertColorScheme =
    colorScheme:
    if builtins.typeOf colorScheme == "string" then
      {
        name = colorScheme;
        isDefault = false;
        matugen = null;
      }
    else
      colorScheme;

  wallpapers = config.wallpapers;

  matugenToBase16 =
    colorScheme:
    let
      inherit (colorScheme) name matugen;
      inherit (matugen) polarity scheme;
      image =
        if builtins.typeOf matugen.image == "path" then
          matugen.image
        else
          pkgs.fetchurl {
            inherit (builtins.filter (wallpaper: wallpaper.name == matugen.image) wallpapers |> builtins.head)
              name
              url
              sha256
              ;
          };
    in
    pkgs.runCommand "${name}.yaml" { buildInputs = [ pkgs.matugen ]; }
      # bash
      ''
        ${pkgs.python3}/bin/python ${./matu2base16.py} ${image} \
        --name ${name} --polarity ${polarity} --type ${scheme} --output $out
      '';

  buildColorScheme =
    colorScheme:
    let
      inherit (colorScheme)
        name
        isDefault
        matugen
        ;
      forceOrDefault = if isDefault then lib.mkDefault else lib.mkForce;
    in
    {
      base16Scheme =
        if matugen != null then
          "${matugenToBase16 colorScheme}"
        else
          forceOrDefault "${pkgs.base16-schemes}/share/themes/${name}.yaml";
      polarity =
        if matugen != null then
          matugen.polarity
        else if builtins.fromJSON config.lib.stylix.colors.base00-dec-r < 0.5 then
          forceOrDefault "dark"
        else
          forceOrDefault "light";
    };

  buildSpecialisation =
    colorScheme:
    let
      inherit (colorScheme) name;
    in
    {
      inherit name;
      value.configuration = {
        stylix = buildColorScheme colorScheme;
        xdg.dataFile."home-manager/specialisation".text = name;
      };
    };
in
{
  options.colorSchemes = lib.mkOption {
    type = lib.types.listOf (lib.types.either colorScheme lib.types.str);
    description = "List of colorschemes";
  };

  config =
    let
      colorSchemes = config.colorSchemes |> map convertColorScheme;
    in
    {
      stylix = {
        enable = true;
      } // (builtins.filter (c: c.isDefault) colorSchemes |> builtins.head |> buildColorScheme);

      specialisation =
        builtins.filter (c: !c.isDefault) colorSchemes |> map buildSpecialisation |> builtins.listToAttrs;
    };
}
