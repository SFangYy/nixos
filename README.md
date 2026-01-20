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
| `Super + s` | `screenshot` | Take an area screenshot |
| `Ctrl + Super + s` | `screenshot-screen` | Take a full screen screenshot |
| `Alt + Super + s` | `screenshot-window` | Take a window screenshot |
| `Super + Ctrl + c` | *Script* | Pick color and copy Hex code to clipboard |
| **Screencasting** | | |
| `Super + Alt + m` | `set-dynamic-cast-monitor` | Set monitor for dynamic cast |
| `Super + Alt + w` | `set-dynamic-cast-window` | Set window for dynamic cast |
| `Super + Alt + n` | `clear-dynamic-cast-target` | Clear dynamic cast target |

---

## Vim / Neovim (NixVim)

These bindings are configured across various files in `home/programs/coding/nixvim/`.

**Leader Key:** `Space`

### General (通用)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `j` / `k` | Normal | `gj` / `gk` | Move by display line (wrap-aware) |
| `jk` | Insert | `<Esc>` | Exit insert mode to normal mode |
| `<C-s>` | Insert/Normal | `:w<CR>` | Save file |
| `<C-a>` | Insert/Normal | `ggVG` | Select all |
| `S` | Normal | `:w<CR>` | Save file |
| `Q` | Normal | `:bd<CR>` | Close buffer (Buffer Delete) |
| `<S-h>` | Normal | `:bprevious<CR>` | Switch to previous buffer |
| `<S-l>` | Normal | `:bnext<CR>` | Switch to next buffer |
| `<Esc><Esc>` | Terminal | `<C-\><C-n>` | Exit terminal insert mode |
| `<Leader>Y` | Visual | `"+y` | Copy to system clipboard |
| `<Leader>D` | Visual | `"+x` | Cut to system clipboard |
| `<Leader>qq` | Normal | `:wqa<CR>` | Quit editor (save and quit all) |
| `<Leader>o` | Normal | `MiniFiles.open()` | Open MiniFiles file explorer |

### Window Management (窗口管理)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<C-w>h` | Normal | - | Focus left window |
| `<C-w>j` | Normal | - | Focus window below |
| `<C-w>k` | Normal | - | Focus window above |
| `<C-w>l` | Normal | - | Focus right window |
| `<C-w>w` | Normal | - | Cycle through windows |
| `<C-Up>` | Normal | `resize +2` | Increase window height |
| `<C-Down>` | Normal | `resize -2` | Decrease window height |
| `<C-Left>` | Normal | `vertical resize -2` | Decrease window width |
| `<C-Right>` | Normal | `vertical resize +2` | Increase window width |
| `<Leader>wH` | Normal | `<C-w>H` | Move window to left |
| `<Leader>wJ` | Normal | `<C-w>J` | Move window to bottom |
| `<Leader>wK` | Normal | `<C-w>K` | Move window to top |
| `<Leader>wL` | Normal | `<C-w>L` | Move window to right |

### Line Movement (行移动)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<A-j>` | Normal | `:m .+1<CR>==` | Move line down |
| `<A-k>` | Normal | `:m .-2<CR>==` | Move line up |
| `<A-j>` | Visual | `:m '>+1<CR>gv=gv` | Move selection down |
| `<A-k>` | Visual | `:m '<-2<CR>gv=gv` | Move selection up |

### Tab Management (标签页管理)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader><tab><tab>` | Normal | `tabnew` | New tab |
| `<Leader><tab>d` | Normal | `tabclose` | Close current tab |
| `<Leader><tab>o` | Normal | `tabonly` | Close other tabs |
| `<Leader><tab>l` | Normal | `tabnext` | Next tab |
| `<Leader><tab>h` | Normal | `tabprevious` | Previous tab |

