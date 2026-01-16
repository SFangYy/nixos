{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, wrapGAppsHook3
, nss
, nspr
, alsa-lib
, openssl
, webkitgtk
, udev
, libglvnd
, mesa
, glib
, gtk3
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, libxcb
, libdrm
, cups
, atk
, pango
, cairo
, gdk-pixbuf
, freetype
, fontconfig
, dbus
, expat
, libxkbcommon
, zlib
, libXScrnSaver
, libXtst
}:

stdenv.mkDerivation rec {
  pname = "mihomo-party";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/mihomo-party-org/clash-party/releases/download/v${version}/clash-party-linux-${version}-amd64.deb";
    hash = "sha256-SCig+Q2YN3LbThig0kXEG6D/ywz7OvsMfWO0Nf5SDvM=";
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

    # Create symlink to bin if it doesn't exist
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
