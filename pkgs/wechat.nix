{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  undmg,
  makeWrapper,

  nss,
  nspr,
  xorg,
  pango,
  zlib,
  atkmm,
  libdrm,
  libxkbcommon,
  xcbutilwm,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  mesa,
  alsa-lib,
  wayland,
  atk,
  qt6,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  cups,
  gtk3,
  libxml2,
  cairo,
  freetype,
  fontconfig,
  vulkan-loader,
  gdk-pixbuf,
  libexif,
  ffmpeg,
  pulseaudio,
  systemd,
  libuuid,
  expat,
  bzip2,
  glib,
  libva,
  libGL,
  libnotify,
}:

let
  pname = "wechat";

  inherit (stdenv.hostPlatform) system;

  src = fetchurl {
    url =
      {
        x86_64-linux = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
        aarch64-linux = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.AppImage";
        x86_64-darwin = "https://dldir1v6.qq.com/weixin/Universal/Mac/WeChatMac_x86_64.dmg";
        aarch64-darwin = "https://dldir1v6.qq.com/weixin/Universal/Mac/WeChatMac_arm64.dmg";
      }
      .${system};
    hash =
      {
        x86_64-linux = "sha256-RX26ArkbAxzdRBLu4HT7v/udnQax5Q/Bgi00hw4RSZA=";
        aarch64-linux = "sha256-OTh4hLeBfbF4bLFyByCIPUxa5OCUMbOjIvEt0qQIHE4=";
        x86_64-darwin = "sha256-We+pyfSHDyplxcgMSdkpH9w6f92sgiG3XHi3yGN6DfA=";
        aarch64-darwin = "sha256-uoCWwHoIiloi/bq6zDN6F6CkED0aTWeEWeyVbTcNboc=";
      }
      .${system};
  };

  meta = {
    description = "Connecting a billion people with calls, chats, and more";
    mainProgram = "wechat";
    homepage = "https://weixin.qq.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  # See #335658
  glibcWithoutHardening = stdenv.cc.libc.overrideAttrs (old: {
    hardeningDisable = (old.hardeningDisable or [ ]) ++ [ "zerocallusedregs" ];
  });

  # Copied from wechat-uos package
  wechat-runtime = with xorg; [
    # Make sure our glibc without hardening gets picked up first
    (lib.hiPrio glibcWithoutHardening)

    stdenv.cc.cc
    stdenv.cc.libc
    pango
    zlib
    xcbutilwm
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    libX11
    libXt
    libXext
    libSM
    libICE
    libxcb
    libxkbcommon
    libxshmfence
    libXi
    libXft
    libXcursor
    libXfixes
    libXScrnSaver
    libXcomposite
    libXdamage
    libXtst
    libXrandr
    libnotify
    atk
    atkmm
    cairo
    at-spi2-atk
    at-spi2-core
    alsa-lib
    dbus
    cups
    gtk3
    gdk-pixbuf
    libexif
    ffmpeg
    libva
    freetype
    fontconfig
    libXrender
    libuuid
    expat
    glib
    nss
    nspr
    libGL
    libxml2
    pango
    libdrm
    mesa
    vulkan-loader
    systemd
    wayland
    pulseaudio
    qt6.qt5compat
    bzip2
  ];

  linux = appimageTools.wrapType2 rec {
    inherit pname src meta;
    version = "4.0.0.30";

    nativeBuildInputs = [ makeWrapper ];

    profile = ''
      export LC_ALL=C.UTF-8
    '';

    extraInstallCommands =
      let
        appimageContents = appimageTools.extractType2 {
          inherit (linux) pname version src;
        };
      in
      ''
        wrapProgram $out/bin/${pname} \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
          --set LD_LIBRARY_PATH "${lib.makeLibraryPath wechat-runtime}"
        install -Dm444 ${appimageContents}/wechat.desktop -t $out/share/applications
        install -Dm444 ${appimageContents}/wechat.png -t $out/share/pixmaps
        substituteInPlace $out/share/applications/wechat.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname src meta;
    version = "4.0.0.5";

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
