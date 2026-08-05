{
  config,
  lib,
  pkgs,
  ...
}:
let
  pkgsOld = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
    sha256 = "1f5d2g1p6nfwycpmrnnmc2xmcszp804adp16knjvdkj8nz36y1fg";
  }) { system = "x86_64-linux"; };

  pkgsLegacy19 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-19.09.tar.gz";
    sha256 = "157c64220lf825ll4c0cxsdwg7cxqdx4z559fdp7kpz0g6p8fhhr";
  }) { system = "x86_64-linux"; };

  # OpenSSL 1.0.x for legacy EDA tools
  openssl_1_0 = pkgsLegacy19.openssl_1_0_2;

  fixedLicenseFile = "IC2026_FORMAL.BOSC";
  fixedLicenseSource = "${config.home.homeDirectory}/.config/nixos/docs/${fixedLicenseFile}";
  formalHome = "${config.home.homeDirectory}/EDAHome/HimaFormal";
  formalLicensePath = "${formalHome}/${fixedLicenseFile}";
  formalPicker = pkgs.writeShellScriptBin "picker" ''
    set -euo pipefail

    pickerRoot="/home/${config.home.username}/work/test/formal_picker"
    pickerBin="$pickerRoot/build/bin/picker"

    if [ ! -x "$pickerBin" ]; then
      echo "formal picker is not built: $pickerBin" >&2
      echo "Build it with: cd $pickerRoot && make" >&2
      exit 127
    fi

    export LD_LIBRARY_PATH="$pickerRoot/build/lib:$pickerRoot/dependence/xcomm/build/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec "$pickerBin" "$@"
  '';
  formalLicenseServer = pkgs.writeShellScript "formal-license-server" ''
    set -euo pipefail

    LICENSE_FILE=${lib.escapeShellArg formalLicensePath}
    LICENSE_DIR=${lib.escapeShellArg formalHome}
    LMGRD_BIN="$LICENSE_DIR/bin/lmgrd"
    LOG_FILE="$HOME/lmgrd.log"
    STARTUP_PID=""

    mkdir -p "$LICENSE_DIR/tmp"

    if [ ! -x "$LMGRD_BIN" ]; then
      echo "formal license server binary not found: $LMGRD_BIN" >&2
      exit 1
    fi

    if [ ! -f "$LICENSE_FILE" ]; then
      echo "formal license file missing: $LICENSE_FILE" >&2
      exit 1
    fi

    # Refresh the whole FlexNet stack after a license update. Reusing the same
    # license path means old lmgrd/vendor-daemon processes will not pick up new
    # contents on their own.
    stop_existing_license_stack() {
      pkill -f "$LMGRD_BIN" >/dev/null 2>&1 || true
      pkill -f "$LICENSE_DIR/.*/empyrean" >/dev/null 2>&1 || true
      pkill -f "$LICENSE_DIR/.*/lmgrd" >/dev/null 2>&1 || true
      sleep 1
    }

    cleanup() {
      stop_existing_license_stack
      if [ -n "$STARTUP_PID" ] && kill -0 "$STARTUP_PID" >/dev/null 2>&1; then
        kill "$STARTUP_PID" >/dev/null 2>&1 || true
      fi
    }

    trap cleanup INT TERM EXIT

    cd "$LICENSE_DIR"
    stop_existing_license_stack
    "$LMGRD_BIN" -c "$LICENSE_FILE" >> "$LOG_FILE" 2>&1 &
    STARTUP_PID=$!
    sleep 2

    if pgrep -f "lmgrd.*$LICENSE_FILE" >/dev/null 2>&1; then
      echo "formal license server started."
    elif wait "$STARTUP_PID"; then
      echo "formal license server exited immediately."
      exit 1
    else
      echo "formal license server failed to start. Check $LOG_FILE." >&2
      exit 1
    fi

    while pgrep -f "lmgrd.*$LICENSE_FILE" >/dev/null 2>&1; do
      sleep 5
    done

    echo "formal license server stopped unexpectedly. Check $LOG_FILE." >&2
    exit 1
  '';
