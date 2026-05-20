{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    codex
    nixfmt
    texlab
    prettier
    julia-bin
  ];
}
