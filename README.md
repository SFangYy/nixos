# Keybindings Reference

This document summarizes the keybindings for the **Niri** window manager,
**NixVim** (Neovim), **tmux**, and the interactive shell configuration found
in this project.

## Niri Window Manager

These bindings are configured in `home/programs/desktop/niri/default.nix`.

The keyboard layout maps `Caps Lock` to `Escape` and swaps the left `Ctrl` and
left `Alt` keys. The table below uses the logical modifier names from the Niri
configuration.

| Keybinding                                | Action                                     | Description                                          |
| :---------------------------------------- | :----------------------------------------- | :--------------------------------------------------- |
| **Window Management**                     |                                            |                                                      |
| `Super + q` / `Super + w`                 | `close-window`                             | Close the focused window                             |
| `Super + Shift + w`                       | _Script_                                   | Change wallpaper/theme (runs `change-wal-niri`)      |
| `Super + Shift + a`                       | `toggle-overview`                          | Toggle the window overview                           |
| `Super + t`                               | `toggle-column-tabbed-display`             | Toggle tabbed display for the column                 |
| `Super + Shift + Space`                   | `toggle-window-floating`                   | Toggle floating state for the window                 |
| `Super + Space`                           | `switch-focus-between-floating-and-tiling` | Switch focus between floating/tiling                 |
| `Super + f`                               | `maximize-column`                          | Maximize the current column                          |
| `Super + Shift + f`                       | `fullscreen-window`                        | Toggle fullscreen for the window                     |
| `Super + Ctrl + f`                        | `toggle-windowed-fullscreen`               | Toggle windowed fullscreen                           |
| `Super + c`                               | `center-column`                            | Center the current column                            |
| `Super + Comma`                           | `consume-window-into-column`               | Consume window into current column                   |
| `Super + Period`                          | `expel-window-from-column`                 | Expel window from current column                     |
| `Super + r`                               | `switch-preset-column-width`               | Switch between preset column widths                  |
| `Super + [Shift +] -`                     | `set-column-width "-10%"`                  | Decrease column width (Shift: window height)         |
| `Super + [Shift +] =`                     | `set-column-width "+10%"`                  | Increase column width (Shift: window height)         |
| **Navigation**                            |                                            |                                                      |
| `Super + {h, j, k, l}`                    | `focus-*`                                  | Focus column/monitor (h/l) or window/workspace (j/k) |
| `Super + {Left, Right}`                   | `focus-column-*`                           | Focus the column to the left or right                |
| `Super + {Down, Up}`                      | `focus-window-*`                           | Focus the window below or above                      |
| `Super + Shift + {h, j, k, l}`            | `move-*`                                   | Move column/window in direction                      |
| `Super + Ctrl + {arrows/h/j/k/l}`         | `focus-monitor-*`                          | Focus monitor in direction                           |
| `Super + Shift + Ctrl + {arrows/h/j/k/l}` | `move-window-to-monitor-*`                 | Move window to monitor in direction                  |
| `Super + 1-9`                             | `focus-workspace`                          | Focus the corresponding named workspace              |
| `Super + Shift + 1-9`                     | `move-column-to-workspace`                 | Move the current column to that workspace            |
| **Floating Windows**                      |                                            |                                                      |
| `Super + Alt + {h, j, k, l}`              | `move-floating-window`                     | Move floating window precisely                       |
| **Utilities**                             |                                            |                                                      |
| `Super + Return`                          | `kitty`                                    | Open a terminal                                      |
| `Super + Shift + Return`                  | _Script_                                   | Open the floating quick-note terminal                |
| `Super + d`                               | `noctalia`                                 | Toggle the application launcher                      |
| `Super + {o, b, n, e}`                    | _Application_                              | Open Obsidian, Brave, Nautilus, or Hexecute          |
| `Super + x`                               | `noctalia`                                 | Toggle the session menu                              |
| `Super + Shift + b`                       | `noctalia`                                 | Toggle the status bar                                |
| `Super + Shift + m`                       | `switch-to-macos`                          | Run the macOS switching script                       |
| `Super + Alt + r`                         | _Script_                                   | Toggle screen recording                              |
| `Super + s`                               | `grim`, `wl-copy`, `satty`                 | Select an area, copy it, then open Satty             |
| `Super + Ctrl + s`                        | `grim`, `wl-copy`                          | Copy a full-desktop screenshot                       |
| `Super + Alt + s`                         | `grim`, `satty`                            | Select an output and open its screenshot in Satty    |
| `Super + Shift + s`                       | `wshowkeys`                                | Toggle on-screen key display                         |
| `Super + Ctrl + c`                        | _Script_                                   | Pick color and copy Hex code to clipboard            |
| `Super + Alt + c`                         | `wl-color-picker`                          | Open the color picker                                |
| Audio media keys                          | `wpctl`                                    | Change volume or toggle speaker/microphone mute      |
| **Screencasting**                         |                                            |                                                      |
| `Super + Alt + m`                         | `set-dynamic-cast-monitor`                 | Set monitor for dynamic cast                         |
| `Super + Alt + w`                         | `set-dynamic-cast-window`                  | Set window for dynamic cast                          |
| `Super + Alt + n`                         | `clear-dynamic-cast-target`                | Clear dynamic cast target                            |

Named workspaces: `1` coding, `2` browsing, `3` terminal, `4` reading, `5`
music, `6` proxy, `7` general, `8` reference, and `9` scratch. Workspace 5
opens on the main Dell U2723QE output.

---

## Vim / Neovim (NixVim)

These bindings are configured across various files in `home/programs/coding/nixvim/`.

**Leader Key:** `Space`

### General (通用)

| Keybinding   | Mode          | Action             | Description                       |
| :----------- | :------------ | :----------------- | :-------------------------------- |
| `j` / `k`    | Normal        | `gj` / `gk`        | Move by display line (wrap-aware) |
| `jk`         | Insert        | `<Esc>`            | Exit insert mode to normal mode   |
| `<C-s>`      | Insert/Normal | `:w<CR>`           | Save file                         |
| `<C-a>`      | Insert/Normal | `ggVG`             | Select all                        |
| `S`          | Normal        | `:w<CR>`           | Save file                         |
| `Q`          | Normal        | `:bd<CR>`          | Close buffer (Buffer Delete)      |
| `<S-h>`      | Normal        | `:bprevious<CR>`   | Switch to previous buffer         |
| `<S-l>`      | Normal        | `:bnext<CR>`       | Switch to next buffer             |
| `<Esc><Esc>` | Terminal      | `<C-\><C-n>`       | Exit terminal insert mode         |
| `<Leader>Y`  | Visual        | `"+y`              | Copy to system clipboard          |
| `<Leader>D`  | Visual        | `"+x`              | Cut to system clipboard           |
| `<Leader>qq` | Normal        | `:wqa<CR>`         | Quit editor (save and quit all)   |
| `<Leader>o`  | Normal        | `MiniFiles.open()` | Open MiniFiles file explorer      |

