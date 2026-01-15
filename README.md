# Keybindings Reference

This document summarizes the keybindings for the **Niri** window manager and **NixVim** (Neovim) configuration found in this project.

## Niri Window Manager

These bindings are configured in `home/programs/desktop/niri/swhkd.nix`.

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| **Window Management** | | |
| `Super + q` | `quit` | Quit Niri |
| `Super + w` | `close-window` | Close the focused window |
| `Super + Shift + w` | *Script* | Change wallpaper/theme (runs `change-wal-niri`) |
| `Super + Shift + a` | `toggle-overview` | Toggle the window overview |
| `Super + t` | `toggle-column-tabbed-display` | Toggle tabbed display for the column |
| `Super + Shift + Space` | `toggle-window-floating` | Toggle floating state for the window |
| `Super + Space` | `switch-focus-between-floating-and-tiling` | Switch focus between floating/tiling |
| `Super + f` | `maximize-column` | Maximize the current column |
| `Super + Shift + f` | `fullscreen-window` | Toggle fullscreen for the window |
| `Super + Ctrl + f` | `toggle-windowed-fullscreen` | Toggle windowed fullscreen |
| `Super + c` | `center-column` | Center the current column |
| `Super + Comma` | `consume-window-into-column` | Consume window into current column |
| `Super + Period` | `expel-window-from-column` | Expel window from current column |
| `Super + r` | `switch-preset-column-width` | Switch between preset column widths |
| `Super + [Shift +] -` | `set-column-width "-10%"` | Decrease column width (Shift: window height) |
| `Super + [Shift +] =` | `set-column-width "+10%"` | Increase column width (Shift: window height) |
| **Navigation** | | |
| `Super + {h, j, k, l}` | `focus-*` | Focus column/monitor (h/l) or window/workspace (j/k) |
| `Super + {Left, Down, Up, Right}` | `focus-column-*` | Focus column in direction |
| `Super + Shift + {h, j, k, l}` | `move-*` | Move column/window in direction |
| `Super + Ctrl + {h, j, k, l}` | `focus-monitor-*` | Focus monitor in direction |
| `Super + Shift + Ctrl + {h, j, k, l}` | `move-window-to-monitor-*` | Move window to monitor in direction |
| `Super + [Shift +] 1-9` | `focus/move-to-workspace` | Focus or move window to workspace 1-9 |
| **Floating Windows** | | |
| `Super + Alt + {h, j, k, l}` | `move-floating-window` | Move floating window precisely |
| **Utilities** | | |
| `Super + n` | `nautilus` | Open File Manager (Nautilus) |
| `Print` | `screenshot` | Take a full screenshot |
| `Ctrl + Print` | `screenshot-screen` | Take a screen screenshot |
| `Alt + Print` | `screenshot-window` | Take a window screenshot |
| `Super + Ctrl + c` | *Script* | Pick color and copy Hex code to clipboard |
| **Screencasting** | | |
| `Super + Alt + m` | `set-dynamic-cast-monitor` | Set monitor for dynamic cast |
| `Super + Alt + w` | `set-dynamic-cast-window` | Set window for dynamic cast |
| `Super + Alt + n` | `clear-dynamic-cast-target` | Clear dynamic cast target |

---

## Vim / Neovim (NixVim)

These bindings are configured across various files in `home/programs/coding/nixvim/`.

**Leader Key:** `Space`

### General
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `jk` | Insert | `<Esc>` | Exit insert mode to normal mode |
| `S` | Normal | `:w<CR>` | Save file |
| `Q` | Normal | `:bd<CR>` | Close buffer (Buffer Delete) |
| `<S-h>` | Normal | `:bprevious<CR>` | Switch to previous buffer |
| `<S-l>` | Normal | `:bnext<CR>` | Switch to next buffer |
| `<Esc><Esc>` | Terminal | `<C-\><C-n>` | Exit terminal insert mode |
| `<Leader>o` | Normal | `MiniFiles.open()` | Open MiniFiles file explorer |
| `<Leader>1` - `<Leader>4` | Normal | `:BufferLineGoToBuffer N` | Switch to buffer N |

