{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    zoxide
    gnome-tweaks
    networkmanagerapplet
    wayland-logout
    wl-clipboard
    sd
    socat
    pandoc
    typst
    du-dust
    killall
    htop
    gparted
    gimp
    kdePackages.kdenlive
    tesseract # ocr
    marp-cli
    appimage-run
    audiowaveform
    papers
    nom
    yad
    pcmanfm
    yazi
    ydotool
    jq
    scrcpy
    upscaler
    direnv
    entr
    lutgen
    imagemagick
    ffmpeg
    nurl
    wl-color-picker
    matugen
    (config.lib.misc.addFlags "--wayland-text-input-version=3" "cherry-studio" cherry-studio)
  ];
  imports = [
    ./eye-candy.nix
    ./obs.nix
    ./music.nix
  ];
  programs.thefuck.enable = true;
}
