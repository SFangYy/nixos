{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    mouse = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    # Set prefix to C-s
    prefix = "C-s";

    plugins = with pkgs.tmuxPlugins; [
      cpu
    ];

    extraConfig = ''
      # Rebind prefix
      unbind C-b
      set -g prefix C-s
      bind -n -N "Send the prefix key through to the application" C-s send-prefix

      # Basic settings
      set  -g mouse             on
      set  -g focus-events      off
      setw -g aggressive-resize off
      setw -g clock-mode-style  12
      setw -g pane-base-index   1
      set  -g renumber-windows  on

      # ============================================= #
      # Themes                                        #
      # ============================================= #
      set -g status-position bottom
      set -g status-justify left

      set -g status-bg '#1e1e2e'
      set -g status-fg '#cdd6f4'

      # 状态栏左侧：会话名称
      set -g status-left '#[fg=#89b4fa,bold] #S #[default]│ '
      set -g status-left-length 20

      set -g @host_short "#(echo #{host} | cut -d'.' -f1)"
      # 状态栏右侧：系统信息 + 日期时间
      set -g status-right '#{cpu_fg_color} 󰻠 #{cpu_percentage} #{ram_fg_color} 󰍛 #{ram_percentage}#{?#{==:#{gpu_percentage},No GPU},, #{gpu_fg_color}  #{gpu_percentage}}#[default] │ #[fg=#a6e3a1] %Y-%m-%d #[fg=#cdd6f4]│#[fg=#fab387] %H:%M #[default]'

      set -g copy-mode-match-style 'fg=#1e1e2e,bg=#cdd6f4'
      set -g copy-mode-current-match-style 'fg=#1e1e2e,bg=#d20f39'

      set -g pane-border-style 'fg=#45475a'
      set -g pane-active-border-style 'fg=#f9e2af'

      set -g window-status-style 'fg=#585b70'
      set -g window-status-current-style 'fg=#f9e2af'

      set -g window-status-format '#{?#{==:#{window_index},1},󰬺 ,#{?#{==:#{window_index},2},󰬻 ,#{?#{==:#{window_index},3},󰬼 ,#{?#{==:#{window_index},4},󰬽 ,#{?#{==:#{window_index},5},󰬾 ,#{?#{==:#{window_index},6},󰬿 ,#{?#{==:#{window_index},7},󰭀 ,#{?#{==:#{window_index},8},󰭁 ,#{?#{==:#{window_index},9},󰭂 ,󰿩 }}}}}}}}}#W#{?window_zoomed_flag, 󰁌 , }'
      set -g window-status-current-format '#{?#{==:#{window_index},1},󰬺 ,#{?#{==:#{window_index},2},󰬻 ,#{?#{==:#{window_index},3},󰬼 ,#{?#{==:#{window_index},4},󰬽 ,#{?#{==:#{window_index},5},󰬾 ,#{?#{==:#{window_index},6},󰬿 ,#{?#{==:#{window_index},7},󰭀 ,#{?#{==:#{window_index},8},󰭁 ,#{?#{==:#{window_index},9},󰭂 ,󰿩 }}}}}}}}}#W#{?window_zoomed_flag, 󰁌 , }'

      # ============================================= #
      # copy-mode-vi                                  #
      # ============================================= #
      # 按下 前缀 b 往上一个输出跳转，通过`@`定位
      bind-key b copy-mode\;\
                 send-keys -X start-of-line\;\
                 send-keys -X search-backward "@"

      # q 或 Escape 退出复制模式
      bind-key -T copy-mode-vi q send-keys -X cancel
      bind-key -T copy-mode-vi Escape send-keys -X cancel

      # 可视模式
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # 复制和复制到行尾
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Y send-keys -X begin-selection \; send-keys -X end-of-line \; send-keys -X copy-selection-and-cancel

      # 在vi模式下复制模式使用vim的移动键位
      bind-key -T copy-mode-vi h send-keys -X cursor-left
      bind-key -T copy-mode-vi k send-keys -X cursor-up
      bind-key -T copy-mode-vi j send-keys -X cursor-down
      bind-key -T copy-mode-vi l send-keys -X cursor-right

      # 快速移动
      bind-key -T copy-mode-vi K send-keys -N 5 -X cursor-up
      bind-key -T copy-mode-vi J send-keys -N 5 -X cursor-down

      # 单词间快速移动
      bind-key -T copy-mode-vi W send-keys -N 5 -X next-word-end
      bind-key -T copy-mode-vi B send-keys -N 5 -X previous-word

      # 行首/行尾移动
      bind-key -T copy-mode-vi H send-keys -X start-of-line
      bind-key -T copy-mode-vi L send-keys -X end-of-line

      # 上/下一个搜索结果以及取消搜索结果高亮
      bind-key -T copy-mode-vi = send-keys -X search-again
      bind-key -T copy-mode-vi - send-keys -X search-reverse

      # ============================================= #
      # Global Vim-like keybindings                   #
      # ============================================= #

      # ---- 定义 "分屏模式" 键位表 ----
      # (prefix) s -> 进入分屏模式, 等待 hjkl
      bind-key s switch-client -T split-mode
      # 这个键位表定义了在按下 (prefix)s 之后可以使用的按键
      bind-key -T split-mode h split-window -h -b -c "#{pane_current_path}"
      bind-key -T split-mode k split-window -b -c "#{pane_current_path}"
      bind-key -T split-mode j split-window -c "#{pane_current_path}"
      bind-key -T split-mode l split-window -h -c "#{pane_current_path}"

      # ---- 使用 Leader + Vim方向键 在窗格间移动 ----
      # -r 表示可重复，按住prefix后可以连续按方向键切换，无需重复按prefix
      bind-key -r h select-pane -L
      bind-key -r k select-pane -U
      bind-key -r j select-pane -D
      bind-key -r l select-pane -R

      # ---- 定义 "标签页模式" 键位表 ----
      # (prefix) t -> 进入标签页模式, 等待 n/h/l
      bind-key t switch-client -T tab-mode
      # 这个键位表定义了在按下 (prefix)t 之后可以使用的按键
      bind-key -T tab-mode n new-window -c "#{pane_current_path}"  # (prefix) t n -> 新建标签页
      bind-key -T tab-mode h previous-window   # (prefix) t h -> 切换到上一个(左)标签页
      bind-key -T tab-mode l next-window       # (prefix) t l -> 切换到下一个(右)标签页

      # ---- 使用方向键调整窗格大小 ----
      bind-key -r Up resize-pane -U 5
      bind-key -r Down resize-pane -D 5
      bind-key -r Left resize-pane -L 5
      bind-key -r Right resize-pane -R 5

      # ============================================= #
      # Options for yazi image preview                #
      # ============================================= #
      # 告诉tmux：如果你收到了不认识的指令，别管它，直接把它传递给后面的真实终端就行了
      set -g allow-passthrough on
      # 告诉所有在终端里运行的程序，这个终端支持什么功能
      set -ga update-environment TERM
      # 告诉tmux里的程序，您正在使用的"具体是哪一款终端软件"
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
