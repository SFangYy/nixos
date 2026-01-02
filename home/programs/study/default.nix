{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # pspp
    zotero
    obsidian
    brave
    vscode
  ];
}
