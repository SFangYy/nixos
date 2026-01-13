{
  config,
  pkgs,
  ...
}:
let
  get_base_secret =
    path:
    builtins.split "/" path
    |> builtins.tail
    |> builtins.filter (value: builtins.isString value)
    |> builtins.concatStringsSep "/";
in
{
  programs.nixvim = {
    # extraConfigLua =
    #   # lua
    #   ''
    #     local cmp = require("cmp")
    #     local current_sources = cmp.get_config().sources or {}
    #     table.insert(current_sources, {
    #     	name = "copilot",
    #     	priority = 100,
    #     })
    #     cmp.setup({
    #     	sources = current_sources,
    #     })
    #     local has_words_before = function()
    #     	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    #     		return false
    #     	end
    #     	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    #     	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    #     end
    #     cmp.setup({
    #     	mapping = {
    #     		["<Tab>"] = vim.schedule_wrap(function(fallback)
    #     			if cmp.visible() and has_words_before() then
    #     				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    #     			else
    #     				fallback()
    #     			end
    #     		end),
    #     	},
    #     })
    #   '';
    plugins = {
      copilot-lua = {
        enable = true;
        settings = {
          panel.enabled = false;
          suggestion.enabled = true;
          suggestion.keymap = {
            hide_during_completion = false;
            accept = "<C-l>";
            accept_word = false;
            accept_line = false;
            next = "<C-Tab>";
            prev = "<C-S-Tab>";
            dismiss = "<C-h>";
          };
          filetypes.markdown = true;
        };
      };
      # copilot-cmp.enable = true;
      windsurf-nvim = {
        enable = false;
      };
      # cmp.settings.sources = [ { name = "codeium"; } ];
      codecompanion = {
        enable = false;
        settings = {
          adapters.http.deepseek.__raw =
            # lua
            ''
              function()
                local deepseek_token_file = io.open(os.getenv("XDG_RUNTIME_DIR") .. "/" .. "${get_base_secret config.age.secrets.deepseek_token.path}", "r")
                local deepseek_api_key = deepseek_token_file:read()
                deepseek_token_file:close()
                return require("codecompanion.adapters").extend("deepseek", {
                  env = {
                    url = "https://api.deepseek.ai",
                    api_key = deepseek_api_key,
                  }
                })
              end
            '';
          adapters.http.siliconflow.__raw =
            # lua
            ''
              function ()
                local siliconflow_token_file = io.open(os.getenv("XDG_RUNTIME_DIR") .. "/" .. "${get_base_secret config.age.secrets.siliconflow_token.path}", "r")
                local siliconflow_api_key = siliconflow_token_file:read()
                siliconflow_token_file:close()
                return require("codecompanion.adapters").extend("openai_compatible", {
                  name = "siliconflow",
                  env = {
                    url = "https://api.siliconflow.cn",
                    api_key = siliconflow_api_key,
                  },
                  schema = {
                    model = {
                      default = "Pro/deepseek-ai/DeepSeek-V3",
                    }
                  }
                })
              end
            '';
          adapters.http.gemini.__raw =
            # lua
            ''
              function()
                local gemini_token_file = io.open(os.getenv("XDG_RUNTIME_DIR") .. "/" .. "${get_base_secret config.age.secrets.gemini_token.path}", "r")
                local gemini_api_key = gemini_token_file:read()
                gemini_token_file:close()
                return require("codecompanion.adapters").extend("gemini", {
                  env = {
                    api_key = gemini_api_key,
                  },
                  schema = {
                    model = {
                      default = "gemini-2.0-flash-thinking-exp-01-21",
                    }
                  }
                })
              end
            '';
          strategies = {
            inline = {
              adapter = "siliconflow";
              keymaps = {
                accept_change.modes.n = "<Leader>ca";
                reject_change.modes.n = "<Leader>cr";
              };
            };
            chat = {
              adapter = "siliconflow";
              slash_commands.__raw = # lua
                ''
                  {
                    ["file"] = {
                      opts = {
                        provider = "telescope",
                      },
                    },
                  },
                  {
                    ["buffer"] = {
                      opts = {
                        provider = "telescope",
                      },
                    },
                  },
                '';
            };
            agent.adapter = "siliconflow";
          };
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<Leader>ca";
        action = ":CodeCompanionActions<cr>";
      }
      {
        mode = "n";
        key = "<Leader>cc";
        action = ":CodeCompanionChat Toggle<cr>";
      }
      {
        mode = "n";
        key = "<Leader>ci";
        action = ":CodeCompanion ";
      }
    ];
  };
}
