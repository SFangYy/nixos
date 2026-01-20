{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./tofi.nix
    ./fonts.nix
    ./mako.nix
    ./niri
    ./swhkd.nix
    # ./dms.nix
    ./noctalia.nix
  ];
  home.packages = with pkgs; [
    swww
    swaybg
    kanshi
    wlsunset
    xwayland-satellite
    wmname
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
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk3";
  services.wl-clip-persist.enable = true;
}
