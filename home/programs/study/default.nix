{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pspp
    zotero
    obsidian
    verilator
    swig
    verible
    nemu
    onedrivegui
    remmina
    act
    clash-verge 
  ];
}