### Window Management (窗口管理)

| Keybinding   | Mode   | Action               | Description            |
| :----------- | :----- | :------------------- | :--------------------- |
| `<C-w>h`     | Normal | -                    | Focus left window      |
| `<C-w>j`     | Normal | -                    | Focus window below     |
| `<C-w>k`     | Normal | -                    | Focus window above     |
| `<C-w>l`     | Normal | -                    | Focus right window     |
| `<C-w>w`     | Normal | -                    | Cycle through windows  |
| `<C-Up>`     | Normal | `resize +2`          | Increase window height |
| `<C-Down>`   | Normal | `resize -2`          | Decrease window height |
| `<C-Left>`   | Normal | `vertical resize -2` | Decrease window width  |
| `<C-Right>`  | Normal | `vertical resize +2` | Increase window width  |
| `<Leader>wH` | Normal | `<C-w>H`             | Move window to left    |
| `<Leader>wJ` | Normal | `<C-w>J`             | Move window to bottom  |
| `<Leader>wK` | Normal | `<C-w>K`             | Move window to top     |
| `<Leader>wL` | Normal | `<C-w>L`             | Move window to right   |

### Line Movement (行移动)

| Keybinding | Mode   | Action             | Description         |
| :--------- | :----- | :----------------- | :------------------ |
| `<A-j>`    | Normal | `:m .+1<CR>==`     | Move line down      |
| `<A-k>`    | Normal | `:m .-2<CR>==`     | Move line up        |
| `<A-j>`    | Visual | `:m '>+1<CR>gv=gv` | Move selection down |
| `<A-k>`    | Visual | `:m '<-2<CR>gv=gv` | Move selection up   |

### Tab Management (标签页管理)

| Keybinding           | Mode   | Action        | Description       |
| :------------------- | :----- | :------------ | :---------------- |
| `<Leader><tab><tab>` | Normal | `tabnew`      | New tab           |
| `<Leader><tab>d`     | Normal | `tabclose`    | Close current tab |
| `<Leader><tab>o`     | Normal | `tabonly`     | Close other tabs  |
| `<Leader><tab>l`     | Normal | `tabnext`     | Next tab          |
| `<Leader><tab>h`     | Normal | `tabprevious` | Previous tab      |

### LSP (Language Server Protocol)

| Keybinding   | Mode   | Action                            | Description               |
| :----------- | :----- | :-------------------------------- | :------------------------ |
| `K`          | Normal | `hover`                           | Show hover documentation  |
| `<Leader>cd` | Normal | `open_float`                      | Show line diagnostics     |
| `[d`         | Normal | `goto_prev`                       | Go to previous diagnostic |
| `]d`         | Normal | `goto_next`                       | Go to next diagnostic     |
| `gD`         | Normal | `declaration`                     | Go to declaration         |
| `gd`         | Normal | `definition`                      | Go to definition          |
| `gr`         | Normal | `references`                      | Find references           |
| `gi`         | Normal | `implementation`                  | Go to implementation      |
| `gt`         | Normal | `type_definition`                 | Go to type definition     |
| `<Leader>cR` | Normal | `rename`                          | Rename symbol             |
| `<Leader>ca` | Normal | `code_action`                     | Code actions              |
| `<Leader>ci` | Normal | `Telescope lsp_implementations`   | Find implementations      |
| `<Leader>cr` | Normal | `Telescope lsp_references`        | Find references           |
| `<Leader>cw` | Normal | `Telescope lsp_workspace_symbols` | Find workspace symbols    |
| `<Leader>cf` | Normal | `Telescope lsp_document_symbols`  | File outline              |
| `<Leader>c[` | Normal | `Telescope lsp_incoming_calls`    | Incoming calls            |
| `<Leader>c]` | Normal | `Telescope lsp_outgoing_calls`    | Outgoing calls            |
| `<Leader>ce` | Normal | `Telescope diagnostics bufnr=0`   | Current file diagnostics  |
| `<Leader>cW` | Normal | `Telescope diagnostics`           | Global diagnostics        |
| `<Leader>D`  | Normal | `diagnostic.open_float()`         | Show diagnostics float    |

### Telescope (Fuzzy Finder)

| Keybinding   | Mode      | Action                     | Description              |
| :----------- | :-------- | :------------------------- | :----------------------- |
| `<Leader>ff` | Normal    | `Telescope find_files`     | Find files               |
| `<Leader>fs` | Normal    | `Telescope grep_string`    | Search string in files   |
| `<Leader>fg` | Normal    | `Telescope live_grep`      | Global search            |
| `<Leader>fb` | Normal    | `Telescope buffers`        | Find open buffers        |
| `<Leader>fo` | Normal    | `Telescope oldfiles`       | Recent files             |
| `<Leader>fr` | Normal    | `Telescope live_grep_args` | Advanced search          |
| `<Leader>fp` | Normal    | `Telescope projects`       | Switch projects          |
| `<Leader>H`  | Normal    | `Telescope help_tags`      | Help search              |
| `<Leader>ft` | Normal    | `Telescope todo-comments`  | Todo search              |
| `<A-s>`      | Telescope | `file_split`               | Open in horizontal split |
| `<A-v>`      | Telescope | `file_vsplit`              | Open in vertical split   |
| `<A-t>`      | Telescope | `file_tab`                 | Open in new tab          |

### Flash (Quick Jump)

| Keybinding | Mode             | Action                      | Description           |
| :--------- | :--------------- | :-------------------------- | :-------------------- |
| `s`        | Normal/Visual/Op | `flash.jump()`              | Flash jump            |
| `S`        | Normal/Visual/Op | `flash.treesitter()`        | Flash treesitter jump |
| `r`        | Operator-pending | `flash.remote()`            | Remote jump           |
| `R`        | Operator/Visual  | `flash.treesitter_search()` | Treesitter search     |
| `gl`       | Normal/Visual/Op | `flash.jump({pattern="^"})` | Jump to line          |
| `<C-S>`    | Insert/Command   | `flash.toggle()`            | Toggle flash search   |

### Harpoon (File Marking)