in
{
  home.activation.formalLicenseLink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${lib.escapeShellArg formalHome}
    if [ ! -f ${lib.escapeShellArg fixedLicenseSource} ]; then
      echo "formal license file missing: ${fixedLicenseFile}" >&2
      exit 1
    fi

    ln -sfn ${lib.escapeShellArg fixedLicenseSource} ${lib.escapeShellArg formalLicensePath}
    ln -sfn ${lib.escapeShellArg formalLicensePath} ${lib.escapeShellArg "${formalHome}/current-license.BOSC"}

    if command -v systemctl >/dev/null 2>&1; then
      systemctl --user try-restart formal-license-server.service >/dev/null 2>&1 || true
    fi
  '';

  systemd.user.services.formal-license-server = {
    Unit = {
      Description = "HimaFormal license server";
      After = [ "default.target" ];
      PartOf = [ "default.target" ];
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3;
      X-Restart-Triggers = [
        formalLicenseServer
        fixedLicenseSource
      ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${formalLicenseServer}";
      Restart = "on-failure";
      RestartSec = 3;
      TimeoutStopSec = 10;
    };
  };

  home.packages = [
    (pkgsOld.buildFHSEnv {
      name = "formal";
      targetPkgs =
        pkgsTarget:
        (with pkgsTarget; [
          coreutils
          gawk
          gnused
          file
          which
          binutils
          # Keep the C++ compiler and libstdc++ ABI consistent inside the FHS env.
          (pkgsOld.lib.hiPrio pkgsOld.gcc)
          gnumake
          time

          # X11 libraries
          (if pkgsTarget ? libx11 then pkgsTarget.libx11 else pkgsTarget.xorg.libX11)
          (if pkgsTarget ? libxext then pkgsTarget.libxext else pkgsTarget.xorg.libXext)
          (if pkgsTarget ? libxt then pkgsTarget.libxt else pkgsTarget.xorg.libXt)
          (if pkgsTarget ? libxft then pkgsTarget.libxft else pkgsTarget.xorg.libXft)
          (if pkgsTarget ? libxrender then pkgsTarget.libxrender else pkgsTarget.xorg.libXrender)
          (if pkgsTarget ? libxscrnsaver then pkgsTarget.libxscrnsaver else pkgsTarget.xorg.libXScrnSaver)
          (if pkgsTarget ? libxcursor then pkgsTarget.libxcursor else pkgsTarget.xorg.libXcursor)
          (if pkgsTarget ? libxdmcp then pkgsTarget.libxdmcp else pkgsTarget.xorg.libXdmcp)
          (if pkgsTarget ? libxau then pkgsTarget.libxau else pkgsTarget.xorg.libXau)
          (if pkgsTarget ? libxi then pkgsTarget.libxi else pkgsTarget.xorg.libXi)
          (if pkgsTarget ? libxrandr then pkgsTarget.libxrandr else pkgsTarget.xorg.libXrandr)
          (if pkgsTarget ? libsm then pkgsTarget.libsm else pkgsTarget.xorg.libSM)
          (if pkgsTarget ? libice then pkgsTarget.libice else pkgsTarget.xorg.libICE)
          (if pkgsTarget ? libxcb then pkgsTarget.libxcb else pkgsTarget.xorg.libxcb)

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
          openssl_1_0

          python312

          # Build and language-binding tools
          cmake
          # Keep generated picker code compatible with the Verilator 5.018 API.
          pkgsOld.verilator
          pkgs.swig
          # Verilator FST tracing compiles fstcpp_writer.cpp, which needs lz4.h.
          pkgs.lz4
          pkgs.lz4.dev
          formalPicker

          # Shell
          bash
          pkgs.fish
          pkgs.uv
        ]);
      profile = ''
        export AVIS_HOME=$HOME/EDAHome/HimaFormal
        # Prefer the formal environment's toolchain over host/user binaries.
        # In particular, the host /usr/bin/swig may be 3.x, while formal
        # requires the Nix-provided SWIG 4.x.
        export FORMAL_PICKER_BIN=${formalPicker}/bin
        export PATH=$FORMAL_PICKER_BIN:${pkgs.swig}/bin:${pkgsOld.verilator}/bin:${pkgs.cmake}/bin:$AVIS_HOME/bin:$PATH

        # Use OpenSSL 1.0 from Nix store first; keep .so.10 compatibility symlinks.
        export OPENSSL_LEGACY_DIR=$HOME/.local/share/openssl-legacy
        mkdir -p $OPENSSL_LEGACY_DIR
        ln -snf ${openssl_1_0.out}/lib/libssl.so.1.0.0 $OPENSSL_LEGACY_DIR/libssl.so.10
        ln -snf ${openssl_1_0.out}/lib/libcrypto.so.1.0.0 $OPENSSL_LEGACY_DIR/libcrypto.so.10
        export LD_LIBRARY_PATH=${openssl_1_0.out}/lib:$OPENSSL_LEGACY_DIR:$LD_LIBRARY_PATH

        # Set temporary directory for FlexNet license manager (lmgrd)
        # lmgrd expects /usr/tmp/.flexlm but NixOS doesn't have /usr/tmp
        export LM_TMP_DIR=$HOME/EDAHome/HimaFormal/tmp
        mkdir -p $LM_TMP_DIR

        # Use the fixed license file managed in docs/IC2026_FORMAL.BOSC.
        export FORMAL_LICENSE_FILE=${formalLicensePath}
        export LM_LICENSE_FILE=$FORMAL_LICENSE_FILE

        # Create ave symlink for HimaFormal tools
        # ave is commonly used in examples but the actual command is FormalMC
        if [ -f "$AVIS_HOME/bin/FormalMC" ] && [ ! -L "$AVIS_HOME/bin/ave" ]; then
          ln -sf FormalMC $AVIS_HOME/bin/ave
        fi

        # Qt platform settings for GUI applications on Wayland
        export QT_QPA_PLATFORM=xcb
        export QT_XCB_GL_INTEGRATION=xcb_glx
      '';
      runScript = "bash -c 'cd ~/work; exec fish'";
    })
  ];
}
