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
    satty
    wf-recorder
    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
    # halley
  ];
  home.file."scripts" = {
    source = ./scripts;
    recursive = true;
  };
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
    STEAM_FORCE_DESKTOPUI_SCALING = "2";
    STEAM_DISABLE_BROWSER_SHADER_CACHE = "1"; # 禁用 CEF shader 缓存（减少黑屏）
  };

  # 覆盖 Steam 的 .desktop 入口，强制禁用 CEF GPU 加速以修复黑屏
  xdg.desktopEntries.steam = {
    name = "Steam";
    comment = "Application for managing and playing games on Steam";
    exec = "env DISPLAY=:0 steam -cef-disable-gpu %U";
    icon = "steam";
    terminal = false;
    categories = [
      "Network"
      "FileTransfer"
      "Game"
    ];
    mimeType = [
      "x-scheme-handler/steam"
      "x-scheme-handler/steamlink"
    ];
  };

  services.wl-clip-persist.enable = true;
}
