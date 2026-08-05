{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    texlab
    prettier
  ];
}