### LSP (Language Server Protocol)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `K` | Normal | `hover` | Show hover documentation |
| `<Leader>cd` | Normal | `open_float` | Show line diagnostics |
| `[d` | Normal | `goto_prev` | Go to previous diagnostic |
| `]d` | Normal | `goto_next` | Go to next diagnostic |
| `gD` | Normal | `declaration` | Go to declaration |
| `gd` | Normal | `definition` | Go to definition |
| `gr` | Normal | `references` | Find references |
| `gi` | Normal | `implementation` | Go to implementation |
| `gt` | Normal | `type_definition` | Go to type definition |
| `<Leader>cR` | Normal | `rename` | Rename symbol |
| `<Leader>ca` | Normal | `code_action` | Code actions |
| `<Leader>ci` | Normal | `Telescope lsp_implementations` | Find implementations |
| `<Leader>cr` | Normal | `Telescope lsp_references` | Find references |
| `<Leader>cw` | Normal | `Telescope lsp_workspace_symbols` | Find workspace symbols |
| `<Leader>cf` | Normal | `Telescope lsp_document_symbols` | File outline |
| `<Leader>c[` | Normal | `Telescope lsp_incoming_calls` | Incoming calls |
| `<Leader>c]` | Normal | `Telescope lsp_outgoing_calls` | Outgoing calls |
| `<Leader>ce` | Normal | `Telescope diagnostics bufnr=0` | Current file diagnostics |
| `<Leader>cW` | Normal | `Telescope diagnostics` | Global diagnostics |
| `<Leader>D` | Normal | `diagnostic.open_float()` | Show diagnostics float |

### Telescope (Fuzzy Finder)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>ff` | Normal | `Telescope find_files` | Find files |
| `<Leader>fs` | Normal | `Telescope grep_string` | Search string in files |
| `<Leader>fg` | Normal | `Telescope live_grep` | Global search |
| `<Leader>fb` | Normal | `Telescope buffers` | Find open buffers |
| `<Leader>fo` | Normal | `Telescope oldfiles` | Recent files |
| `<Leader>fr` | Normal | `Telescope live_grep_args` | Advanced search |
| `<Leader>fp` | Normal | `Telescope projects` | Switch projects |
| `<Leader>H` | Normal | `Telescope help_tags` | Help search |
| `<Leader>ft` | Normal | `Telescope todo-comments` | Todo search |
| `<A-s>` | Telescope | `file_split` | Open in horizontal split |
| `<A-v>` | Telescope | `file_vsplit` | Open in vertical split |
| `<A-t>` | Telescope | `file_tab` | Open in new tab |

### Flash (Quick Jump)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `s` | Normal/Visual/Op | `flash.jump()` | Flash jump |
| `S` | Normal/Visual/Op | `flash.treesitter()` | Flash treesitter jump |
| `r` | Operator-pending | `flash.remote()` | Remote jump |
| `R` | Operator/Visual | `flash.treesitter_search()` | Treesitter search |
| `gl` | Normal/Visual/Op | `flash.jump({pattern="^"})` | Jump to line |
| `<C-S>` | Insert/Command | `flash.toggle()` | Toggle flash search |

### Harpoon (File Marking)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>ma` | Normal | `harpoon:list():add()` | Add mark |
| `<Leader>md` | Normal | `harpoon:list():remove()` | Remove mark |
| `<Leader>mm` | Normal | `harpoon.ui:toggle_quick_menu()` | Toggle Harpoon menu |
| `<Leader>m1` | Normal | `harpoon:list():select(1)` | Jump to mark 1 |
| `<Leader>m2` | Normal | `harpoon:list():select(2)` | Jump to mark 2 |
| `<Leader>m3` | Normal | `harpoon:list():select(3)` | Jump to mark 3 |
| `<Leader>m[` | Normal | `harpoon:list():prev()` | Previous mark |
| `<Leader>m]` | Normal | `harpoon:list():next()` | Next mark |

