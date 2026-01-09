{ inputs, pkgs, ... }:
{
  imports = [
    ./tofi.nix
    ./fonts.nix
    ./mako.nix
    ./niri
    ./swhkd.nix
    ./dms.nix
    ./caelestia.nix
    ./noctalia.nix
    # ./scroll
    # ./mango
  ];
  home.packages = with pkgs; [
    swww
    swaybg
    kanshi
    wlsunset
    wayneko
    xwayland-satellite
    wmname
    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
    (inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      buildInputs =
        oldAttrs.buildInputs
        ++ (
          with pkgs.qt6;
          with pkgs.kdePackages;
          [
            qt5compat
            qtpositioning
            kirigami
            syntax-highlighting
          ]
        );
    }))
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk3";
  services.wl-clip-persist.enable = true;
}
