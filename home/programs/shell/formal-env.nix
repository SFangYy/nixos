{pkgs, ...}: let
  pkgsOld = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
    sha256 = "1f5d2g1p6nfwycpmrnnmc2xmcszp804adp16knjvdkj8nz36y1fg";
  }) {system = "x86_64-linux";};

  pkgsLegacy19 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-19.09.tar.gz";
    sha256 = "157c64220lf825ll4c0cxsdwg7cxqdx4z559fdp7kpz0g6p8fhhr";
  }) {system = "x86_64-linux";};
in {
  home.packages = [
    (pkgsOld.buildFHSEnv {
      name = "formal";
      targetPkgs = pkgsTarget: (with pkgsTarget; [
        coreutils
        gawk
        gnused
        file
        which
        binutils
        gnumake

        # X11 libraries
        xorg.libX11
        xorg.libXext
        xorg.libXt
        xorg.libXft
        xorg.libXrender
        xorg.libXScrnSaver
        xorg.libXcursor
        xorg.libXdmcp
        xorg.libXau
        xorg.libXi
        xorg.libXrandr
        xorg.libSM
        xorg.libICE
        xorg.libxcb

        # OpenGL libraries
        libGL
        libGLU
        libdrm

        # Fonts
        fontconfig
        freetype

        # Common libraries
        zlib
        zlib.dev
        glibc
        libxcrypt
        ncurses5
        libxcrypt-legacy
        elfutils
        tcsh

        # GLib for Qt and other tools
        glib

        # OpenSSL 1.0.x for legacy EDA tools (libssl.so.10)
        pkgsLegacy19.openssl

        # Shell
        bash
        pkgs.fish
      ]);
      profile = ''
        export AVIS_HOME=$HOME/EDAHome/HimaFormal
        export PATH=$AVIS_HOME/bin:$PATH

        # Create symlinks for OpenSSL 1.0 libraries for legacy EDA tools
        # Some tools expect libssl.so.10 which is OpenSSL 1.0.x
        export OPENSSL_LEGACY_DIR=$HOME/.local/share/openssl-legacy
        mkdir -p $OPENSSL_LEGACY_DIR
        if [ ! -L $OPENSSL_LEGACY_DIR/libssl.so.10 ]; then
          ln -sf ${pkgsLegacy19.openssl.out}/lib/libssl.so.1.0.0 $OPENSSL_LEGACY_DIR/libssl.so.10
        fi
        if [ ! -L $OPENSSL_LEGACY_DIR/libcrypto.so.10 ]; then
          ln -sf ${pkgsLegacy19.openssl.out}/lib/libcrypto.so.1.0.0 $OPENSSL_LEGACY_DIR/libcrypto.so.10
        fi
        export LD_LIBRARY_PATH=$OPENSSL_LEGACY_DIR:$LD_LIBRARY_PATH

        # Set temporary directory for FlexNet license manager (lmgrd)
        # lmgrd expects /usr/tmp/.flexlm but NixOS doesn't have /usr/tmp
        export LM_TMP_DIR=$HOME/EDAHome/HimaFormal/tmp
        mkdir -p $LM_TMP_DIR

        # Set license file path for FlexNet licensing
        export LM_LICENSE_FILE=$HOME/EDAHome/HimaFormal/IC2026-30562-2026011520260131.BOSC

        # Create ave symlink for HimaFormal tools
        # ave is commonly used in examples but the actual command is FormalMC
        if [ -f "$AVIS_HOME/bin/FormalMC" ] && [ ! -L "$AVIS_HOME/bin/ave" ]; then
          ln -sf FormalMC $AVIS_HOME/bin/ave
        fi

        # Qt platform settings for GUI applications on Wayland
        export QT_QPA_PLATFORM=xcb
        export QT_XCB_GL_INTEGRATION=xcb_glx

        # ============================================================
        # LICENSE SERVER AUTO-START CONFIGURATION
        # ============================================================
        # Set to "true" to auto-start the license server, "false" to disable
        START_LICENSE_SERVER="true"

        if [ "$START_LICENSE_SERVER" = "true" ]; then
          LICENSE_FILE="IC2026-30562-2026011520260131.BOSC"
          LICENSE_DIR=$HOME/EDAHome/HimaFormal
          LMGRD_BIN=$LICENSE_DIR/bin/lmgrd

          # Check if license server is already running
          if [ -f "$LMGRD_BIN" ] && [ -f "$LICENSE_DIR/$LICENSE_FILE" ]; then
            if ! pgrep -f "lmgrd.*$LICENSE_FILE" > /dev/null; then
              echo "Starting license server..."
              cd $LICENSE_DIR
              $LMGRD_BIN -c $LICENSE_FILE > /dev/null 2>&1 &
              sleep 2
              if pgrep -f "lmgrd.*$LICENSE_FILE" > /dev/null; then
                echo "License server started successfully."
              else
                echo "Warning: Failed to start license server."
              fi
            else
              echo "License server is already running."
            fi
          fi
        fi
        # ============================================================
      '';
      runScript = "bash -c 'cd ~/work; exec fish'";
    })
  ];
}