| Keybinding   | Mode   | Action                           | Description         |
| :----------- | :----- | :------------------------------- | :------------------ |
| `<Leader>ma` | Normal | `harpoon:list():add()`           | Add mark            |
| `<Leader>md` | Normal | `harpoon:list():remove()`        | Remove mark         |
| `<Leader>mm` | Normal | `harpoon.ui:toggle_quick_menu()` | Toggle Harpoon menu |
| `<Leader>m1` | Normal | `harpoon:list():select(1)`       | Jump to mark 1      |
| `<Leader>m2` | Normal | `harpoon:list():select(2)`       | Jump to mark 2      |
| `<Leader>m3` | Normal | `harpoon:list():select(3)`       | Jump to mark 3      |
| `<Leader>m[` | Normal | `harpoon:list():prev()`          | Previous mark       |
| `<Leader>m]` | Normal | `harpoon:list():next()`          | Next mark           |

### Bufferline (Buffer Management)

| Keybinding   | Mode   | Action                           | Description             |
| :----------- | :----- | :------------------------------- | :---------------------- |
| `]b`         | Normal | `BufferLineCycleNext`            | Next buffer             |
| `[b`         | Normal | `BufferLineCyclePrev`            | Previous buffer         |
| `<Leader>bb` | Normal | `e #`                            | Quick switch buffer     |
| `<Leader>bf` | Normal | `BufferLinePick`                 | Pick and jump to buffer |
| `<Leader>bd` | Normal | `bdelete`                        | Delete buffer           |
| `<Leader>bo` | Normal | `BufferLineCloseOthers`          | Close other buffers     |
| `<Leader>bp` | Normal | `BufferLineTogglePin`            | Toggle pin              |
| `<Leader>bP` | Normal | `BufferLineGroupClose ungrouped` | Close ungrouped buffers |

### ToggleTerm (Terminal)

| Keybinding   | Mode     | Action                            | Description         |
| :----------- | :------- | :-------------------------------- | :------------------ |
| `<C-\>`      | Normal   | `ToggleTerm`                      | Toggle terminal     |
| `<Leader>tt` | Normal   | `ToggleTerm`                      | Toggle terminal     |
| `<Leader>tv` | Normal   | `ToggleTerm direction=vertical`   | Vertical terminal   |
| `<Leader>th` | Normal   | `ToggleTerm direction=horizontal` | Horizontal terminal |
| `<Leader>tf` | Normal   | `ToggleTerm direction=float`      | Floating terminal   |
| `<Esc>`      | Terminal | `<C-\><C-n>`                      | Exit terminal mode  |

### Neo-tree (File Explorer)

| Keybinding  | Mode   | Action           | Description      |
| :---------- | :----- | :--------------- | :--------------- |
| `<Leader>e` | Normal | `Neotree toggle` | Toggle file tree |

**Neo-tree 使用说明：**

#### 基本操作

- 按 `<Leader>e` 打开/关闭文件树
- 文件树会自动跟随当前文件
- 使用 `h/j/k/l` 或方向键导航文件和目录
- 按 `Enter` 或 `o` 打开文件/展开目录
- 按 `Tab` 在新标签页打开文件
- 按 `t` 在新标签页打开文件
- 按 `s` 在水平分屏中打开文件
- 按 `v` 在垂直分屏中打开文件
- 按 `p` 预览文件内容
- 按 `a` 创建新文件/目录
- 按 `d` 删除文件/目录
- 按 `r` 重命名文件/目录
- 按 `c` 复制文件/目录
- 按 `x` 剪切文件/目录
- 按 `P` 粘贴文件/目录
- 按 `y` 复制文件路径
- 按 `Y` 复制文件内容
- 按 `.` 显示/隐藏隐藏文件
- 按 `R` 刷新文件树
- 按 `?` 显示帮助信息

#### Git 状态图标

- `●` - 新增文件
- `M` - 修改文件
- `D` - 删除文件
- `R` - 重命名文件
- `??` - 未跟踪文件
- `A` - 已暂存
- `!` - 忽略文件

#### 文件树特性

- 自动合并空目录
- 支持拖拽移动文件
- 显示 Git 状态
- 支持文件过滤和搜索
- 支持书签功能

---

### AI Assistant (Avante)

| Keybinding   | Mode   | Action          | Description       |
| :----------- | :----- | :-------------- | :---------------- |
| `<Leader>aa` | Normal | `AvanteAsk`     | Ask AI            |
| `<Leader>ae` | Normal | `AvanteEdit`    | Edit with AI      |
| `<Leader>at` | Normal | `AvanteToggle`  | Toggle AI sidebar |
| `<Leader>ar` | Normal | `AvanteRefresh` | Refresh AI        |
| `<Leader>am` | Normal | `AvanteModels`  | Switch AI models  |

### Completion (Blink CMP)

| Keybinding | Mode          | Action             | Description              |
| :--------- | :------------ | :----------------- | :----------------------- |
| `<Tab>`    | Insert/Select | `select_next_item` | Next completion item     |
| `<S-Tab>`  | Insert/Select | `select_prev_item` | Previous completion item |
| `<CR>`     | Insert/Select | `confirm`          | Confirm selection        |

---

## tmux

The tmux configuration is defined in `home/programs/terminal/tmux.nix` and is
shared by NixOS and macOS. The prefix key is `Ctrl + w`.

Because Neovim and Fish also use `Ctrl + w`, press `Ctrl + w` twice to send a
literal `Ctrl + w` to the program inside the active pane. For example, a
Neovim window command becomes `Ctrl + w`, `Ctrl + w`, then `h/j/k/l`.

### Panes and Windows

| Keybinding                 | Action                                                 |
| :------------------------- | :----------------------------------------------------- |
| `Ctrl + w`, `h/j/k/l`      | Focus the pane in the selected direction               |
| `Ctrl + w`, `s`, `h/j/k/l` | Split toward the selected direction                    |
| `Ctrl + w`, `Arrow key`    | Resize the active pane by five cells                   |
| `Ctrl + w`, `c`            | Create a window in the active pane's current directory |
| `Ctrl + w`, `t`, `n`       | Create a window in the active pane's current directory |
| `Ctrl + w`, `t`, `h/l`     | Select the previous/next window                        |
| `Ctrl + w`, `r`            | Rename the current window                              |
| `Ctrl + w`, `R`            | Reload the tmux configuration                          |
| `Ctrl + w`, `Ctrl + w`     | Send a literal `Ctrl + w` to the active program        |

New panes and windows inherit the active pane's working directory. Windows and
panes are numbered from 1, and window numbers are compacted after a window is
closed.

### Copy Mode and Mouse

