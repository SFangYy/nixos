{
  rPackages,
  rWrapper,
  rstudioWrapper,
}:
let
  rPkgs = with rPackages; [
    ggplot2
    dplyr
    tidyverse
    bruceR
    afex
    ggpubr
    reshape2
    rmdformats
    see
    languageserver
    styler
    openxlsx
    ez
    multcomp
    rsdmx
    MuMIn
  ];
in
{
  myR = rWrapper.override {
    packages = rPkgs;
  };
  myRstudio = rstudioWrapper.override {
    packages = rPkgs;
  };
}
