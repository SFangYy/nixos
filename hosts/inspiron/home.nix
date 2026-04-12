{ pkgs, ... }:
{
  monitors = {
    # 使用显示器序列号匹配，避免 DP 端口名称变化导致配置失效
    "Dell Inc. DELL U2720Q G3LCZG3" = {
      scale = 2.0;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 59.98;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 270;
    };
    "Dell Inc. DELL U2723QE 6JJBCP3" = {
      isMain = true;
      scale = 2.0;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 59.98;
      };
      position = {
        x = 1080;
        y = 0;
      };
      rotation = 0;
      focus-at-startup = true;
    };
  };
  stylix.cursor = {
    package = pkgs.graphite-cursors;
    name = "graphite-dark";
    size = 32;
  };
  home.stateVersion = "23.11";
}