| Keybinding             | Action                                       |
| :--------------------- | :------------------------------------------- |
| Mouse wheel in a shell | Enter copy mode and scroll terminal history  |
| Mouse wheel in a TUI   | Forward scrolling to Neovim, Yazi, etc.      |
| `Ctrl + w`, `b`        | Enter copy mode and search backward for `@`  |
| `v`                    | Begin a selection in copy mode               |
| `Ctrl + v`             | Toggle rectangular selection                 |
| `y`                    | Copy the selection and stay at this position |
| `Y`                    | Copy from the cursor to the end of the line  |
| `q` / `Escape`         | Leave copy mode                              |
| `H/L`                  | Move to the start/end of the line            |
| `J/K`                  | Move five lines down/up                      |
| `B/W`                  | Move five words backward/forward             |
| `-` / `=`              | Go to the previous/next search match         |

Mouse selection and copy mode use tmux's clipboard integration. Kitty receives
copied text through OSC 52, so the same configuration also works over SSH and
on macOS without hard-coded Wayland clipboard commands. Keyboard and mouse
copies stay at the current history position; press `q` or `Escape`, or scroll
back to the bottom, to return to live output.

### Applying Changes

Run `nixu` to apply the NixOS configuration. Most tmux changes can then be
loaded with `Ctrl + w`, `R`. Changes to server-wide terminal capabilities are
best applied by restarting the tmux server after saving all work:

```bash
tmux kill-server
tmux
```

`tmux kill-server` ends every tmux session owned by the current user.

---

## Shell (Fish & Zoxide)

Configured in `home/programs/shell/fish.nix`.

- **Directory Navigation**: Use `z <directory>` to jump to frequently used directories (powered by `zoxide`).
- **Fuzzy Finding** (`fzf.fish` plugin — previews rendered by `bat`, file listing by `fd`. `Ctrl+t`/`Alt+l` were chosen over fzf.fish's defaults so fish's `Ctrl+f` autosuggestion-accept and `Ctrl+l` clear-screen keep working):
  - `Ctrl + t` — search files under the current directory, insert the selected path
  - `Ctrl + r` — search command history with live preview
  - `Alt + l` — search git commits (previews the diff)
  - `Ctrl + g` — search files changed in the git worktree
  - `Ctrl + v` — search environment variables
- **Vi Mode**: `Esc` enters normal mode; the cursor shape follows the mode (block in normal/visual, line in insert). `fish_escape_delay_ms` is raised to 300 ms so `Esc` stays reliable over SSH/tmux.
- **direnv + nix-direnv**: auto-loads `.envrc` when entering a directory. Put `use flake` in a project's `.envrc` and run `direnv allow` once to activate its Nix dev shell; nix-direnv caches the result so re-entry is instant.
- **Carapace**: completion engine layered on fish's native `Tab` completions, adding structured argument completions for hundreds of commands (flags, enum values, package names, ...).
- **grc**: colorizes output of common commands (`systemctl`, `journalctl`, `ping`, `ip`, `df`, `diff`, `mount`, `docker`, ...). Interactive sessions only — pipes and scripts are unaffected.
- **yazi** (TUI file manager): launch with `y` — quitting drops the shell into the directory you browsed.
- **bat**: `cat` clone with syntax highlighting; also the preview pager behind `fzf.fish`.
- **Proxy toggle**: `proxy` / `proxy on` exports `http_proxy`/`https_proxy`/`all_proxy` to `127.0.0.1:7890`; `proxy off` unsets them. (git/SSH proxies are configured separately and always on.)
- **Abbreviations**:
  - **Nix**: `nixu` (OS update), `nixc` (Clean).
  - **Git**: `g` (git), `ga` (add), `gc` (commit), `gp` (push), `gl` (pull), `gst` (status), `gd` (diff), `gb` (branch), `gco` (checkout).
  - **General**: `n`, `vim`, `vi` (all alias to `nvim`).

---

# 快捷键参考 (中文版)

本文档总结了本项目中 **Niri** 窗口管理器、**NixVim** (Neovim)、**tmux**
以及交互式 Shell 配置的快捷键。

## Niri 窗口管理器

这些快捷键在 `home/programs/desktop/niri/default.nix` 中配置。

键盘布局将 `Caps Lock` 映射为 `Escape`，并交换左 `Ctrl` 和左 `Alt`。下表使用
Niri 配置中的逻辑修饰键名称。

| 快捷键                                    | 动作                                       | 描述                                       |
| :---------------------------------------- | :----------------------------------------- | :----------------------------------------- |
| **窗口管理**                              |                                            |                                            |
| `Super + q` / `Super + w`                 | `close-window`                             | 关闭当前窗口                               |
| `Super + Shift + w`                       | _Script_                                   | 更改壁纸/主题 (运行 `change-wal-niri`)     |
| `Super + Shift + a`                       | `toggle-overview`                          | 切换窗口概览                               |
| `Super + t`                               | `toggle-column-tabbed-display`             | 切换当前列的标签式显示                     |
| `Super + Shift + Space`                   | `toggle-window-floating`                   | 切换窗口悬浮状态                           |
| `Super + Space`                           | `switch-focus-between-floating-and-tiling` | 在悬浮和平铺窗口间切换焦点                 |
| `Super + f`                               | `maximize-column`                          | 最大化当前列                               |
| `Super + Shift + f`                       | `fullscreen-window`                        | 切换窗口全屏                               |
| `Super + Ctrl + f`                        | `toggle-windowed-fullscreen`               | 切换窗口化全屏                             |
| `Super + c`                               | `center-column`                            | 居中当前列                                 |
| `Super + Comma (,)`                       | `consume-window-into-column`               | 将窗口吸入当前列                           |
| `Super + Period (.)`                      | `expel-window-from-column`                 | 将窗口从当前列排出                         |
| `Super + r`                               | `switch-preset-column-width`               | 切换预设列宽                               |
| `Super + [Shift +] -`                     | `set-column-width "-10%"`                  | 减小列宽 (Shift: 窗口高度)                 |
| `Super + [Shift +] =`                     | `set-column-width "+10%"`                  | 增加列宽 (Shift: 窗口高度)                 |
| **导航**                                  |                                            |                                            |
| `Super + {h, j, k, l}`                    | `focus-*`                                  | 聚焦列/显示器 (h/l) 或 窗口/工作区 (j/k)   |
| `Super + {Left, Right}`                   | `focus-column-*`                           | 聚焦左侧或右侧列                           |
| `Super + {Down, Up}`                      | `focus-window-*`                           | 聚焦下方或上方窗口                         |
| `Super + Shift + {h, j, k, l}`            | `move-*`                                   | 按方向移动列/窗口                          |
| `Super + Ctrl + {方向键/h/j/k/l}`         | `focus-monitor-*`                          | 按方向聚焦显示器                           |
| `Super + Shift + Ctrl + {方向键/h/j/k/l}` | `move-window-to-monitor-*`                 | 将窗口移动到指定方向的显示器               |
| `Super + 1-9`                             | `focus-workspace`                          | 聚焦对应的命名工作区                       |
| `Super + Shift + 1-9`                     | `move-column-to-workspace`                 | 将当前整列移至对应工作区                   |
| **悬浮窗口**                              |                                            |                                            |
| `Super + Alt + {h, j, k, l}`              | `move-floating-window`                     | 精确移动悬浮窗口                           |
| **实用工具**                              |                                            |                                            |
| `Super + Return`                          | `kitty`                                    | 打开终端                                   |
| `Super + Shift + Return`                  | _Script_                                   | 打开浮动快速笔记终端                       |
| `Super + d`                               | `noctalia`                                 | 打开或关闭应用启动器                       |
| `Super + {o, b, n, e}`                    | _Application_                              | 打开 Obsidian、Brave、Nautilus 或 Hexecute |
| `Super + x`                               | `noctalia`                                 | 打开或关闭会话菜单                         |
| `Super + Shift + b`                       | `noctalia`                                 | 显示或隐藏状态栏                           |
| `Super + Shift + m`                       | `switch-to-macos`                          | 运行 macOS 切换脚本                        |
| `Super + Alt + r`                         | _Script_                                   | 开始或停止录屏                             |
| `Super + s`                               | `grim`, `wl-copy`, `satty`                 | 框选区域、复制截图，然后进入 Satty 标注    |
| `Super + Ctrl + s`                        | `grim`, `wl-copy`                          | 截取完整桌面并复制到剪贴板                 |
| `Super + Alt + s`                         | `grim`, `satty`                            | 选择一台显示器并在 Satty 中打开完整截图    |
| `Super + Shift + s`                       | `wshowkeys`                                | 显示屏幕按键提示                           |
| `Super + Ctrl + c`                        | _Script_                                   | 取色并复制 Hex 代码到剪贴板                |
| `Super + Alt + c`                         | `wl-color-picker`                          | 打开颜色选择器                             |
| 音频媒体键                                | `wpctl`                                    | 调节音量或切换扬声器/麦克风静音            |
| **投屏 (Screencasting)**                  |                                            |                                            |
| `Super + Alt + m`                         | `set-dynamic-cast-monitor`                 | 设置动态投屏监视器                         |
| `Super + Alt + w`                         | `set-dynamic-cast-window`                  | 设置动态投屏窗口                           |
| `Super + Alt + n`                         | `clear-dynamic-cast-target`                | 清除动态投屏目标                           |

