# NOTE: GitHub插件安装配置示例（含使用lz.n懒加载插件）
# NOTE:本插件作为示例默认开启，原因是本人会使用这个插件所以默认保持启用。
# 这是我编写的插件obsess，地址：https://github.com/Youthdreamer/obsess
# 它提供了一个简单的倒计时定时器和任务管理功能，所有内容显示在一个浮动窗口中
# 如果你不需要可以更换为其他GitHub插件或者删除该文件("which-key.nix"与"autocmd.nix"中的相关设置也应该删除)
# 该插件，使用neovim提供的api不依赖其他插件，因为功能简单所以我没有编写太多的人性化服务与防呆设计所以该插件能用但不是很好用。
{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "obsess";
        src = pkgs.fetchFromGitHub {
          owner = "Youthdreamer";
          repo = "obsess";
          rev = "22142f988073292ce51c4568fbda0a40970b876d";
          hash = "sha256-mWNZutb1Jzmp4CBCLAYaw3YJDv8tZJBcrBWq5TRgiMY=";
        };
      })
    ];
    extraConfigLua = ''
      local WINDOW_WIDTH = 60
      local WINDOW_HEIGHT = 15

      local opts = {
          window = {
              relative = "editor",
              anchor = "NW",
              width = WINDOW_WIDTH,
              height = WINDOW_HEIGHT,
              row = (vim.api.nvim_get_option('lines') - WINDOW_HEIGHT) / 2,
              col = (vim.api.nvim_get_option('columns') - WINDOW_WIDTH) / 2,
              border = "rounded",
              style = "minimal",
              title = "Obsess",
          },
          -- 倒计时结束后的弹窗提醒设置
          flash = {
              times = 6, -- 闪烁次数
              interval_ms = 300, -- 每次间隔时间
          }
      }
      -- 懒加载
      require("lz.n").load {
        {
          "obsess",
          cmd = {
            "ObsessToggle", "ObsessClose", "ObsessTimer", "ObsessTimerSec",
            "ObsessTaskAdd", "ObsessTaskClear", "ObsessTaskDel", "ObsessTaskDone",
          },
          after = function()
            require("obsess").setup(opts)
          end,
        }
      }
      -- require('obsess').setup(opts)
    '';

    keymaps = [
    {
      mode = "n";
      key = "<leader>os";
      action = "<cmd>ObsessToggle<cr>";
      options = {
        silent = true;
        desc = "切换窗口";
      };
    }
    {
      mode = "n";
      key = "<leader>oc";
      action = "<cmd>ObsessClose<cr>";
      options = {
        silent = true;
        desc = "注销";
      };
    }
    {
      mode = "n";
      key = "<leader>oo";
      action = "<cmd>ObsessTimer<cr>";
      options = {
        silent = true;
        desc = "设置定时器(分)";
      };
    }
    {
      mode = "n";
      key = "<leader>ol";
      action = "<cmd>ObsessTimerSec<cr>";
      options = {
        silent = true;
        desc = "设置定时器(秒)";
      };
    }
    {
      mode = "n";
      key = "<leader>oa";
      action = "<cmd>ObsessTaskAdd<cr>";
      options = {
        silent = true;
        desc = "添加任务";
      };
    }
    {
      mode = "n";
      key = "<leader>ot";
      action = "<cmd>ObsessTaskDone<cr>";
      options = {
        silent = true;
        desc = "切换任务状态";
      };
    }
    {
      mode = "n";
      key = "<leader>od";
      action = "<cmd>ObsessTaskDel<cr>";
      options = {
        silent = true;
        desc = "删除任务";
      };
    }
    {
      mode = "n";
      key = "<leader>oe";
      action = "<cmd>ObsessTaskClear<cr>";
      options = {
        silent = true;
        desc = "清空任务列表";
      };
    }
  ];
  };
}
