{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # pspp
    zotero
    obsidian
    brave
    vscode
    inputs.antigravity-nix.packages.x86_64-linux.default
  ];
}
