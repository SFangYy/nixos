{ stdenvNoCC, ... }:
stdenvNoCC.mkDerivation {
  name = "custom-colorschemes";
  src = ./colorSchemes;
  installPhase = ''
    mkdir -p $out/share/themes
    cp *.yaml $out/share/themes
  '';
}