### LSP (Language Server Protocol)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `K` | Normal | `:Lspsaga hover_doc` | Show hover documentation |
| `<Leader>lE` | Normal | `open_float` | Show line diagnostics |
| `[` | Normal | `goto_prev` | Go to previous diagnostic |
| `]` | Normal | `goto_next` | Go to next diagnostic |
| `gD` | Normal | `declaration` | Go to declaration |
| `gd` | Normal | `definition` | Go to definition |
| `gr` | Normal | `references` | Find references |
| `gI` | Normal | `implementation` | Go to implementation |
| `gy` | Normal | `type_definition` | Go to type definition |
| `<Leader>lo` | Normal | `:Lspsaga outline` | Toggle symbol outline |
| `<Leader>lr` | Normal | `:Lspsaga rename` | Rename symbol |
| `<Leader>la` | Normal | `:Lspsaga code_action` | Code actions |
| `<Leader>lf` | Normal | `:Lspsaga finder` | Find references/implementations |

### AI Assistant (CodeCompanion)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>ca` | Normal | `:CodeCompanionActions` | Open AI actions menu |
| `<Leader>cc` | Normal | `:CodeCompanionChat Toggle` | Toggle AI chat window |
| `<Leader>ci` | Normal | `:CodeCompanion ` | Start inline AI command |
| `Leader>ca` | Normal | *Inline Strategy* | Accept change |
| `<Leader>cr` | Normal | *Inline Strategy* | Reject change |

### Telescope (Fuzzy Finder)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>ff` | Normal | `:Telescope fd` | Find files |
| `<Leader>fd` | Normal | `:Telescope diagnostics` | Find diagnostics |
| `<Leader>fb` | Normal | `:Telescope buffers` | Find open buffers |
| `<Leader>fr` | Normal | `:Telescope registers` | View registers |

### Hop (Easy Motion)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>hw` | Normal | `:HopWord` | Hop to word |
| `<Leader>hl` | Normal | `:HopLine` | Hop to line |

### Completion (CMP)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Tab>` | Insert/Select | `select_next_item` | Next completion item |
| `<S-Tab>` | Insert/Select | `select_prev_item` | Previous completion item |
| `<CR>` | Insert/Select | `confirm` | Confirm selection |

### Copilot
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<C-l>` | Insert | `accept` | Accept suggestion |
| `<C-Tab>` | Insert | `next` | Next suggestion |
| `<C-S-Tab>` | Insert | `prev` | Previous suggestion |
| `<C-h>` | Insert | `dismiss` | Dismiss suggestion |

### Window & Buffer Management (Mini & Others)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<C-h/j/k/l>` | Normal | *Move Focus* | Move focus between windows (Mini.move) |
| `<Leader>m` | Normal | *Minimap* | Toggle Minimap (CodeWindow) |

---

## Shell (Fish & Zoxide)

- **Directory Navigation**: Use `z <directory>` to jump to frequently used directories (powered by `zoxide`).
- **Abbreviations**:
    - **Nix**: `nixu` (OS update), `homeu` (Home update), `nixc` (Clean).
    - **Git**: `g` (git), `ga` (add), `gc` (commit), `gp` (push), `gl` (pull), `gst` (status), `gd` (diff), `gb` (branch), `gco` (checkout).
    - **General**: `n`, `vim`, `vi` (all alias to `nvim`).

---
# 快捷键参考 (中文版)

本文档总结了本项目中 **Niri** 窗口管理器和 **NixVim** (Neovim) 配置的快捷键。

## Niri 窗口管理器

这些快捷键在 `home/programs/desktop/niri/swhkd.nix` 中配置。

