{ inputs, pkgs, ... }:
{
  imports = [
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.libreoffice
    inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.onlyoffice-desktopeditors
  ];
}
