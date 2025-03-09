pkgs:
let
  myRstudio = pkgs.rstudioWrapper.override {
    packages = with pkgs.rPackages; [
      ggplot2
      dplyr
      tidyverse
      bruceR
      afex
      ggpubr
      reshape2
      rmdformats
      see
    ];
  };
in
pkgs.symlinkJoin {
  name = "rstudio-wrapped";
  paths = [ myRstudio ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/rstudio --add-flags \
      "--enable-features=UseOzonePlatform --ozone-platform=wayland --use-gl=angle"
  '';
}
