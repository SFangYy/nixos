{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  nss,
  nspr,
  alsa-lib,
  openssl,
  webkitgtk,
  udev,
  libglvnd,
  mesa,
  glib,
  gtk3,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libxcb,
  libdrm,
  cups,
  atk,
  pango,
  cairo,
  gdk-pixbuf,
  freetype,
  fontconfig,
  dbus,
  expat,
  libxkbcommon,
  zlib,
  libXScrnSaver,
  libXtst,
}:

stdenv.mkDerivation rec {
  pname = "mihomo-party";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/mihomo-party-org/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-amd64.deb";
    sha256 = "0jjy91gqigpzlg579bx9f9gshhx1ag4i9wakksn0rz5xpmcv6mak";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    nss
    nspr
    alsa-lib
    openssl
    stdenv.cc.cc.lib
    libglvnd
    mesa
    glib
    gtk3
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libdrm
    cups
    atk
    pango
    cairo
    gdk-pixbuf
    freetype
    fontconfig
    dbus
    expat
    libxkbcommon
    zlib
    udev
    libXScrnSaver
    libXtst
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out
    cp -r opt $out

    # Fix Exec in desktop file
    substituteInPlace $out/share/applications/mihomo-party.desktop \
      --replace "/opt/clash-party/mihomo-party" "$out/bin/mihomo-party"

    # Create symlinks in PATH; configuration storage is redirected by the
    # system-level ~/.config/mihomo-party symlink instead.
    mkdir -p $out/bin
    ln -s "$out/opt/clash-party/mihomo-party" $out/bin/mihomo-party
    ln -s "$out/opt/clash-party/mihomo-party" $out/bin/clash-party

    # Replace bundled mihomo with symlink to system wrapper
    rm -f $out/opt/clash-party/resources/sidecar/mihomo
    ln -s /run/wrappers/bin/mihomo $out/opt/clash-party/resources/sidecar/mihomo

    runHook postInstall
  '';

  meta = with lib; {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/mihomo-party-org/mihomo-party";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
