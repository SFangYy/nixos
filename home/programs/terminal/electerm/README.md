# electerm on macOS

针对本机 electerm 5.7.5 的可重复应用配置，与 `hosts/macos/home.nix`
和 `home/programs/desktop/colorscheme.nix` 的 Everforest 深色主题保持一致。
颜色来源：<https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/everforest.yaml>。

## 应用

在 macOS 终端执行：

```sh
pbcopy < /Users/fy/work/nixos/home/programs/terminal/electerm/apply.js
```

回到 electerm，打开开发者工具（通常为 `⌘⌥I`，也可从菜单中打开），
选择 Console，粘贴并执行。等待出现 `Everforest applied` 后关闭开发者工具。
若控制台要求确认粘贴，请先阅读脚本，再按控制台提示操作。

新建本地标签页，或点击新增的 `macOS · fish` 书签。
已经运行的会话和显式指定 zsh/bash 的旧书签仍使用原来的 shell。
macOS 本地终端由 electerm 自动添加 `--login`，脚本无需重复添加参数。

## 配置内容

- Everforest 终端 ANSI 配色与界面主题，绿色强调色。
- JetBrainsMono Nerd Font，15px；不透明背景、稳定块状光标。
- 本地 shell 使用 `/Users/fy/.nix-profile/bin/fish`。
- 左面板宽 260px，标签页只显示标题，关闭快捷栏和远程监控栏。
- 终端和 SFTP 通过切换使用，避免默认分屏占用空间。
- 回滚缓冲 10000 行；保持现有连接、书签和其他设置。

主题单独保存在 `theme.json`，`apply.js` 内含同一份主题，不依赖联网或文件读取。
路径针对本机用户 fy；用于其他账户时应修改两处 fish 路径。
这些文件不由 Home Manager 自动激活。

## 恢复

首次应用前，脚本将涉及的偏好保存在 electerm 的 localStorage 中，
重复应用不覆盖首次备份。在同一个 Console 执行：

```js
await electermEverforest.restore()
```

若应用已重启，先重新执行 `apply.js` 以注册恢复函数，再运行上述命令。
恢复只涉及脚本修改的设置及新增条目，随后删除备份。
应用和恢复均通过 electerm 自身的数据监听器保存，完成提示前不要退出。

不要将 `theme.json` 作为“全部数据”导入：该入口会替换现有连接列表。

## 验证

已对照本机 app.asar 中的设置字段及 store API；通过 JavaScript 语法检查，
并在模拟 store 上验证应用、重复应用、保留 SSH 条目及恢复。
已实际执行本机 fish 登录模式，版本为 4.2.1。
尚未在 electerm 窗口中执行脚本或进行视觉验收。
