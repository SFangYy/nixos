{
  pkgs,
  inputs,
  ...
}:
let
  pkgsOld = import inputs.nixpkgs-eda-23 { system = "x86_64-linux"; };

  pkgsLegacy = import inputs.nixpkgs-eda-21 { system = "x86_64-linux"; };

  # Pin the schema-compatible etcd runtime for UCSwarm in UE only.
  ueEtcd = pkgs.stdenvNoCC.mkDerivation {
    pname = "ue-etcd";
    version = "3.7.2";
    src = pkgs.fetchurl {
      url = "https://github.com/etcd-io/etcd/releases/download/v3.7.2/etcd-v3.7.2-linux-amd64.tar.gz";
      hash = "sha256-OjZ5vFGk7p0wvM6h2nzU/mLG/B0soSVQaNLFO/MCYTU=";
    };
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      install -Dm755 etcd "$out/bin/etcd"
      install -Dm755 etcdctl "$out/bin/etcdctl"
      install -Dm755 etcdutl "$out/bin/etcdutl"
      runHook postInstall
    '';
    meta.platforms = [ "x86_64-linux" ];
  };

  ueRuntimeLibs =
    with pkgsOld;
    [
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
      ncurses5
      gmp
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
    ]
    ++ [ pkgsLegacy.openssl_1_1 ];
  ueRuntimeLibraryPath = pkgsOld.lib.makeLibraryPath ueRuntimeLibs;
  ueVerdiBundledLibraryPath = "$VERDI_HOME/platform/linux64/lib/tbb:$VERDI_HOME/platform/linux64/lib/Qt5/lib:$VERDI_HOME/platform/linux64/lib/zebu:$VERDI_HOME/etc/lib/libstdc++/linux64";
