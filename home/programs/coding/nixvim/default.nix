{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./lsp.nix
    ./cmp.nix
    ./ai.nix
    ./lualine.nix
    ./treesitter.nix
    ./hop.nix
    ./ui.nix
    ./mini.nix
  ];
  stylix.targets.nixvim.enable = true;
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    performance.combinePlugins = {
      enable = true;
      standalonePlugins = [
        "copilot.lua"
        "nvim-treesitter"
      ];
    };
    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };
    highlightOverride = with config.lib.stylix.colors.withHashtag; {
      CursorLineNr = {
        bg = base01;
        fg = base06;
      };
      Comment.italic = true;
      Comment.fg = base03;
      Boolean.italic = true;
      Boolean.fg = base0E;
      String.italic = true;
      String.fg = base0B;
      StatusLine.bg = base00;
    };
    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      showmode = false;
      clipboard.providers.wl-copy.enable = true;
      breakindent = true;
      tabstop = 2;
      shiftwidth = 2;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
      inccommand = "split";
      cursorline = true;
      hlsearch = true;
      scrolloff = 10;
      spell = true;
      spelllang = [
        "en_us"
        "cjk"
      ];
      spellsuggest = "best,4";
    };
    keymaps = [
      {
        mode = "n";
        key = "S";
        action = ":w<cr>";
      }
      {
        mode = "n";
        key = "Q";
        action = ":bd<cr>";
      }
      {
        mode = "n";
        key = "<Leader>1";
        action = ":BufferLineGoToBuffer 1<cr>";
      }
      {
        mode = "n";
        key = "<Leader>2";
        action = ":BufferLineGoToBuffer 2<cr>";
      }
      {
        mode = "n";
        key = "<Leader>2";
        action = ":BufferLineGoToBuffer 2<cr>";
      }
      {
        mode = "n";
        key = "<Leader>3";
        action = ":BufferLineGoToBuffer 3<cr>";
      }
      {
        mode = "n";
        key = "<Leader>4";
        action = ":BufferLineGoToBuffer 4<cr>";
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
      }
      {
        mode = "n";
        key = "<Leader>o";
        action = ":lua MiniFiles.open()<cr>";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Togle NvimTree";
      }
      {
        mode = "n";
        key = "<leader>h";
        action = "<C-w>h";
        options.desc = "Nevigation left";
      }
      {
        mode = "n";
        key = "<leader>l";
        action = "<C-w>l";
        options.desc = "Nevigation right";
      }
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "Exit Insert Model";
      }
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Live Grep"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<cr>"; options.desc = "Find Buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<cr>"; options.desc = "Help Tags"; }

      # 自定义文件创建快捷键 (调用你的 Lua 模块)
      {
        mode = "n";
        key = "<leader>nd";
        action = "<cmd>lua _G.CreateTemplatedFileInSubdir('A/B')<cr>";
        options.desc = "Create Daily Note (select subdir)";
      }
      {
        mode = "n";
        key = "<leader>nw";
        action = "<cmd>lua _G.CreateTemplatedFileInSubdir('A/B')<cr>";
        options.desc = "Create New Doc (select subdir)";
      }


    ];
    plugins = {
      sleuth.enable = true; # automatically set shiftwidth and expandtab based on the file
      nvim-surround.enable = true;
      repeat.enable = true;
      lastplace.enable = true;
      nvim-autopairs.enable = true;
      endwise.enable = true;
      markdown-preview.enable = true;
      nvim-tree.enable = true;
      telescope = {
        enable = true;
        #package = with pkgs; [ ripgrep fd ]; # 依赖
        settings = {
          defaults = {
            vimgrep_arguments = [
              "rg" "--color=never" "--no-heading" "--with-filename" "--line-number" "--column" "--smart-case"
            ];
          };
        };
        # 注意：这里只放 Telescope 自己的快捷键，自定义的放 keymaps 里
      };

      # vim-wiki 配置
      vimwiki = {
        enable = true;
      };

      # 确保 plenary.nvim 被启用，它是 Telescope 的依赖
      # nixvim 会自动处理许多常见插件的依赖，但明确启用也无妨
      #plenary.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      fcitx-vim
    ];
    extraConfigLua = builtins.readFile ./custom/utils.lua;
      #[
      #./programs/coding/nixvim/nvim-custom-lua # 这个路径是相对于你的 home.nix 文件

      #];
  };
}
