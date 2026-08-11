{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./mako.nix
    ./niri
    ./waydroid.nix
    ./noctalia.nix

    ./gnome.nix
    ./fcitx5.nix
    ./dconf.nix
    ./stylix.nix
    ./wallpaper.nix
    ./colorscheme.nix
  ];
  desktopShell = "noctalia-shell";
  home.packages = with pkgs; [
    awww
    swaybg
    kanshi
    wlsunset
    xwayland-satellite
    wmname
    grim
    slurp
    satty
    wf-recorder
    kando
    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
    # halley
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  services.wl-clip-persist.enable = true;
}
