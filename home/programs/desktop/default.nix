{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./mako.nix
    ./niri
    ./swhkd.nix
    ./waydroid.nix
    # ./dms.nix
    ./noctalia.nix
  ];
  home.packages = with pkgs; [
    awww
    swaybg
    kanshi
    wlsunset
    xwayland-satellite
    wmname
    grim
    slurp
    wf-recorder
    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
    # RustDesk 鼠标偏移修复脚本
    (writeShellScriptBin "rustdesk-fix" ''
      #!/usr/bin/env bash
      # RustDesk 鼠标偏移修复脚本
      # 使用 X11 后端并设置正确的缩放因子
      export GDK_BACKEND=x11
      export QT_QPA_PLATFORM=xcb
      export GDK_SCALE=1.5
      export QT_SCALE_FACTOR=1.5
      exec rustdesk "$@"
    '')
    inputs.hexecute.packages.${system}.default
    halley
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
    STEAM_FORCE_DESKTOPUI_SCALING = "2";
    # Steam 在 niri/xwayland-satellite 下黑屏修复
    DISPLAY = ":0";                            # 确保 Steam 连接到 xwayland-satellite
    STEAM_DISABLE_BROWSER_SHADER_CACHE = "1"; # 禁用 CEF shader 缓存（减少黑屏）
  };

  # 覆盖 Steam 的 .desktop 入口，强制禁用 CEF GPU 加速以修复黑屏
  xdg.desktopEntries.steam = {
    name = "Steam";
    comment = "Application for managing and playing games on Steam";
    exec = "steam -cef-disable-gpu %U";
    icon = "steam";
    terminal = false;
    categories = [ "Network" "FileTransfer" "Game" ];
    mimeType = [
      "x-scheme-handler/steam"
      "x-scheme-handler/steamlink"
    ];
  };

  services.wl-clip-persist.enable = true;
}
