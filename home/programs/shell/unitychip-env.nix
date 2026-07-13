{pkgs, ...}: let
  pkgsOld = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
    sha256 = "1f5d2g1p6nfwycpmrnnmc2xmcszp804adp16knjvdkj8nz36y1fg";
  }) {system = "x86_64-linux";};

  pkgsLegacy = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-21.11.tar.gz";
    sha256 = "04ffwp2gzq0hhz7siskw6qh9ys8ragp7285vi1zh8xjksxn1msc5";
  }) {system = "x86_64-linux";};

  requirementsTxt = ../../../pkgs/external-packages/requirements.txt;
  ueRuntimeLibs = with pkgsOld; [
    zlib
    libxml2
    expat
    freetype
    fontconfig
    graphite2
    e2fsprogs
    keyutils
    util-linux
    numactl
    harfbuzz
    krb5
    dbus
    alsa-lib
    libxslt
    sqlite
    glib
    nspr
    nss
    libselinux
    pcre2
    libsepol
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libXft
    xorg.libXScrnSaver
    xorg.libXmu
    xorg.libxcb
    libxkbcommon
    xorg.xcbutil
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    stdenv.cc.cc.lib
  ] ++ [pkgsLegacy.openssl_1_1];
  ueRuntimeLibraryPath = pkgsOld.lib.makeLibraryPath ueRuntimeLibs;
  ueVerdiBundledLibraryPath = "$VERDI_HOME/platform/linux64/lib/tbb:$VERDI_HOME/platform/linux64/lib/Qt5/lib:$VERDI_HOME/platform/linux64/lib/zebu:$VERDI_HOME/etc/lib/libstdc++/linux64";
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
        (if pkgsTarget ? libx11 then pkgsTarget.libx11 else pkgsTarget.xorg.libX11)
        (if pkgsTarget ? libxcomposite then pkgsTarget.libxcomposite else pkgsTarget.xorg.libXcomposite)
        (if pkgsTarget ? libxext then pkgsTarget.libxext else pkgsTarget.xorg.libXext)
        (if pkgsTarget ? libxfixes then pkgsTarget.libxfixes else pkgsTarget.xorg.libXfixes)
        (if pkgsTarget ? libxt then pkgsTarget.libxt else pkgsTarget.xorg.libXt)
        (if pkgsTarget ? libxtst then pkgsTarget.libxtst else pkgsTarget.xorg.libXtst)
        (if pkgsTarget ? libxft then pkgsTarget.libxft else pkgsTarget.xorg.libXft)
        (if pkgsTarget ? libxrender then pkgsTarget.libxrender else pkgsTarget.xorg.libXrender)
        (if pkgsTarget ? libxscrnsaver then pkgsTarget.libxscrnsaver else pkgsTarget.xorg.libXScrnSaver)
        (if pkgsTarget ? libxcursor then pkgsTarget.libxcursor else pkgsTarget.xorg.libXcursor)
        (if pkgsTarget ? libxdamage then pkgsTarget.libxdamage else pkgsTarget.xorg.libXdamage)
        (if pkgsTarget ? libxdmcp then pkgsTarget.libxdmcp else pkgsTarget.xorg.libXdmcp)
        (if pkgsTarget ? libxau then pkgsTarget.libxau else pkgsTarget.xorg.libXau)
        (if pkgsTarget ? libxi then pkgsTarget.libxi else pkgsTarget.xorg.libXi)
        (if pkgsTarget ? libxinerama then pkgsTarget.libxinerama else pkgsTarget.xorg.libXinerama)
        (if pkgsTarget ? libxrandr then pkgsTarget.libxrandr else pkgsTarget.xorg.libXrandr)
        (if pkgsTarget ? libsm then pkgsTarget.libsm else pkgsTarget.xorg.libSM)
        (if pkgsTarget ? libice then pkgsTarget.libice else pkgsTarget.xorg.libICE)
        (if pkgsTarget ? libxcb then pkgsTarget.libxcb else pkgsTarget.xorg.libxcb)
        (if pkgsTarget ? libxmu then pkgsTarget.libxmu else pkgsTarget.xorg.libXmu)
        libxkbcommon
        (if pkgsTarget ? xcbutil then pkgsTarget.xcbutil else pkgsTarget.xorg.xcbutil)
        (if pkgsTarget ? xcbutilwm then pkgsTarget.xcbutilwm else pkgsTarget.xorg.xcbutilwm)
        (if pkgsTarget ? xcbutilimage then pkgsTarget.xcbutilimage else pkgsTarget.xorg.xcbutilimage)
        (if pkgsTarget ? xcbutilkeysyms then pkgsTarget.xcbutilkeysyms else pkgsTarget.xorg.xcbutilkeysyms)
        (if pkgsTarget ? xcbutilrenderutil then pkgsTarget.xcbutilrenderutil else pkgsTarget.xorg.xcbutilrenderutil)

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
        libxml2
        expat
        harfbuzz
        graphite2
        e2fsprogs
        keyutils
        glibc
        libxcrypt
        ncurses5
        libxcrypt-legacy
        krb5
        dbus
        alsa-lib
        libxslt
        sqlite
        numactl
        util-linux
        nspr
        nss
        libselinux
        pcre2
        libsepol
        elfutils
        tcsh
        pkgsLegacy.openssl_1_1

        # GLib for Qt and other tools
        glib

        # Tools
        bc
        time
        lcov
        pkgs.tmux

        # Shell
        bash
        pkgs.fish

        # User requested
        cmake
        python312
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
        (writeShellScriptBin "verdi" ''
          exec env \
            PATH="$VERDI_HOME/bin:$PATH" \
            LD_LIBRARY_PATH="$UE_VERDI_LD_LIBRARY_PATH" \
            "$VERDI_HOME/bin/verdi" "$@"
        '')
        (writeShellScriptBin "novas" ''
          exec env \
            LD_LIBRARY_PATH="$UE_VERDI_LD_LIBRARY_PATH" \
            "$VERDI_HOME/platform/LINUXAMD64/bin/Novas" "$@"
        '')
      ]);
      profile = ''
        export VERDI_HOME=$HOME/EDAHome/verdi/W-2024.09-SP1
        export VCS_HOME=$HOME/EDAHome/vcs/W-2024.09-SP1
        export UVMC_HOME=$HOME/EDAHome/uvmc
        export UVM_HOME=$VCS_HOME/etc/uvm
        export PATH=$VCS_HOME/bin:$PATH

        # Do not set a global LD_LIBRARY_PATH in the shell. Mixing old FHS
        # runtime libs into every command breaks newer host tools like swig and
        # flatpak. Only Verdi itself gets the extra loader path.
        export UE_VERDI_LD_LIBRARY_PATH=${ueVerdiBundledLibraryPath}:${ueRuntimeLibraryPath}

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
