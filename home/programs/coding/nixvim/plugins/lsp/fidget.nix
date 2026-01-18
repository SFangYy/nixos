{lib, ...}: {
  programs.nixvim = {
    plugins.fidget.enable = true;
    plugins.fidget.lazyLoad = {
      enable = true;
      settings = {
        event = ["LspAttach"];
      };
    };
    plugins.fidget.settings = {
      progress = {
        poll_rate = 0; # 尽可能快地更新
        suppress_on_insert = true; # 插入模式下抑制新消息
        ignore_done_already = true; # 忽略已完成任务
        ignore_empty_message = true; # 忽略空消息任务
        clear_on_detach.__raw = ''
          function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
          end
        '';
        notification_group.__raw = ''
          function(msg)
            return msg.lsp_client.name
          end
        '';
        ignore = []; # 要忽略的 LSP 服务器列表

        display = {
          render_limit = 8; # 同时显示最大消息数
          done_ttl = 2; # 完成消息保留时间（秒）
          done_icon = "✔ ";
          done_style = "DiagnosticOk";
          progress_ttl.__raw = "math.huge";
          progress_icon = ["dots"];
          progress_style = "DiagnosticInfo";
          group_style = "LspInfo";
          icon_style = "Keyword";
          priority = 30;
          skip_history = true;
        };
        # Neovim 内置 LSP 客户端选项
        lsp = {
          progress_ringbuf_size = 0;
          log_handler = false;
        };
      };
      notification = {
        poll_rate = 10;
        filter = "info"; # 过滤掉 INFO 以下的通知
        history_size = 128;
        # override_vim_notify = true;      # 可选，是否让所有 vim.notify 通过 Fidget
        configs = {
          default.__raw = "require(\"fidget.notification\").default_config";
        };
        redirect.__raw = ''
          function(msg, level, opts)
            if opts and opts.on_open then
              return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
            end
          end
        '';
        # 通知如何渲染为文本
        view = {
          stack_upwards = true; # 通知从底部向上堆叠显示
          icon_separator = " "; # 图标和文本之间的分隔符
          group_separator = "---"; # 组之间的分隔符
          group_separator_hl = "Comment"; # 分隔符高亮
          render_message.__raw = ''
            function(msg, cnt)
              return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
            end
          '';
        };

        # 通知窗口和缓冲区选项
        window = {
          normal_hl = "Comment"; # 通知窗口背景的默认高亮组
          winblend = 80; # 窗口透明度
          border = "rounded"; # 使用圆角边框
          zindex = 45; # 堆叠顺序
          max_width = 80; # 最大宽度
          max_height = 8; # 最大高度
          x_padding = 1; # 右侧边缘的水平间距
          y_padding = 0; # 底部边缘的垂直间距
          align = "bottom"; # 窗口对齐方式
          relative = "editor"; # 窗口相对于编辑器
        };
      };
    };
  };
}
