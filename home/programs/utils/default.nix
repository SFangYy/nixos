{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    gnome-tweaks
    networkmanagerapplet
    wayland-logout
    wl-clipboard
    sd
    socat
    pandoc
    (texliveSmall.withPackages (ps: [
      ps.scheme-medium
      ps.collection-latexextra
      ps.collection-bibtexextra
      ps.ctex
    ]))
    # typst
    dust
    killall
    htop
    gparted
    gimp3
    gtkwave
    inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.kdePackages.kdenlive
    # tesseract # ocr
    # marp-cli
    appimage-run
    # audiowaveform
    # papers
    # nom
    yad
    # pcmanfm
    # ydotool
    jq
    # scrcpy
    direnv
    entr
    lutgen
    matugen
    hellwal
    imagemagick
    ffmpeg
    nurl
    nix-init
    wl-color-picker
    loupe
    showtime
    nautilus
    gnome-disk-utility
    # rustdesk
    etxlauncher
    # xunlei-uos
    remmina
    localsend
    # PiliPlus dependencies
    #mpv
    #libepoxy
    #libayatana-appindicator
    #libayatana-indicator
    #ayatana-ido
    #libdbusmenu
    #android-tools
    tree-sitter
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.agenix
    age
    sops
    openssl
    evtest
    etcd # UCSwarm process backend (make start_all BACKEND=process)
  ];
  imports = [
    ./eye-candy.nix
    ./music.nix
    ./display.nix
    ./action-ring
  ];
  # TUI file manager. The HM wrapper ships the `y` function so quitting
  # drops the calling shell into the directory browsed in yazi.
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.pay-respects.enable = true;
}