### Bufferline (Buffer Management)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `]b` | Normal | `BufferLineCycleNext` | Next buffer |
| `[b` | Normal | `BufferLineCyclePrev` | Previous buffer |
| `<Leader>bb` | Normal | `e #` | Quick switch buffer |
| `<Leader>bf` | Normal | `BufferLinePick` | Pick and jump to buffer |
| `<Leader>bd` | Normal | `bdelete` | Delete buffer |
| `<Leader>bo` | Normal | `BufferLineCloseOthers` | Close other buffers |
| `<Leader>bp` | Normal | `BufferLineTogglePin` | Toggle pin |
| `<Leader>bP` | Normal | `BufferLineGroupClose ungrouped` | Close ungrouped buffers |

### ToggleTerm (Terminal)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<C-\>` | Normal | `ToggleTerm` | Toggle terminal |
| `<Leader>tt` | Normal | `ToggleTerm` | Toggle terminal |
| `<Leader>tv` | Normal | `ToggleTerm direction=vertical` | Vertical terminal |
| `<Leader>th` | Normal | `ToggleTerm direction=horizontal` | Horizontal terminal |
| `<Leader>tf` | Normal | `ToggleTerm direction=float` | Floating terminal |
| `<Esc>` | Terminal | `<C-\><C-n>` | Exit terminal mode |

### Neo-tree (File Explorer)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
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
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Leader>aa` | Normal | `AvanteAsk` | Ask AI |
| `<Leader>ae` | Normal | `AvanteEdit` | Edit with AI |
| `<Leader>at` | Normal | `AvanteToggle` | Toggle AI sidebar |
| `<Leader>ar` | Normal | `AvanteRefresh` | Refresh AI |
| `<Leader>am` | Normal | `AvanteModels` | Switch AI models |

### Completion (Blink CMP)
| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| `<Tab>` | Insert/Select | `select_next_item` | Next completion item |
| `<S-Tab>` | Insert/Select | `select_prev_item` | Previous completion item |
| `<CR>` | Insert/Select | `confirm` | Confirm selection |

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
| `Super + s` | `screenshot` | 区域截图 |
| `Ctrl + Super + s` | `screenshot-screen` | 全屏截图 |
| `Alt + Super + s` | `screenshot-window` | 窗口截图 |
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
| `j` / `k` | Normal | `gj` / `gk` | 按显示行移动（支持自动换行） |
| `jk` | Insert | `<Esc>` | 退出插入模式返回普通模式 |
| `<C-s>` | Insert/Normal | `:w<CR>` | 保存文件 |
| `<C-a>` | Insert/Normal | `ggVG` | 全选 |
| `S` | Normal | `:w<CR>` | 保存文件 |
| `Q` | Normal | `:bd<CR>` | 关闭缓冲区 (删除 Buffer) |
| `<S-h>` | Normal | `:bprevious<CR>` | 切换到上一个缓冲区 |
| `<S-l>` | Normal | `:bnext<CR>` | 切换到下一个缓冲区 |
| `<Esc><Esc>` | Terminal | `<C-\><C-n>` | 退出终端插入模式 |
| `<Leader>Y` | Visual | `"+y` | 复制到系统剪贴板 |
| `<Leader>D` | Visual | `"+x` | 剪切到系统剪贴板 |
| `<Leader>qq` | Normal | `:wqa<CR>` | 退出编辑器（保存并退出所有） |
| `<Leader>o` | Normal | `MiniFiles.open()` | 打开 MiniFiles 文件浏览器 |