in
{
  # System-wide UnityChip EDA environment so every local account (including
  # the shared `eda` account) enters the same FHS shell. A home-manager
  # package would only be visible to its own user.
  environment.systemPackages = [
    (pkgsOld.buildFHSEnv {
      name = "ue";
      targetPkgs =
        pkgsTarget:
        (with pkgsTarget; [
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
          (
            if pkgsTarget ? xcbutilrenderutil then
              pkgsTarget.xcbutilrenderutil
            else
              pkgsTarget.xorg.xcbutilrenderutil
          )

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
          # Verilator FST tracing compiles and links against external LZ4.
          (pkgs.lib.getDev pkgs.lz4)
          (pkgs.lib.getLib pkgs.lz4)
          libxml2
          expat
          harfbuzz
          graphite2
          e2fsprogs
          keyutils
          glibc
          libxcrypt
          ncurses5
          gmp
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
          (pkgs.lib.hiPrio ueEtcd)
          bc
          time
          lcov

          # Shell
          bash
          pkgs.fish

          # User requested
          cmake
          pkg-config
          bison
          flex
          gperf
          python312
          pkgs.uv
          git

          # FM-Agent runtime and plugin tooling
          bun
          unzip
          curl

          # Use the selected current Verilator with its FST development dependencies.
          pkgs.verilator
          verible
          pkgs.swig
          pkgs.gcc.cc.lib
          (runCommand "gmake-symlink" { } ''
            mkdir -p $out/bin
            ln -s ${gnumake}/bin/make $out/bin/gmake
          '')
          (writeShellScriptBin "ue-setup-python" (builtins.readFile ./setup-eda-python.sh))
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
        # Keep the platform launcher independent of the host's older etcd.
        export ETCD_BIN=${ueEtcd}/bin/etcd
        export PATH=${ueEtcd}/bin:$PATH

        # Export compiler paths so managed process workers inherit FST dependencies.
        export CPATH=${pkgs.lib.getDev pkgs.lz4}/include:${pkgs.lib.getDev pkgs.zlib}/include''${CPATH:+:$CPATH}
        export LIBRARY_PATH=${pkgs.lib.getLib pkgs.lz4}/lib:${pkgs.lib.getLib pkgs.zlib}/lib''${LIBRARY_PATH:+:$LIBRARY_PATH}

        # EDA installs are shared under /opt/eda so every account sees the
        # same VCS/Verdi. Fall back to a per-user install until the shared
        # tree exists; UE_EDA_ROOT wins when a user wants a private one.
        export UE_EDA_ROOT="''${UE_EDA_ROOT:-/opt/eda}"
        if [ ! -d "$UE_EDA_ROOT/vcs" ] && [ -d "$HOME/EDAHome/vcs" ]; then
          export UE_EDA_ROOT="$HOME/EDAHome"
        fi
        export VERDI_HOME="''${VERDI_HOME:-$UE_EDA_ROOT/verdi/W-2024.09-SP1}"
        export VCS_HOME="''${VCS_HOME:-$UE_EDA_ROOT/vcs/W-2024.09-SP1}"
        export UVMC_HOME="''${UVMC_HOME:-$UE_EDA_ROOT/uvmc}"
        export UVM_HOME="''${UVM_HOME:-$VCS_HOME/etc/uvm}"
        export PATH="$VCS_HOME/bin:$HOME/.local/bin:$PATH"

        # Keep binary, templates, headers and xspcomm from the same installation.
        export PICKER_PREFIX="''${PICKER_PREFIX:-$HOME/.local}"
        if [ ! -x "$PICKER_PREFIX/bin/picker" ] && [ -x "$UE_EDA_ROOT/picker/bin/picker" ]; then
          export PICKER_PREFIX="$UE_EDA_ROOT/picker"
        fi
        export PATH="$PICKER_PREFIX/bin:$PATH"
        export CMAKE_PREFIX_PATH="$PICKER_PREFIX''${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"

        # Site-specific license server/file settings stay outside the Nix store.
        if [ -r /etc/eda/license.sh ]; then
          . /etc/eda/license.sh
        fi

        # Picker installs its Python bindings as support files rather than as a
        # package in each virtual environment. Make them importable inside the
        # UE development shell while leaving the rest of the user session
        # untouched.
        export PICKER_PYTHON_SUPPORT="$PICKER_PREFIX/share/picker/python"
        if [ -d "$PICKER_PYTHON_SUPPORT/xspcomm" ]; then
          case ":''${PYTHONPATH-}:" in
            *":$PICKER_PYTHON_SUPPORT:"*) ;;
            *) export PYTHONPATH="$PICKER_PYTHON_SUPPORT''${PYTHONPATH:+:$PYTHONPATH}" ;;
          esac
        fi

        # Do not set a global LD_LIBRARY_PATH in the shell. Mixing old FHS
        # runtime libs into every command breaks newer host tools like swig and
        # flatpak. Only Verdi itself gets the extra loader path.
        export UE_VERDI_LD_LIBRARY_PATH=${ueVerdiBundledLibraryPath}:${ueRuntimeLibraryPath}

        # Qt platform settings for GUI applications on Wayland
        export QT_QPA_PLATFORM=xcb
        export QT_XCB_GL_INTEGRATION=xcb_glx

        # Setup uv Python environment
        export UV_CACHE_DIR="''${UV_CACHE_DIR:-$HOME/.cache/uv}"
        # A dedicated Python 3.12 environment for the shared EDA account.
        # Setup is explicit: entering UE never installs packages over the network.
        export UE_PYTHON=${pkgs.python312}/bin/python3
        # Keep the UE Python environment beside the work tree so it is the
        # same environment used by Picker/CMake and visible as
        # $HOME/work/.venv (override with UE_PYTHON_ENV when needed).
        export UE_PYTHON_ENV="''${UE_PYTHON_ENV:-$HOME/work/.venv}"
        if [ -f "$UE_PYTHON_ENV/bin/activate" ]; then
          . "$UE_PYTHON_ENV/bin/activate"
        fi

        # UCAgent is optional: accounts without a checkout just get the plain
        # VCS/Verdi tooling. The preparation script skips cleanly in that case
        # and still refuses to run against a broken checkout.
        export UCAGENT_ROOT="''${UCAGENT_ROOT:-$HOME/work/XSV/repos/UCAgent}"
        # Picker's Python bindings and the VCS Python extension are built for
        # Python 3.12 in this UE. Keep UCAgent on the same ABI; using Python
        # 3.13 here creates a second UCAgent venv and makes `which ucagent`
        # disagree with the interpreter used by Picker/CMake.
        export UCAGENT_PYTHON="''${UCAGENT_PYTHON:-$UE_PYTHON}"
        export UCAGENT_WHEEL_RPATH="${pkgs.lib.getLib pkgs.stdenv.cc.cc}/lib64:${pkgs.lib.getLib pkgs.stdenv.cc.cc}/lib:${pkgs.lib.getLib pkgs.zlib}/lib"
        export UCAGENT_PATCHELF=${pkgs.patchelf}/bin/patchelf
        if [ "''${USER:-}" != eda ] || [ "''${UCAGENT_REQUIRED:-}" = 1 ]; then
          source ${./prepare-ucagent-env.sh} || {
            echo "UCAgent environment preparation failed; refusing to use a stale installation." >&2
            exit 1
          }
        fi
      '';
      # Accounts without a ~/work directory still get a usable shell.
      runScript = pkgs.writeShellScript "ue-shell" ''
        if [ "$#" -gt 0 ]; then
          exec "$@"
        fi
        cd "$HOME/work" 2>/dev/null || cd "$HOME"
        exec fish
      '';
    })
  ];
}
