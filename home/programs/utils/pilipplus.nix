{ pkgs, lib, writeText, appimage-run, mpv, libepoxy, libayatana-appindicator, libayatana-indicator, ayatana-ido, libdbusmenu }:

let
  pilipplus-launcher = pkgs.writeShellScriptBin "pilipplus" ''
    #!/usr/bin/env bash
    # PiliPlus launcher for NixOS
    # 请将 AppImage 文件放在 ~/.local/bin/ 目录下，或修改下面的路径
    APPIMAGE_PATH="''${HOME}/.local/bin/PiliPlus_linux_2.0.1+4775_amd64.AppImage"

    if [ ! -f "$APPIMAGE_PATH" ]; then
      echo "错误: 找不到 PiliPlus AppImage 文件"
      echo "请将 PiliPlus_linux_2.0.1+4775_amd64.AppImage 放在 ~/.local/bin/ 目录下"
      exit 1
    fi

    export LD_LIBRARY_PATH=${lib.makeLibraryPath [mpv libepoxy libayatana-appindicator libayatana-indicator ayatana-ido libdbusmenu]}:$LD_LIBRARY_PATH
    exec appimage-run "$APPIMAGE_PATH" "$@"
  '';

  desktopFile = pkgs.writeText "pilipplus.desktop" ''
    [Desktop Entry]
    Name=PiliPlus
    Comment=B站第三方桌面客户端
    Exec=${pilipplus-launcher}/bin/pilipplus %u
    Icon=pilipplus
    Type=Application
    Categories=Network;Video;
    Terminal=false
    StartupWMClass=PiliPlus
    MimeType=x-scheme-handler/bili;
  '';

in {
  home.packages = [ pilipplus-launcher ];
  xdg.dataFile = {
    "applications/pilipplus.desktop".source = desktopFile;
    "icons/hicolor/512x512/apps/piliplus.png".source = ./piliplus.png;
  };
}