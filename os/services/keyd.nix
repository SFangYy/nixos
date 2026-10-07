{
  ...
}: {
  # 底层按键重排（input 层，对 Wayland/TTY 全局生效；niri 的 xkb 选项保持干净）：
  # 物理 左Ctrl -> Alt，左Alt -> Super(niri 快捷键)，左Win -> Ctrl(复制粘贴等)
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings.main = {
        leftcontrol = "leftalt";
        leftalt = "leftmeta";
        leftmeta = "leftcontrol";
      };
    };
  };
}