### 窗口管理
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<C-w>h` | Normal | - | 切换到左窗口 |
| `<C-w>j` | Normal | - | 切换到下窗口 |
| `<C-w>k` | Normal | - | 切换到上窗口 |
| `<C-w>l` | Normal | - | 切换到右窗口 |
| `<C-w>w` | Normal | - | 在窗口间循环切换 |
| `<C-Up>` | Normal | `resize +2` | 增加窗口高度 |
| `<C-Down>` | Normal | `resize -2` | 减少窗口高度 |
| `<C-Left>` | Normal | `vertical resize -2` | 减少窗口宽度 |
| `<C-Right>` | Normal | `vertical resize +2` | 增加窗口宽度 |
| `<Leader>wH` | Normal | `<C-w>H` | 窗口移到左边 |
| `<Leader>wJ` | Normal | `<C-w>J` | 窗口移到底部 |
| `<Leader>wK` | Normal | `<C-w>K` | 窗口移到顶部 |
| `<Leader>wL` | Normal | `<C-w>L` | 窗口移到右边 |

### 行移动
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<A-j>` | Normal | `:m .+1<CR>==` | 向下移动行 |
| `<A-k>` | Normal | `:m .-2<CR>==` | 向上移动行 |
| `<A-j>` | Visual | `:m '>+1<CR>gv=gv` | 向下移动选择 |
| `<A-k>` | Visual | `:m '<-2<CR>gv=gv` | 向上移动选择 |

### 标签页管理
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Leader><tab><tab>` | Normal | `tabnew` | 新建标签页 |
| `<Leader><tab>d` | Normal | `tabclose` | 关闭当前标签页 |
| `<Leader><tab>o` | Normal | `tabonly` | 关闭其他标签页 |
| `<Leader><tab>l` | Normal | `tabnext` | 下一个标签页 |
| `<Leader><tab>h` | Normal | `tabprevious` | 上一个标签页 |

### LSP (语言服务器协议)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `K` | Normal | `hover` | 显示悬停文档 |
| `<Leader>cd` | Normal | `open_float` | 显示行诊断信息 |
| `[d` | Normal | `goto_prev` | 跳转到上一个诊断 |
| `]d` | Normal | `goto_next` | 跳转到下一个诊断 |
| `gD` | Normal | `declaration` | 跳转到声明 |
| `gd` | Normal | `definition` | 跳转到定义 |
| `gr` | Normal | `references` | 查找引用 |
| `gi` | Normal | `implementation` | 跳转到实现 |
| `gt` | Normal | `type_definition` | 跳转到类型定义 |
| `<Leader>cR` | Normal | `rename` | 重命名符号 |
| `<Leader>ca` | Normal | `code_action` | 代码操作 (Code Action) |
| `<Leader>ci` | Normal | `Telescope lsp_implementations` | 查找实现 |
| `<Leader>cr` | Normal | `Telescope lsp_references` | 查找引用 |
| `<Leader>cw` | Normal | `Telescope lsp_workspace_symbols` | 查找工作区符号 |
| `<Leader>cf` | Normal | `Telescope lsp_document_symbols` | 文件大纲 |
| `<Leader>c[` | Normal | `Telescope lsp_incoming_calls` | 被调列表 |
| `<Leader>c]` | Normal | `Telescope lsp_outgoing_calls` | 调用列表 |
| `<Leader>ce` | Normal | `Telescope diagnostics bufnr=0` | 当前文件诊断 |
| `<Leader>cW` | Normal | `Telescope diagnostics` | 全局诊断 |
| `<Leader>D` | Normal | `diagnostic.open_float()` | 显示诊断浮窗 |

### Telescope (模糊查找)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Leader>ff` | Normal | `Telescope find_files` | 查找文件 |
| `<Leader>fs` | Normal | `Telescope grep_string` | 字符快搜 |
| `<Leader>fg` | Normal | `Telescope live_grep` | 全局搜索 |
| `<Leader>fb` | Normal | `Telescope buffers` | 查找打开的缓冲区 |
| `<Leader>fo` | Normal | `Telescope oldfiles` | 历史文件 |
| `<Leader>fr` | Normal | `Telescope live_grep_args` | 高级搜索 |
| `<Leader>fp` | Normal | `Telescope projects` | 切换项目 |
| `<Leader>H` | Normal | `Telescope help_tags` | 帮助查询 |
| `<Leader>ft` | Normal | `Telescope todo-comments` | Todo 查询 |
| `<A-s>` | Telescope | `file_split` | 水平分屏打开 |
| `<A-v>` | Telescope | `file_vsplit` | 垂直分屏打开 |
| `<A-t>` | Telescope | `file_tab` | 新标签页打开 |

