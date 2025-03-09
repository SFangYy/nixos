pkgs:
pkgs.rstudioWrapper.override {
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
}
