{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "ttf-wps-fonts";
  version = "2023-12-06";

  src = fetchFromGitHub {
    owner = "dv-anomaly";
    repo = "ttf-wps-fonts";
    rev = "master";
    sha256 = "sha256-x+grMnpEGLkrGVud0XXE8Wh6KT5DoqE6OHR+TS6TagI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    find . -name '*.ttf' -o -name '*.TTF' | xargs -I{} cp {} $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Symbol fonts required by WPS Office (Symbol, Wingdings, MT Extra, etc.)";
    homepage = "https://github.com/dv-anomaly/ttf-wps-fonts";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
