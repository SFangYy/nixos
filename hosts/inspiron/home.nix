{ pkgs, ... }:
{
  programs.llmMemory.enable = true;

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
    # RTK Type-C 扩展屏，放在主 Dell 正下方，水平居中
    # 3840x2400 @ 2.5 -> 逻辑 1536x960；Dell 底边 y=1080，居中 x=1080+(1920-1536)/2=1272
    "Invalid Vendor Codename - RTK Type_C demoset-1" = {
      scale = 2.5;
      mode = {
        width = 3840;
        height = 2400;
        refresh = 59.999;
      };
      position = {
        x = 1272;
        y = 1080;
      };
      rotation = 0;
    };
  };
  stylix.cursor = {
    package = pkgs.graphite-cursors;
    name = "graphite-dark";
    size = 32;
  };
  home.stateVersion = "23.11";
}
