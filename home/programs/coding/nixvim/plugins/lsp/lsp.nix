# NOTE: 方便与加载速度，显然我选择前者。但依旧，保持优雅!!!
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      inlayHints = true;
    };
    plugins.lsp.lazyLoad = {
      enable = true;
      settings = {
        #NOTE: 使用ft加载lsp后startuptime的速度还会提高十多毫秒，但是我觉得维护太麻烦，不如就使用event。方便不差这点速度
        # ft = ["lua" "nix" "rust" "go" "python" "c" "cpp" "typescript" "javascript"];
        event = [ "FileType" ];
      };
    };
    plugins.lsp.servers = {
      # C/C++ 语言服务器
      clangd = {
        enable = true;
      };
      # CMake的LSP
      cmake = {
        enable = true;
      };
      # Rust 语言服务器
      rust_analyzer = {
        enable = true;
        # 解决 cargo 依赖警告
        installCargo = true;
        # 解决 rustc 依赖警告
        installRustc = true;
        settings = {
          check = {
            command = "clippy";
            onSave = true;
          };
          inlayHints = {
            enable = true;
            typeHints.enable = true;
            parameterHints.enable = true;
            chainingHints.enable = true;
          };
        };
      };
      # ts/js 语言服务器
      ts_ls = {
        enable = true;
      };
      # python 语言服务器
      pyright = {
        enable = true;
        settings = {
          pyright = {
            disableOrganizeImports = true; # 禁用 Pyright 自动整理 import
          };
          python = {
            analysis = {
              ignore = "*"; # 忽略所有文件分析，让 Ruff 处理 lint
            };
          };
        };
      };
      # Ruff
      ruff = {
        enable = true;
      };
      # lua 语言服务器
      lua_ls = {
        enable = true;
        settings = {
          diagnostics.globals = [ "vim" ];
        };
      };
      # go 语言服务器
      gopls = {
        enable = true;
      };
      # Shell 语言服务器
      bashls = {
        enable = true;
      };
      # Nix 语言服务器
      nil_ls = {
        enable = true;
      };
      # html
      html = {
        enable = true;
      };
      # css
      cssls = {
        enable = true;
      };
      stylelint_lsp = {
        enable = true;
      };
      # Tailwind CSS 语言服务器
      tailwindcss = {
        enable = true;
      };
      # Emmet 插件（通常用于 HTML, CSS, JS 文件）
      emmet_ls = {
        enable = true;
      };
      # eslint
      eslint = {
        enable = true;
      };
      # json
      jsonls = {
        enable = true;
      };
      # toml
      taplo = {
        enable = true;
      };
      # markdown
      marksman = {
        enable = true;
      };
      # yaml
      yamlls = {
        enable = true;
        extraOptions = {
          settings = {
            yaml = {
              schemas = {
                "https://json.schemastore.org/github-workflow" = ".github/workflows/*";
                "https://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                "https://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                "https://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                "https://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                "https://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";

                # Docker Compose — fully recommended
                "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = [
                  "docker-compose.{yml,yaml}"
                  "*compose*.{yml,yaml}"
                ];

                "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                  "*flow*.{yml,yaml}";
              };
            };
          };
        };
      };
    };

    plugins.lsp.keymaps = {
      silent = true;
      lspBuf = {
        gd = {
          action = "definition";
          desc = "转到定义";
        };
        gr = {
          action = "references";
          desc = "查找引用";
        };
        gD = {
          action = "declaration";
          desc = "跳转到声明";
        };
        gi = {
          action = "implementation";
          desc = "查找实现";
        };
        gt = {
          action = "type_definition";
          desc = "跳转到类型定义";
        };
        # K = {
        #   action = "hover";
        #   desc = "显示悬浮文档 / 悬浮信息";
        # };
        "<leader>cR" = {
          action = "rename";
          desc = "重命名符号";
        };
        "<leader>ca" = {
          action = "code_action";
          desc = "代码操作";
        };
      };

      diagnostic = {
        "<leader>cd" = {
          action = "open_float";
          desc = "打开当前行的诊断信息浮窗";
        };
        "[d" = {
          action = "goto_prev";
          desc = "跳转到上一个诊断";
        };
        "]d" = {
          action = "goto_next";
          desc = "跳转到下一个诊断";
        };
      };
    };

    keymaps = [
      # 悬浮信息
      {
        action.__raw = ''
          function()
            vim.lsp.buf.hover()
          end
        '';
        key = "K";
        options = {
          silent = true;
          desc = "显示悬浮文档 / 悬浮信息";
        };
      }
      # 查找实现/引用
      {
        action = "<cmd>Telescope lsp_implementations<cr>";
        key = "<leader>ci";
        options = {
          silent = true;
          desc = "查找实现";
        };
      }
      {
        action = "<cmd>Telescope lsp_references<cr>";
        key = "<leader>cr";
        options = {
          silent = true;
          desc = "查找引用";
        };
      }

      # 代码结构查看
      {
        action = "<cmd>Telescope lsp_workspace_symbols<cr>";
        key = "<leader>cw";
        options = {
          silent = true;
          desc = "查找工作区符号";
        };
      }
      {
        action = "<cmd>Telescope lsp_document_symbols<cr>";
        key = "<leader>cf";
        options = {
          silent = true;
          desc = "文件大纲";
        };
      }

      # 代码关系查看
      {
        action = "<cmd>Telescope lsp_incoming_calls<cr>";
        key = "<leader>c[";
        options = {
          silent = true;
          desc = "被调列表";
        };
      }
      {
        action = "<cmd>Telescope lsp_outgoing_calls<cr>";
        key = "<leader>c]";
        options = {
          silent = true;
          desc = "调用列表";
        };
      }

      # 诊断查看
      {
        action = "<cmd>Telescope diagnostics bufnr=0<cr>";
        key = "<leader>ce";
        options = {
          silent = true;
          desc = "当前文件诊断";
        };
      }

      {
        action = "<cmd>Telescope diagnostics<cr>";
        key = "<leader>cW";
        options = {
          silent = true;
          desc = "全局诊断";
        };
      }

      {
        action = "<cmd>lua vim.diagnostic.open_float()<cr>";
        key = "<leader>D";
        options = {
          silent = true;
          desc = "显示诊断信息 (浮窗)";
        };
      }
    ];

    # 这里是诊断设置，可根据需要更改为虚拟行显示
    # 这里对诊断进行懒加载
    extraConfigLua = ''
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function()
          local _border = "rounded"
          vim.diagnostic.config({
            -- virtual_lines = true, -- 诊断提示虚拟行
            virtual_text = true, -- 诊断提示内行提示

            signs = {
              active = true,
                text = {
                  [vim.diagnostic.severity.ERROR] = "";
                  [vim.diagnostic.severity.WARN] = "",
                  [vim.diagnostic.severity.INFO] = "";
                  [vim.diagnostic.severity.HINT] = "💡",
                },
              },
              update_in_insert = false,
              underline = true,
              severity_sort = true,
              float = {
                border = _border,
              },
            })
          end,
        })
    '';
  };
}