### Flash (快速跳转)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `s` | Normal/Visual/Op | `flash.jump()` | Flash 跳转 |
| `S` | Normal/Visual/Op | `flash.treesitter()` | Flash Treesitter 跳转 |
| `r` | Operator-pending | `flash.remote()` | 远程跳转 |
| `R` | Operator/Visual | `flash.treesitter_search()` | Treesitter 搜索 |
| `gl` | Normal/Visual/Op | `flash.jump({pattern="^"})` | 跳转行 |
| `<C-S>` | Insert/Command | `flash.toggle()` | 切换 Flash 搜索 |

### Harpoon (文件标记)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Leader>ma` | Normal | `harpoon:list():add()` | 添加标记 |
| `<Leader>md` | Normal | `harpoon:list():remove()` | 移除标记 |
| `<Leader>mm` | Normal | `harpoon.ui:toggle_quick_menu()` | 切换 Harpoon 菜单 |
| `<Leader>m1` | Normal | `harpoon:list():select(1)` | 跳转标记 1 |
| `<Leader>m2` | Normal | `harpoon:list():select(2)` | 跳转标记 2 |
| `<Leader>m3` | Normal | `harpoon:list():select(3)` | 跳转标记 3 |
| `<Leader>m[` | Normal | `harpoon:list():prev()` | 上一个标记 |
| `<Leader>m]` | Normal | `harpoon:list():next()` | 下一个标记 |

### Bufferline (缓冲区管理)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `]b` | Normal | `BufferLineCycleNext` | 下一个缓冲区 |
| `[b` | Normal | `BufferLineCyclePrev` | 上一个缓冲区 |
| `<Leader>bb` | Normal | `e #` | 快速切换缓冲区 |
| `<Leader>bf` | Normal | `BufferLinePick` | 查询并跳转缓冲区 |
| `<Leader>bd` | Normal | `bdelete` | 删除缓冲区 |
| `<Leader>bo` | Normal | `BufferLineCloseOthers` | 删除其他缓冲区 |
| `<Leader>bp` | Normal | `BufferLineTogglePin` | 切换固定状态 |
| `<Leader>bP` | Normal | `BufferLineGroupClose ungrouped` | 删除未固定的缓冲区 |

### ToggleTerm (终端)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<C-\>` | Normal | `ToggleTerm` | 切换终端 |
| `<Leader>tt` | Normal | `ToggleTerm` | 切换终端 |
| `<Leader>tv` | Normal | `ToggleTerm direction=vertical` | 垂直终端 |
| `<Leader>th` | Normal | `ToggleTerm direction=horizontal` | 水平终端 |
| `<Leader>tf` | Normal | `ToggleTerm direction=float` | 浮动终端 |
| `<Esc>` | Terminal | `<C-\><C-n>` | 退出终端模式 |

### Neo-tree (文件浏览器)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
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
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Leader>aa` | Normal | `AvanteAsk` | 询问 AI |
| `<Leader>ae` | Normal | `AvanteEdit` | 使用 AI 编辑 |
| `<Leader>at` | Normal | `AvanteToggle` | 切换 AI 侧边栏 |
| `<Leader>ar` | Normal | `AvanteRefresh` | 刷新 AI |
| `<Leader>am` | Normal | `AvanteModels` | 切换 AI 模型 |

### 补全 (Blink CMP)
| 快捷键 | 模式 | 动作 | 描述 |
| :--- | :--- | :--- | :--- |
| `<Tab>` | Insert/Select | `select_next_item` | 下一个补全项 |
| `<S-Tab>` | Insert/Select | `select_prev_item` | 上一个补全项 |
| `<CR>` | Insert/Select | `confirm` | 确认选择 |

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