命名工作区依次为：`1` coding、`2` browsing、`3` terminal、`4` reading、`5`
music、`6` proxy、`7` general、`8` reference、`9` scratch。其中工作区 5
固定在主显示器 Dell U2723QE 上。

### MX Master 4 Action Ring

配置集中在 `home/programs/utils/action-ring/`。Haptic 按键由 Solaar
接管并打开 Kando 的 `My Config` 菜单；Kando 与 Solaar 的 systemd
用户服务也在该模块中定义，随图形会话启动。
菜单包含设备切换、EIOTO 笔记与终端、窗口与工作区、区域截图标注、
音量与麦克风，以及原有 Meta+Shift 宏和 RoleInfo 提示词。
顶层条目按固定角度递增排列，均匀分布在圆环四周；正下方 `180°`
是“切换到 Mac”一级按钮，无需打开子菜单。
窗口操作直接使用 Niri IPC，无需依赖通用桌面快捷键。
`Kando Menu` 的透明窗口固定从屏幕左上角 `(0,0)` 展开，关闭焦点框、
边框和阴影；圆盘本身仍跟随鼠标位置。这是 Kando 在 Niri 下的定位要求，
不是将圆盘固定在屏幕角落。
Kando 3.0.0 的 Wayland 原生模块在获取屏幕信息后会错误清除已经收到的
pointer-enter 标志，导致静止鼠标定位超时。`kando.nix` 使用官方包的源码，
只重编译并替换修补后的 `NativeWLR.node`，其余文件和 Electron 启动器
继续复用官方包。该补丁仅应用于 3.0.0；升级后需确认上游是否已修复。

`menu.json` 是受管理菜单的源文件。Home Manager 激活时只更新
`My Config`，保留其他菜单及全局设置，并将旧菜单备份到
`~/.config/kando/backups/menus-before-action-ring-*.json`。运行时文件保持
可写，便于 Kando 编辑；要永久保留 GUI 修改，需要同步回仓库源文件，
否则下次激活会恢复受管理菜单。

`switch-to-macos [VCP] [host]` 默认使用 USB-C 输入 `0x1b` 和鼠标通道 2。
先检测显示器总线，再直接使用 Solaar 的 HID++ 库切换鼠标并核实
源连接状态，最后按稳定 I2C 总线号切屏。鼠标仍处于原通道才重试，
最多三次；连接状态不明时不盲目重试。
鼠标失败时停止切屏，并发出通知。执行日志保存在
`~/.local/state/action-ring/switch-to-macos.log`（遵循 `XDG_STATE_HOME`）。

```bash
switch-to-macos --dry-run       # 预览，不改变设备
switch-to-macos --status        # 读取鼠标配对通道与当前连接
switch-to-macos --mouse-only    # 仅将鼠标切到 Mac
switch-to-macos --display-only  # 仅切屏，可用于鼠标已经切走的情况
```

当前鼠标配对是 1=inspiron、2=MacBook Air、3=Steam Deck；Solaar CLI
使用 1 起算的通道号，HID++ 内部编号则是 0 起算。`SOLAAR_DEVICE`
可覆盖设备名称，`SOLAAR_TIMEOUT` 可覆盖 30 秒超时。鼠标 `CHANGE_HOST`
没有确认回复；工具核实已离开源主机或设备选择了目标通道，但目标 Mac
仍需开启蓝牙并保留配对，不能将源端离线当成 Mac 已接受连接。
鼠标底部按钮选择通道 1 可回到 NixOS。macOS 的 `switch-to-nixos`
仍只负责切屏，鼠标需在 Mac 端单独切换。

2026-10-13 排查时，原命令 `solaar config 'MX Master 4' change-host 2`
在 3.6 秒内成功，随后鼠标在 NixOS 离线；Bolt 接收器直接连接电脑 USB。
原组合流程失败尚未复现，因此没有将通道号、接收器拓扑或 10 秒超时
认定为根因。新流程补充顺序控制和错误日志，便于后续核实。

---

## Vim / Neovim (NixVim)

这些快捷键分布在 `home/programs/coding/nixvim/` 的各个文件中配置。

**Leader 键:** `Space` (空格)

### 通用

