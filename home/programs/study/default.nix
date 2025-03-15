{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    pspp
    inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.zotero
  ];
}
