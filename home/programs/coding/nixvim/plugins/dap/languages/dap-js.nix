#NOTE: js/ts的调试器
# 如不需要直接在 ../dap/default.nix中注释即可。未来需要再打开注释
{pkgs, ...}: {
  programs.nixvim = {
    plugins.dap.adapters.servers.pwa-node = {
      host = "localhost";
      port = "\${port}";
      executable = {
        command = "${pkgs.vscode-js-debug}/bin/js-debug";
        args = ["\${port}"];
      };
    };

    plugins.dap.configurations = let
      javascript = [
        {
          type = "pwa-node";
          request = "launch";
          name = "Launch current file";
          program = "\${file}";
          cwd = "\${workspaceFolder}";
          outFiles = ["\${workspaceFolder}/**/*.js"];
          skipFiles = ["<node_internals>/**"];
        }
        {
          type = "pwa-node";
          request = "attach";
          name = "Attach process";
          processId = "\${require('dap.utils').pick_process}";
          cwd = "\${workspaceFolder}";
        }
        # ===== Vite 前端开发 =====
        {
          name = "Debug Vite Dev Server";
          type = "pwa-node";
          request = "launch";
          cwd = "\${workspaceFolder}";
          runtimeExecutable = "node";
          runtimeArgs = [
            "node_modules/vite/bin/vite.js"
            "--host"
          ];
          sourceMaps = true;
          outFiles = ["\${workspaceFolder}/**/*.js"];
          skipFiles = ["<node_internals>/**"];
        }
      ];
    in {
      javascript = javascript;
      javascriptreact = javascript;
      typescript = javascript;
      typescriptreact = javascript;
    };

    extraPackages = [
      pkgs.vscode-js-debug
    ];
  };
}
