{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python312
    python312Packages.pip
    python312Packages.virtualenv
    python312Packages.numpy
    python312Packages.matplotlib
    python312Packages.pandas
    black
    conda
  ];
}
