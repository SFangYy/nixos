pkgs:
let
  rPkgs = with pkgs.rPackages; [
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
in
{
  myR = pkgs.rWrapper.override {
    packages = rPkgs;
  };
  myRstudio = pkgs.rstudioWrapper.override {
    packages = rPkgs;
  };
}
