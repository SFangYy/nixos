{ inputs, pkgs, ... }:
{
  imports = [
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.libreoffice
    inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.onlyoffice-desktopeditors
  ];
}
