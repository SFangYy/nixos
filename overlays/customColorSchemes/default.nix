{ pkgs, ... }:
let
  customColorSchemes = pkgs.stdenvNoCC.mkDerivation {
    name = "customColorSchemes";
    src = ./colorSchemes;
    installPhase = ''
      mkdir -p $out/share/themes
      cp *.yaml $out/share/themes
    '';
  };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      base16-schemes = prev.base16-schemes.overrideAttrs (oldAttrs: {
        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/themes/
          install base16/*.yaml $out/share/themes/
          install ${customColorSchemes}/share/themes/*.yaml $out/share/themes/

          runHook postInstall
        '';
      });
    })
  ];
}