| 快捷键 | 动作 | 描述 |
| :--- | :--- | :--- |
| **窗口管理** | | |
| `Super + q` | `quit` | 退出 Niri |
| `Super + w` | `close-window` | 关闭当前窗口 |
| `Super + Shift + w` | *Script* | 更改壁纸/主题 (运行 `change-wal-niri`) |
| `Super + Shift + a` | `toggle-overview` | 切换窗口概览 |
| `Super + t` | `toggle-column-tabbed-display` | 切换当前列的标签式显示 |
| `Super + Shift + Space` | `toggle-window-floating` | 切换窗口悬浮状态 |
| `Super + Space` | `switch-focus-between-floating-and-tiling` | 在悬浮和平铺窗口间切换焦点 |
| `Super + f` | `maximize-column` | 最大化当前列 |
| `Super + Shift + f` | `fullscreen-window` | 切换窗口全屏 |
| `Super + Ctrl + f` | `toggle-windowed-fullscreen` | 切换窗口化全屏 |
| `Super + c` | `center-column` | 居中当前列 |
| `Super + Comma (,)` | `consume-window-into-column` | 将窗口吸入当前列 |
| `Super + Period (.)` | `expel-window-from-column` | 将窗口从当前列排出 |
| `Super + r` | `switch-preset-column-width` | 切换预设列宽 |
| `Super + [Shift +] -` | `set-column-width "-10%"` | 减小列宽 (Shift: 窗口高度) |
| `Super + [Shift +] =` | `set-column-width "+10%"` | 增加列宽 (Shift: 窗口高度) |
| **导航** | | |
| `Super + {h, j, k, l}` | `focus-*` | 聚焦列/显示器 (h/l) 或 窗口/工作区 (j/k) |
| `Super + {Left, Down, Up, Right}` | `focus-column-*` | 按方向聚焦列 |
| `Super + Shift + {h, j, k, l}` | `move-*` | 按方向移动列/窗口 |
| `Super + Ctrl + {h, j, k, l}` | `focus-monitor-*` | 按方向聚焦显示器 |
| `Super + Shift + Ctrl + {h, j, k, l}` | `move-window-to-monitor-*` | 将窗口移动到指定方向的显示器 |
| `Super + [Shift +] 1-9` | `focus/move-to-workspace` | 聚焦或移动窗口到工作区 1-9 |
| **悬浮窗口** | | |
| `Super + Alt + {h, j, k, l}` | `move-floating-window` | 精确移动悬浮窗口 |
| **实用工具** | | |
| `Super + n` | `nautilus` | 打开文件管理器 (Nautilus) |
| `Print` | `screenshot` | 全屏截图 |
| `Ctrl + Print` | `screenshot-screen` | 屏幕截图 |
| `Alt + Print` | `screenshot-window` | 窗口截图 |
| `Super + Ctrl + c` | *Script* | 取色并复制 Hex 代码到剪贴板 |
| **投屏 (Screencasting)** | | |
| `Super + Alt + m` | `set-dynamic-cast-monitor` | 设置动态投屏监视器 |
| `Super + Alt + w` | `set-dynamic-cast-window` | 设置动态投屏窗口 |
| `Super + Alt + n` | `clear-dynamic-cast-target` | 清除动态投屏目标 |

---

## Vim / Neovim (NixVim)

这些快捷键分布在 `home/programs/coding/nixvim/` 的各个文件中配置。

**Leader 键:** `Space` (空格)

### 通用
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `jk` | 插入 (Insert) | `<Esc>` | 退出插入模式返回普通模式 |
| `S` | Normal | `:w<CR>` | 保存文件 |
| `Q` | Normal | `:bd<CR>` | 关闭缓冲区 (删除 Buffer) |
| `<S-h>` | Normal | `:bprevious<CR>` | 切换到上一个缓冲区 |
| `<S-l>` | Normal | `:bnext<CR>` | 切换到下一个缓冲区 |
| `<Esc><Esc>` | Terminal | `<C-\><C-n>` | 退出终端插入模式 |
| `<Leader>o` | Normal | `MiniFiles.open()` | 打开 MiniFiles 文件浏览器 |
| `<Leader>1` - `<Leader>4` | Normal | `:BufferLineGoToBuffer N` | 切换到缓冲区 N |