| 快捷键       | 模式          | 动作               | 描述                         |
| :----------- | :------------ | :----------------- | :--------------------------- |
| `j` / `k`    | Normal        | `gj` / `gk`        | 按显示行移动（支持自动换行） |
| `jk`         | Insert        | `<Esc>`            | 退出插入模式返回普通模式     |
| `<C-s>`      | Insert/Normal | `:w<CR>`           | 保存文件                     |
| `<C-a>`      | Insert/Normal | `ggVG`             | 全选                         |
| `S`          | Normal        | `:w<CR>`           | 保存文件                     |
| `Q`          | Normal        | `:bd<CR>`          | 关闭缓冲区 (删除 Buffer)     |
| `<S-h>`      | Normal        | `:bprevious<CR>`   | 切换到上一个缓冲区           |
| `<S-l>`      | Normal        | `:bnext<CR>`       | 切换到下一个缓冲区           |
| `<Esc><Esc>` | Terminal      | `<C-\><C-n>`       | 退出终端插入模式             |
| `<Leader>Y`  | Visual        | `"+y`              | 复制到系统剪贴板             |
| `<Leader>D`  | Visual        | `"+x`              | 剪切到系统剪贴板             |
| `<Leader>qq` | Normal        | `:wqa<CR>`         | 退出编辑器（保存并退出所有） |
| `<Leader>o`  | Normal        | `MiniFiles.open()` | 打开 MiniFiles 文件浏览器    |

### 窗口管理

| 快捷键       | 模式   | 动作                 | 描述             |
| :----------- | :----- | :------------------- | :--------------- |
| `<C-w>h`     | Normal | -                    | 切换到左窗口     |
| `<C-w>j`     | Normal | -                    | 切换到下窗口     |
| `<C-w>k`     | Normal | -                    | 切换到上窗口     |
| `<C-w>l`     | Normal | -                    | 切换到右窗口     |
| `<C-w>w`     | Normal | -                    | 在窗口间循环切换 |
| `<C-Up>`     | Normal | `resize +2`          | 增加窗口高度     |
| `<C-Down>`   | Normal | `resize -2`          | 减少窗口高度     |
| `<C-Left>`   | Normal | `vertical resize -2` | 减少窗口宽度     |
| `<C-Right>`  | Normal | `vertical resize +2` | 增加窗口宽度     |
| `<Leader>wH` | Normal | `<C-w>H`             | 窗口移到左边     |
| `<Leader>wJ` | Normal | `<C-w>J`             | 窗口移到底部     |
| `<Leader>wK` | Normal | `<C-w>K`             | 窗口移到顶部     |
| `<Leader>wL` | Normal | `<C-w>L`             | 窗口移到右边     |

### 行移动

| 快捷键  | 模式   | 动作               | 描述         |
| :------ | :----- | :----------------- | :----------- |
| `<A-j>` | Normal | `:m .+1<CR>==`     | 向下移动行   |
| `<A-k>` | Normal | `:m .-2<CR>==`     | 向上移动行   |
| `<A-j>` | Visual | `:m '>+1<CR>gv=gv` | 向下移动选择 |
| `<A-k>` | Visual | `:m '<-2<CR>gv=gv` | 向上移动选择 |

### 标签页管理

| 快捷键               | 模式   | 动作          | 描述           |
| :------------------- | :----- | :------------ | :------------- |
| `<Leader><tab><tab>` | Normal | `tabnew`      | 新建标签页     |
| `<Leader><tab>d`     | Normal | `tabclose`    | 关闭当前标签页 |
| `<Leader><tab>o`     | Normal | `tabonly`     | 关闭其他标签页 |
| `<Leader><tab>l`     | Normal | `tabnext`     | 下一个标签页   |
| `<Leader><tab>h`     | Normal | `tabprevious` | 上一个标签页   |

### LSP (语言服务器协议)

| 快捷键       | 模式   | 动作                              | 描述                   |
| :----------- | :----- | :-------------------------------- | :--------------------- |
| `K`          | Normal | `hover`                           | 显示悬停文档           |
| `<Leader>cd` | Normal | `open_float`                      | 显示行诊断信息         |
| `[d`         | Normal | `goto_prev`                       | 跳转到上一个诊断       |
| `]d`         | Normal | `goto_next`                       | 跳转到下一个诊断       |
| `gD`         | Normal | `declaration`                     | 跳转到声明             |
| `gd`         | Normal | `definition`                      | 跳转到定义             |
| `gr`         | Normal | `references`                      | 查找引用               |
| `gi`         | Normal | `implementation`                  | 跳转到实现             |
| `gt`         | Normal | `type_definition`                 | 跳转到类型定义         |
| `<Leader>cR` | Normal | `rename`                          | 重命名符号             |
| `<Leader>ca` | Normal | `code_action`                     | 代码操作 (Code Action) |
| `<Leader>ci` | Normal | `Telescope lsp_implementations`   | 查找实现               |
| `<Leader>cr` | Normal | `Telescope lsp_references`        | 查找引用               |
| `<Leader>cw` | Normal | `Telescope lsp_workspace_symbols` | 查找工作区符号         |
| `<Leader>cf` | Normal | `Telescope lsp_document_symbols`  | 文件大纲               |
| `<Leader>c[` | Normal | `Telescope lsp_incoming_calls`    | 被调列表               |
| `<Leader>c]` | Normal | `Telescope lsp_outgoing_calls`    | 调用列表               |
| `<Leader>ce` | Normal | `Telescope diagnostics bufnr=0`   | 当前文件诊断           |
| `<Leader>cW` | Normal | `Telescope diagnostics`           | 全局诊断               |
| `<Leader>D`  | Normal | `diagnostic.open_float()`         | 显示诊断浮窗           |

### Telescope (模糊查找)

| 快捷键       | 模式      | 动作                       | 描述             |
| :----------- | :-------- | :------------------------- | :--------------- |
| `<Leader>ff` | Normal    | `Telescope find_files`     | 查找文件         |
| `<Leader>fs` | Normal    | `Telescope grep_string`    | 字符快搜         |
| `<Leader>fg` | Normal    | `Telescope live_grep`      | 全局搜索         |
| `<Leader>fb` | Normal    | `Telescope buffers`        | 查找打开的缓冲区 |
| `<Leader>fo` | Normal    | `Telescope oldfiles`       | 历史文件         |
| `<Leader>fr` | Normal    | `Telescope live_grep_args` | 高级搜索         |
| `<Leader>fp` | Normal    | `Telescope projects`       | 切换项目         |
| `<Leader>H`  | Normal    | `Telescope help_tags`      | 帮助查询         |
| `<Leader>ft` | Normal    | `Telescope todo-comments`  | Todo 查询        |
| `<A-s>`      | Telescope | `file_split`               | 水平分屏打开     |
| `<A-v>`      | Telescope | `file_vsplit`              | 垂直分屏打开     |
| `<A-t>`      | Telescope | `file_tab`                 | 新标签页打开     |

