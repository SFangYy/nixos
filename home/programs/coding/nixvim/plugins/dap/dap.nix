{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
    };
    plugins.dap.lazyLoad = {
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
    plugins.dap.signs = {
      dapBreakpoint = {
        text = "🔴";
      };
    };
    plugins.dap.signs = {
      dapBreakpointCondition = {
        text = "🟡";
      };
    };

    keymaps = [
      # 断点
      #   {
      #     mode = "n";
      #     key = "<leader>dB";
      #     action.__raw = ''
      #       function()
      #         require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))
      #       end
      #     '';
      #     options = {
      #       silent = true;
      #       desc = "● 条件断点";
      #     };
      #   }
      #   {
      #     mode = "n";
      #     key = "<leader>db";
      #     action.__raw = ''
      #       function()
      #         require("dap").toggle_breakpoint()
      #       end
      #     '';
      #     options = {
      #       silent = true;
      #       desc = "● 切换断点";
      #     };
      #   }
      {
        mode = "n";
        key = "<leader>dd";
        action.__raw = ''
          function()
            require("dap").clear_breakpoints()
          end
        '';
        options = {
          silent = true;
          desc = "󰆴 清理所有断点";
        };
      }
      # 启动 / 继续（双通道：F5 + <leader>dc）
      #   {
      #     mode = "n";
      #     key = "<leader>dc";
      #     action.__raw = ''
      #       function()
      #         require("dap").continue()
      #       end
      #     '';
      #     options = {
      #       silent = true;
      #       desc = "▶ 启动/继续调试";
      #     };
      #   }
      {
        mode = "n";
        key = "<F5>";
        action.__raw = ''
          function()
            require("dap").continue()
          end
        '';
        options = {
          silent = true;
          desc = "▶ 启动/继续调试(F5)";
        };
      }
      # 终止调试
      {
        mode = "n";
        key = "<leader>dx";
        action.__raw = ''
          function()
            require("dap").terminate()
          end
        '';
        options = {
          silent = true;
          desc = "■ 终止调试";
        };
      }
      # 单步调试（双通道）
      {
        mode = "n";
        key = "<leader>dn";
        action.__raw = ''
          function()
            require("dap").step_over()
          end
        '';
        options = {
          silent = true;
          desc = " 单步跳过(不进函数)";
        };
      }
      {
        mode = "n";
        key = "<F10>";
        action.__raw = ''
          function()
            require("dap").step_over()
          end
        '';
        options = {
          silent = true;
          desc = " 单步跳过(不进函数)";
        };
      }
      {
        mode = "n";
        key = "<leader>di";
        action.__raw = ''
          function()
            require("dap").step_into()
          end
        '';
        options = {
          silent = true;
          desc = "󰆹 单步进入函数";
        };
      }
      {
        mode = "n";
        key = "<F11>";
        action.__raw = ''
          function()
            require("dap").step_into()
          end
        '';
        options = {
          silent = true;
          desc = "󰆹 单步进入函数";
        };
      }
      {
        mode = "n";
        key = "<leader>do";
        action.__raw = ''
          function()
            require("dap").step_out()
          end
        '';
        options = {
          silent = true;
          desc = "󰆸 单步跳出函数";
        };
      }
      {
        mode = "n";
        key = "<F12>";
        action.__raw = ''
          function()
            require("dap").step_out()
          end
        '';
        options = {
          silent = true;
          desc = "󰆸 单步跳出函数";
        };
      }
      # 调用栈切换
      {
        mode = "n";
        key = "<leader>d[";
        action.__raw = ''
          function()
            require("dap").up()
          end
        '';
        options = {
          silent = true;
          desc = "切换到上一层调用栈";
        };
      }
      {
        mode = "n";
        key = "<leader>d]";
        action.__raw = ''
          function()
            require("dap").down()
          end
        '';
        options = {
          silent = true;
          desc = "切换到下一层调用栈";
        };
      }
      # 运行
      {
        mode = "n";
        key = "<leader>dl";
        action.__raw = ''
          function()
            require("dap").run_last()
          end
        '';
        options = {
          silent = true;
          desc = "󰜉 重新运行上一次调试";
        };
      }
      # 运行到光标
      {
        mode = "n";
        key = "<leader>dC";
        action.__raw = ''
          function()
            require("dap").run_to_cursor()
          end
        '';
        options = {
          silent = true;
          desc = "运行到光标处";
        };
      }
      # REPL
      {
        mode = "n";
        key = "<leader>dr";
        action.__raw = ''
          function()
            require("dap").repl.toggle()
          end
        '';
        options = {
          silent = true;
          desc = "󰆍 打开/关闭调试REPL";
        };
      }
      # 变量悬浮查看
      {
        mode = "n";
        key = "<leader>dw";
        action.__raw = ''
          function()
            require("dap.ui.widgets").hover()
          end
        '';
        options = {
          silent = true;
          desc = "󰈈 悬浮查看变量值";
        };
      }
    ];
  };
}
