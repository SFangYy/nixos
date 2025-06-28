{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pspp
    zotero
    obsidian
    verilator
    swig
    verible
    nemu
    onedrivegui
    remmina
    clash-verge-rev
  ];

  programs.obsidian = {
    enable = true;
    # 重新定义 package，以修改 desktopItem
    package = pkgs.obsidian.overrideAttrs (oldAttrs: {
      # 重新构建 desktopItem
      desktopItem = pkgs.makeDesktopItem {
        name = oldAttrs.desktopItem.name;
        exec = "${oldAttrs.desktopItem.exec} --gtk-version=3"; # 在这里追加参数
        icon = oldAttrs.desktopItem.icon;
        comment = oldAttrs.desktopItem.comment;
        terminal = oldAttrs.desktopItem.terminal;
        type = oldAttrs.desktopItem.type;
        categories = oldAttrs.desktopItem.categories;
        # 如果 Obsidian 的 desktopItem 还有其他自定义属性，你可能需要在这里手动添加
        # 例如，StartupWMClass = oldAttrs.desktopItem.StartupWMClass;
      };
    });
  };
}
