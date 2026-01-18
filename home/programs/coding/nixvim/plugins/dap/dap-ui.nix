{
  programs.nixvim = {
    # 调试器UI与行内提示
    plugins.dap-ui = {
      enable = true;
    };
    plugins.dap-ui.lazyLoad = {
      enable = true;
      settings = {
        #NOTE: 狗屎一样的懒加载写法，丑陋，太恶心了。无奈之举
        keys = [
          {
            __unkeyed-1 = "<leader>dB";
            __unkeyed-3.__raw = ''
              function()
                require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))
              end
            '';
            desc = "● 条件断点";
          }
          {
            __unkeyed-1 = "<leader>db";
            __unkeyed-3.__raw = ''
              function()
                require("dap").toggle_breakpoint()
              end
            '';
            desc = "● 切换断点";
          }
          {
            __unkeyed-1 = "<leader>dc";
            __unkeyed-3.__raw = ''
              function()
                require("dap").continue()
              end
            '';
            desc = "▶ 启动/继续调试";
          }
        ];
      };
    };
    extraConfigLua = ''
      local dap = require("dap")
      --NOTE: nixvim的配置中siae居然不支持浮点数，只能固定行数，一点也不方便，
      --NOTE: 只能这样注入lua的配置一点也不优雅
      local function setup_and_open_dapui()
        require("dapui").setup({
          layouts = {
            {
              position = "left",
              size = 0.25,
              elements = {
                { id = "watches", size = 0.2 },
                { id = "stacks", size = 0.35 },
                { id = "breakpoints", size = 0.1 },
                { id = "scopes", size = 0.35 },
              },
            },
            {
              position = "bottom",
              size = 0.3,
              elements = {
                { id = "console", size = 0.5 },
                { id = "repl", size = 0.5 },
              },
            },
          },
        })
        require("dapui").open({ reset = true })
      end
      dap.listeners.after.event_initialized["dapui_config"] = setup_and_open_dapui
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end

    '';

    plugins.dap-virtual-text.enable = true;
    plugins.dap-virtual-text.lazyLoad = {
      enable = true;
      settings = {
        #NOTE: 狗屎一样的懒加载写法，丑陋，太恶心了。无奈之举
        keys = [
          {
            __unkeyed-1 = "<leader>dB";
            __unkeyed-3.__raw = ''
              function()
                require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))
              end
            '';
            desc = "● 条件断点";
          }
          {
            __unkeyed-1 = "<leader>db";
            __unkeyed-3.__raw = ''
              function()
                require("dap").toggle_breakpoint()
              end
            '';
            desc = "● 切换断点";
          }
        ];
      };
    };
    plugins.dap-virtual-text.settings = {
      enabled = true;
      enabled_commands = true;
      highlight_changed_variables = true;
      highlight_new_as_changed = false;
      only_first_definition = true;
      show_stop_reason = true;
      clear_on_continue = false;
      virt_text_pos = "eol"; # 强制放到行尾
    };
  };
}
