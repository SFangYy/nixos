{pkgs, ...}: let
  pkgsOld = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
    sha256 = "1f5d2g1p6nfwycpmrnnmc2xmcszp804adp16knjvdkj8nz36y1fg";
  }) {system = "x86_64-linux";};

  pkgsLegacy = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-21.11.tar.gz";
    sha256 = "04ffwp2gzq0hhz7siskw6qh9ys8ragp7285vi1zh8xjksxn1msc5";
  }) {system = "x86_64-linux";};

  pkgsLegacy19 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-19.09.tar.gz";
    sha256 = "157c64220lf825ll4c0cxsdwg7cxqdx4z559fdp7kpz0g6p8fhhr";
  }) {system = "x86_64-linux";};

  requirementsTxt = ../../../pkgs/external-packages/requirements.txt;
in {
  home.packages = [
    (pkgsOld.buildFHSEnv {
      name = "ue";
      targetPkgs = pkgsTarget: (with pkgsTarget; [
        coreutils
        gawk
        (pkgsOld.lib.hiPrio pkgsLegacy.pkgsStatic.gnugrep)
        gnused
        file
        which
        binutils
        (pkgsOld.lib.hiPrio pkgsOld.gcc)
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

        # Tools
        bc
        time
        pkgs.tmux

        # Shell
        bash
        pkgs.fish

        # User requested
        cmake
        python311
        pkgs.uv
        git
        pkgs.verilator
        verible
        pkgs.swig
        pkgs.gcc.cc.lib
        (runCommand "gmake-symlink" {} ''
          mkdir -p $out/bin
          ln -s ${gnumake}/bin/make $out/bin/gmake
        '')
      ]);
      profile = ''
        export VERDI_HOME=$HOME/EDAHome/verdi/W-2024.09-SP1
        export VCS_HOME=$HOME/EDAHome/vcs/W-2024.09-SP1
        export UVMC_HOME=$HOME/EDAHome/uvmc
        export UVM_HOME=$VCS_HOME/etc/uvm
        export AVIS_HOME=$HOME/EDAHome/HimaFormal
        export PATH=$VCS_HOME/bin:$VERDI_HOME/bin:$AVIS_HOME/bin:$PATH

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

        # Qt platform settings for GUI applications on Wayland
        export QT_QPA_PLATFORM=xcb
        export QT_XCB_GL_INTEGRATION=xcb_glx

        # Setup uv Python environment
        export UV_CACHE_DIR=$HOME/.cache/uv
        export REQUIREMENTS_TXT="${requirementsTxt}"

        # Auto-setup Python environment if requirements.txt exists
        if [ -f "$REQUIREMENTS_TXT" ]; then
          cd $HOME/work
          if [ ! -d ".venv" ]; then
            echo "Creating uv virtual environment..."
            uv venv
          fi
          source .venv/bin/activate

          if [ ! -f ".venv/.installed" ] || [ "$REQUIREMENTS_TXT" -nt ".venv/.installed" ]; then
            echo "Installing Python dependencies with uv..."
            uv pip install -r "$REQUIREMENTS_TXT" && touch .venv/.installed
          fi
        fi
      '';
      runScript = "bash -c 'cd ~/work; tmux new-session -A -s unitychip fish; exec fish'";
    })
  ];
}
