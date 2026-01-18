#NOTE: C/C++/Rust 调试器
# 如不需要直接在 ../dap/default.nix中注释即可。未来需要再打开注释
{pkgs, ...}: {
  programs.nixvim = {
    plugins.dap-lldb = {
      enable = true;
    };
    plugins.dap-lldb.lazyLoad = {
      enable = true;
      settings = {
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
          {
            __unkeyed-1 = "<F5>";
            __unkeyed-3.__raw = ''
              function()
                require("dap").continue()
              end
            '';
            desc = "▶ 启动/继续调试(F5)";
          }
        ];
      };
    };

    plugins.dap-lldb.settings = {
      codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
    };

    extraPackages = [
      pkgs.vscode-extensions.vadimcn.vscode-lldb
    ];
  };
}
