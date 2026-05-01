{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    codex
    nixfmt
    texlab
    nodePackages.prettier
    julia-bin
  ];
}
