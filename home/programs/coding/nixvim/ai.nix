{
  user,
  config,
  lib,
  ...
}:
{
  programs.nixvim = {
    plugins = {
      copilot-lua = {
        enable = true;
        settings.panel.enabled = false;
        settings.suggestion.enabled = false;
        settings.filetypes.markdown = true;
      };
      copilot-chat.enable = true;
      codecompanion = {
        enable = true;
        settings = {
          adapters.copilot.__raw =
            # lua
            ''
              function()
                return require("codecompanion.adapters").extend("copilot", {
                  schema = {
                    model = {
                      default = "claude-3.7-sonnet",
                    },
                    max_tokens = {
                      default = 65536,
                    }
                  }
                })
              end
            '';
          adapters.siliconflow.__raw =
            # lua
            ''
              function ()
                local siliconflow_token_file = io.open("${config.age.secrets.siliconflow_token.path}", "r")
                local siliconflow_api_key = siliconflow_token_file:read()
                siliconflow_token_file:close()
                return require("codecompanion.adapters").extend("openai_compatible", {
                  name = "deepseek",
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
          adapters.gemini.__raw =
            # lua
            ''
              function()
                local gemini_token_file = io.open("${config.age.secrets.gemini_token.path}", "r")
                local gemini_api_key = gemini_token_file:read()
                gemini_token_file:close()
                return require("codecompanion.adapters").extend("gemini", {
                  env = {
                    api_key = gemini_api_key,
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