### LSP (语言服务器协议)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `K` | Normal | `:Lspsaga hover_doc` | 显示悬停文档 |
| `<Leader>lE` | Normal | `open_float` | 显示行诊断信息 |
| `[` | Normal | `goto_prev` | 跳转到上一个诊断 |
| `]` | Normal | `goto_next` | 跳转到下一个诊断 |
| `gD` | Normal | `declaration` | 跳转到声明 |
| `gd` | Normal | `definition` | 跳转到定义 |
| `gr` | Normal | `references` | 查找引用 |
| `gI` | Normal | `implementation` | 跳转到实现 |
| `gy` | Normal | `type_definition` | 跳转到类型定义 |
| `<Leader>lo` | Normal | `:Lspsaga outline` | 切换符号大纲 |
| `<Leader>lr` | Normal | `:Lspsaga rename` | 重命名符号 |
| `<Leader>la` | Normal | `:Lspsaga code_action` | 代码操作 (Code Action) |
| `<Leader>lf` | Normal | `:Lspsaga finder` | 查找引用/实现 |

### AI 助手 (CodeCompanion)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Leader>ca` | Normal | `:CodeCompanionActions` | 打开 AI 操作菜单 |
| `<Leader>cc` | Normal | `:CodeCompanionChat Toggle` | 切换 AI 聊天窗口 |
| `<Leader>ci` | Normal | `:CodeCompanion ` | 启动行内 AI 命令 |
| `Leader>ca` | Normal | *Inline Strategy* | 接受更改 |
| `<Leader>cr` | Normal | *Inline Strategy* | 拒绝更改 |

### Telescope (模糊查找)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Leader>ff` | Normal | `:Telescope fd` | 查找文件 |
| `<Leader>fd` | Normal | `:Telescope diagnostics` | 查找诊断信息 |
| `<Leader>fb` | Normal | `:Telescope buffers` | 查找打开的缓冲区 |
| `<Leader>fr` | Normal | `:Telescope registers` | 查看寄存器 |

### Hop (快速跳转)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Leader>hw` | Normal | `:HopWord` | 跳转到单词 |
| `<Leader>hl` | Normal | `:HopLine` | 跳转到行 |

### 补全 (CMP)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Tab>` | Insert/Select | `select_next_item` | 下一个补全项 |
| `<S-Tab>` | Insert/Select | `select_prev_item` | 上一个补全项 |
| `<CR>` | Insert/Select | `confirm` | 确认选择 |

### Copilot (GitHub Copilot)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<C-l>` | Insert | `accept` | 接受建议 |
| `<C-Tab>` | Insert | `next` | 下一条建议 |
| `<C-S-Tab>` | Insert | `prev` | 上一条建议 |
| `<C-h>` | Insert | `dismiss` | 忽略建议 |

### 窗口与缓冲区管理 (Mini 等)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<C-h/j/k/l>` | Normal | *Move Focus* | 在窗口间移动焦点 (Mini.move) |
| `<Leader>m` | Normal | *Minimap* | 切换小地图 (CodeWindow) |

---

## Shell (Fish & Zoxide)

### 常用快捷键 (Fish Built-ins)
| 快捷键 | 描述 |
| :--- | :--- |
| `Ctrl + a` | 跳转到行首 (Start of Line) |
| `Ctrl + e` | 跳转到行尾 (End of Line) |
| `Ctrl + f` | 接受建议 (Accept Autosuggestion) |
| `Alt + f` | 接受建议的一个单词 (Accept Word) |
| `Alt + s` | 快速添加/取消 `sudo` (Toggle Sudo) |
| `Ctrl + u` | 删除光标前的所有内容 (Clear to Start) |
| `Ctrl + k` | 删除光标后的所有内容 (Clear to End) |
| `Ctrl + l` | 清屏 (Clear Screen) |
| `Alt + ← / →` | 移动到上/下一个访问的目录 (Prev/Next Dir) |
| `Tab` | 自动补全 (Autocomplete) |

### 命令缩写 (Abbreviations) & 工具
- **目录跳转 (Zoxide)**: 使用 `z <目录名>` 智能跳转到常用目录。
- **系统管理 (Nix)**:
    - `nixu`: 系统更新 (`nh os switch`)
    - `homeu`: 用户配置更新 (`nh home switch`)
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