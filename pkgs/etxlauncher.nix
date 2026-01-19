{ stdenv, lib, fetchurl, unzip, makeWrapper, autoPatchelfHook, glib, nss, nspr, gtk2, gtk3, atk, at-spi2-atk, cups, dbus, libdrm, expat, alsa-lib, xorg, libxkbcommon, mesa }:

stdenv.mkDerivation rec {
  pname = "etxlauncher";
  version = "12.0.4.7508-SP4";

  src = fetchurl {
    url = "file://${./external-packages/ETXLauncher-${version}-linux-x64.tar.gz}";
    sha256 = "0c8qybkqil8rpykh47ll5fnk8qckkcdk9y7m1drx50ha7y1bgni3";
  };

  nativeBuildInputs = [ unzip makeWrapper autoPatchelfHook ];
  buildInputs = [
    glib
    nss
    nspr
    gtk2
    gtk3
    atk
    at-spi2-atk
    cups
    dbus
    libdrm
    expat
    alsa-lib
    libxkbcommon
    mesa
    xorg.libX11
    xorg.libXext
    xorg.libXtst
    xorg.libXrender
    xorg.libXi
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXrandr
    xorg.libxcb
  ];

  sourceRoot = "etxlauncher_12";

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/{128x128,58x58}/apps

    # Copy the main binary
    cp bin/etxlauncher $out/bin/etxlauncher

    # Copy desktop file
    cp conf/etxlauncher12.desktop.template $out/share/applications/etxlauncher.desktop

    # Copy icons
    cp icons/etxlauncher.128.png $out/share/icons/hicolor/128x128/apps/etxlauncher.png
    cp icons/etxlauncher.58.png $out/share/icons/hicolor/58x58/apps/etxlauncher.png

    # Fix desktop file - replace all template variables
    substituteInPlace $out/share/applications/etxlauncher.desktop \
      --replace "__ETXLAUNCHERHOME__/bin/__LAUNCHBINARY__" "$out/bin/etxlauncher" \
      --replace "__ETXLAUNCHERHOME__/icons/etxlauncher.128.png" "$out/share/icons/hicolor/128x128/apps/etxlauncher.png" \
      --replace "__TERMINAL__" "false" \
      --replace "NoDisplay=true" "NoDisplay=false"

    # Wrap the binary
    wrapProgram $out/bin/etxlauncher \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
  '';

  meta = with lib; {
    description = "ETX Launcher for EDA tools";
    homepage = "https://www.synopsys.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}