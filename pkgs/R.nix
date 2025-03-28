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