### Flash (快速跳转)

| 快捷键  | 模式             | 动作                        | 描述                  |
| :------ | :--------------- | :-------------------------- | :-------------------- |
| `s`     | Normal/Visual/Op | `flash.jump()`              | Flash 跳转            |
| `S`     | Normal/Visual/Op | `flash.treesitter()`        | Flash Treesitter 跳转 |
| `r`     | Operator-pending | `flash.remote()`            | 远程跳转              |
| `R`     | Operator/Visual  | `flash.treesitter_search()` | Treesitter 搜索       |
| `gl`    | Normal/Visual/Op | `flash.jump({pattern="^"})` | 跳转行                |
| `<C-S>` | Insert/Command   | `flash.toggle()`            | 切换 Flash 搜索       |

### Harpoon (文件标记)

| 快捷键       | 模式   | 动作                             | 描述              |
| :----------- | :----- | :------------------------------- | :---------------- |
| `<Leader>ma` | Normal | `harpoon:list():add()`           | 添加标记          |
| `<Leader>md` | Normal | `harpoon:list():remove()`        | 移除标记          |
| `<Leader>mm` | Normal | `harpoon.ui:toggle_quick_menu()` | 切换 Harpoon 菜单 |
| `<Leader>m1` | Normal | `harpoon:list():select(1)`       | 跳转标记 1        |
| `<Leader>m2` | Normal | `harpoon:list():select(2)`       | 跳转标记 2        |
| `<Leader>m3` | Normal | `harpoon:list():select(3)`       | 跳转标记 3        |
| `<Leader>m[` | Normal | `harpoon:list():prev()`          | 上一个标记        |
| `<Leader>m]` | Normal | `harpoon:list():next()`          | 下一个标记        |

### Bufferline (缓冲区管理)

| 快捷键       | 模式   | 动作                             | 描述               |
| :----------- | :----- | :------------------------------- | :----------------- |
| `]b`         | Normal | `BufferLineCycleNext`            | 下一个缓冲区       |
| `[b`         | Normal | `BufferLineCyclePrev`            | 上一个缓冲区       |
| `<Leader>bb` | Normal | `e #`                            | 快速切换缓冲区     |
| `<Leader>bf` | Normal | `BufferLinePick`                 | 查询并跳转缓冲区   |
| `<Leader>bd` | Normal | `bdelete`                        | 删除缓冲区         |
| `<Leader>bo` | Normal | `BufferLineCloseOthers`          | 删除其他缓冲区     |
| `<Leader>bp` | Normal | `BufferLineTogglePin`            | 切换固定状态       |
| `<Leader>bP` | Normal | `BufferLineGroupClose ungrouped` | 删除未固定的缓冲区 |

### ToggleTerm (终端)

| 快捷键       | 模式     | 动作                              | 描述         |
| :----------- | :------- | :-------------------------------- | :----------- |
| `<C-\>`      | Normal   | `ToggleTerm`                      | 切换终端     |
| `<Leader>tt` | Normal   | `ToggleTerm`                      | 切换终端     |
| `<Leader>tv` | Normal   | `ToggleTerm direction=vertical`   | 垂直终端     |
| `<Leader>th` | Normal   | `ToggleTerm direction=horizontal` | 水平终端     |
| `<Leader>tf` | Normal   | `ToggleTerm direction=float`      | 浮动终端     |
| `<Esc>`      | Terminal | `<C-\><C-n>`                      | 退出终端模式 |

### Neo-tree (文件浏览器)

| 快捷键      | 模式   | 动作             | 描述       |
| :---------- | :----- | :--------------- | :--------- |
| `<Leader>e` | Normal | `Neotree toggle` | 切换文件树 |

**Neo-tree 使用说明：**

#### 基本操作

- 按 `<Leader>e` 打开/关闭文件树
- 文件树会自动跟随当前文件
- 使用 `h/j/k/l` 或方向键导航文件和目录
- 按 `Enter` 或 `o` 打开文件/展开目录
- 按 `Tab` 在新标签页打开文件
- 按 `t` 在新标签页打开文件
- 按 `s` 在水平分屏中打开文件
- 按 `v` 在垂直分屏中打开文件
- 按 `p` 预览文件内容
- 按 `a` 创建新文件/目录
- 按 `d` 删除文件/目录
- 按 `r` 重命名文件/目录
- 按 `c` 复制文件/目录
- 按 `x` 剪切文件/目录
- 按 `P` 粘贴文件/目录
- 按 `y` 复制文件路径
- 按 `Y` 复制文件内容
- 按 `.` 显示/隐藏隐藏文件
- 按 `R` 刷新文件树
- 按 `?` 显示帮助信息

#### Git 状态图标

- `●` - 新增文件 (Added)
- `M` - 修改文件 (Modified)
- `D` - 删除文件 (Deleted)
- `R` - 重命名文件 (Renamed)
- `??` - 未跟踪文件 (Untracked)
- `A` - 已暂存 (Staged)
- `!` - 忽略文件 (Ignored)

#### 文件树特性

- 自动合并空目录
- 支持拖拽移动文件
- 显示 Git 状态
- 支持文件过滤和搜索
- 支持书签功能

### AI 助手 (Avante)

| 快捷键       | 模式   | 动作            | 描述           |
| :----------- | :----- | :-------------- | :------------- |
| `<Leader>aa` | Normal | `AvanteAsk`     | 询问 AI        |
| `<Leader>ae` | Normal | `AvanteEdit`    | 使用 AI 编辑   |
| `<Leader>at` | Normal | `AvanteToggle`  | 切换 AI 侧边栏 |
| `<Leader>ar` | Normal | `AvanteRefresh` | 刷新 AI        |
| `<Leader>am` | Normal | `AvanteModels`  | 切换 AI 模型   |

### 补全 (Blink CMP)

| 快捷键    | 模式          | 动作               | 描述         |
| :-------- | :------------ | :----------------- | :----------- |
| `<Tab>`   | Insert/Select | `select_next_item` | 下一个补全项 |
| `<S-Tab>` | Insert/Select | `select_prev_item` | 上一个补全项 |
| `<CR>`    | Insert/Select | `confirm`          | 确认选择     |

---

## tmux

tmux 配置位于 `home/programs/terminal/tmux.nix`，由 NixOS 和 macOS 共用。
前缀键（Prefix）是 `Ctrl + w`。

