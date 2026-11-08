{
  config,
  lib,
  pkgs,
  ...
}:
let
  fixedLicenseFile = "IC2026_FORMAL.BOSC";
  fixedLicenseSource = "${config.home.homeDirectory}/.config/nixos/docs/${fixedLicenseFile}";
  formalHome = "${config.home.homeDirectory}/EDAHome/HimaFormal";
  formalLicensePath = "${formalHome}/${fixedLicenseFile}";
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

  # HimaFormal client commands are provided by the system-wide UE environment.
}
