{
  pkgs,
  config,
  lib,
  ...
}:
let
  convertColorScheme =
    colorScheme:
    if builtins.typeOf colorScheme == "string" then
      {
        name = colorScheme;
        isDefault = false;
        polarity = "dark";
        matugen = null;
      }
    else
      colorScheme;

  wallpapers = config.wallpapers;

  matugenToBase16 =
    colorScheme:
    let
      inherit (colorScheme) name matugen polarity;
      inherit (matugen) scheme;
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
        polarity
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
      inherit polarity;
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
  lib.colorScheme = {
    inherit convertColorScheme buildColorScheme buildSpecialisation;
  };
}
