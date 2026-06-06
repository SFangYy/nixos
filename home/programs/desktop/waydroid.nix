{ pkgs, ... }:
let
  waydroidInitGapps = pkgs.writeShellScriptBin "waydroid-init-gapps" ''
    #!/usr/bin/env bash
    set -euo pipefail

    sudo systemctl enable --now waydroid-container

    if [ -e /var/lib/waydroid/waydroid.cfg ]; then
      echo "Waydroid 已初始化，跳过 init。"
      echo "如需重新选择镜像，请先执行: sudo rm -rf /var/lib/waydroid"
      exit 0
    fi

    sudo waydroid init -s GAPPS

    echo
    echo "Waydroid Android 13 GAPPS 镜像已初始化。"
    echo "下一步可执行: waydroid show-full-ui"
  '';

  waydroidInstallLibhoudini = pkgs.writeShellScriptBin "waydroid-install-libhoudini" ''
    #!/usr/bin/env bash
    set -euo pipefail

    workdir="''${XDG_DATA_HOME:-$HOME/.local/share}/waydroid-extra-scripts"

    if [ ! -d "$workdir/.git" ]; then
      git clone https://github.com/casualsnek/waydroid_script "$workdir"
    fi

    if [ ! -d "$workdir/venv" ]; then
      python3 -m venv "$workdir/venv"
    fi

    "$workdir/venv/bin/pip" install -r "$workdir/requirements.txt"

    cd "$workdir"
    sudo "$workdir/venv/bin/python3" main.py install libhoudini
  '';
in
{
  home.packages = [
    waydroidInitGapps
    waydroidInstallLibhoudini
  ];
}