由于 Neovim 和 Fish 同样会使用 `Ctrl + w`，需要连续按两次 `Ctrl + w`，才能向
当前窗格中的程序发送一个原始的 `Ctrl + w`。例如，在 Neovim 中执行窗口移动时，
依次按 `Ctrl + w`、`Ctrl + w`，再按 `h/j/k/l`。

### 窗格和窗口

| 快捷键                     | 操作                          |
| :------------------------- | :---------------------------- |
| `Ctrl + w`，`h/j/k/l`      | 向指定方向切换窗格            |
| `Ctrl + w`，`s`，`h/j/k/l` | 向指定方向创建分屏            |
| `Ctrl + w`，方向键         | 将当前窗格调整五个单元        |
| `Ctrl + w`，`c`            | 在当前目录中新建窗口          |
| `Ctrl + w`，`t`，`n`       | 在当前目录中新建窗口          |
| `Ctrl + w`，`t`，`h/l`     | 切换到上一个/下一个窗口       |
| `Ctrl + w`，`r`            | 重命名当前窗口                |
| `Ctrl + w`，`R`            | 重新加载 tmux 配置            |
| `Ctrl + w`，`Ctrl + w`     | 向当前程序发送原始 `Ctrl + w` |

新窗格和窗口会继承当前窗格的工作目录。窗口和窗格编号均从 1 开始；关闭窗口后，
tmux 会自动整理窗口编号。

### 复制模式和鼠标

| 快捷键                  | 操作                               |
| :---------------------- | :--------------------------------- |
| 在普通 Shell 中滚动滚轮 | 进入复制模式并滚动终端历史         |
| 在 TUI 程序中滚动滚轮   | 将滚轮事件交给 Neovim、Yazi 等程序 |
| `Ctrl + w`，`b`         | 进入复制模式并向后搜索 `@`         |
| `v`                     | 在复制模式中开始选择               |
| `Ctrl + v`              | 切换矩形选择                       |
| `y`                     | 复制选中内容并停留在当前位置       |
| `Y`                     | 从光标处复制到行尾                 |
| `q` / `Escape`          | 退出复制模式                       |
| `H/L`                   | 移动到行首/行尾                    |
| `J/K`                   | 向下/向上移动五行                  |
| `B/W`                   | 向后/向前移动五个单词              |
| `-` / `=`               | 跳转到上一个/下一个搜索结果        |

鼠标选择和复制模式使用 tmux 的剪贴板集成。Kitty 通过 OSC 52 接收复制内容，因此
不需要硬编码 `wl-copy`，同一套配置也适用于 SSH 和 macOS。通过键盘或鼠标复制后
都会停留在当前历史位置；按 `q` 或 `Escape`，或者滚动回终端底部，即可返回实时输出。

### 应用配置

使用 `nixu` 应用 NixOS 配置。大部分 tmux 改动可以随后通过 `Ctrl + w`、`R` 重新
加载。涉及 server 级终端能力的改动，建议保存所有工作后重启 tmux server：

```bash
tmux kill-server
tmux
```

`tmux kill-server` 会结束当前用户的全部 tmux 会话。

---

## Shell (Fish & Zoxide)

### 常用快捷键 (Fish Built-ins)

| 快捷键        | 描述                                        |
| :------------ | :------------------------------------------ |
| `Ctrl + a`    | 跳转到行首 (Start of Line)                  |
| `Ctrl + e`    | 跳转到行尾 (End of Line)                    |
| `Ctrl + f`    | 接受建议 (Accept Autosuggestion)            |
| `Alt + f`     | 接受建议的一个单词 (Accept Word)            |
| `Alt + s`     | 快速添加/取消 `sudo` (Toggle Sudo)          |
| `Ctrl + u`    | 删除光标前的所有内容 (Clear to Start)       |
| `Ctrl + k`    | 删除光标后的所有内容 (Clear to End)         |
| `Ctrl + l`    | 清屏 (Clear Screen)                         |
| `Ctrl + t`    | fzf 搜索当前目录文件并插入路径 (fzf.fish)   |
| `Ctrl + r`    | fzf 模糊搜索历史命令，带预览 (fzf.fish)     |
| `Alt + l`     | fzf 搜索 git 提交记录，预览 diff (fzf.fish) |
| `Ctrl + g`    | fzf 搜索 git 改动文件 (fzf.fish)            |
| `Ctrl + v`    | fzf 搜索环境变量 (fzf.fish)                 |
| `Esc`         | 进入 Vi 普通模式（光标形状随模式切换）      |
| `Alt + ← / →` | 移动到上/下一个访问的目录 (Prev/Next Dir)   |
| `Tab`         | 自动补全 (Autocomplete)                     |

### 命令缩写 (Abbreviations) & 工具

- **目录跳转 (Zoxide)**: 使用 `z <目录名>` 智能跳转到常用目录。
- **模糊查找 (fzf.fish)**: `fzf` + `fd` + `bat` 组合，键位见上表，均有高亮预览。
- **环境自动加载 (direnv + nix-direnv)**: 进入含 `.envrc` 的目录时自动加载环境。在项目 `.envrc` 里写 `use flake` 并执行一次 `direnv allow`，即可自动进入该项目的 Nix 开发环境；nix-direnv 有缓存，二次进入即时生效。
- **补全引擎 (Carapace)**: 在 fish 原生 `Tab` 补全之上，为数百个命令提供结构化补全（参数、枚举值、包名等）。
- **输出上色 (grc)**: 自动为 `systemctl`、`journalctl`、`ping`、`ip`、`df`、`diff`、`docker` 等命令的输出上色；仅作用于交互会话，管道和脚本不受影响。
- **文件管理 (yazi)**: TUI 文件管理器，用 `y` 启动，退出时 shell 自动 cd 到浏览过的目录。
- **语法高亮 cat (bat)**: `bat <文件>` 带语法高亮与行号，也是 fzf 预览的后端。
- **代理开关 (proxy 函数)**: `proxy` / `proxy on` 导出 `http_proxy`/`https_proxy`/`all_proxy` 指向 `127.0.0.1:7890`，`proxy off` 取消。git/SSH 的代理是独立配置，始终生效。
- **系统管理 (Nix)**:
  - `nixu`: 系统更新 (`nh os switch`)
  - `nixc`: 清理垃圾 (`nh clean`)
- **Git 操作**:
  - `g` (git), `ga` (add), `gc` (commit -m)
  - `gp` (push), `gl` (pull), `gcl` (clone)
  - `gst` (status), `gd` (diff), `glog` (图形化日志)
  - `gb` (branch), `gco` (checkout)
- **文件与导航**:
  - `..` (cd ..), `...` (cd ../..)
  - `md` (mkdir -p), `l` (ls -lah)
  - `n`, `vim` (nvim)
