{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = lib.genAttrs [
    "base00"
    "base01"
    "base02"
    "base03"
    "base04"
    "base05"
    "base06"
    "base07"
    "base08"
    "base09"
    "base0A"
    "base0B"
    "base0C"
    "base0D"
    "base0E"
    "base0F"
  ] (name: config.lib.stylix.colors.withHashtag.${name});
in
{
  imports = [
    ./core
    ./plugins
  ];

  # Use Stylix's resolved palette directly, avoiding the generated target's
  # additional scheme derivation while still applying a complete colorscheme.
  stylix.targets.nixvim.enable = false;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorscheme = lib.mkIf (config.stylix.enable or false) "stylix";
    extraFiles."colors/stylix.lua".text = lib.mkIf (config.stylix.enable or false) ''
      local palette = vim.json.decode([=[${builtins.toJSON palette}]=])
      require('base16-colorscheme').setup(palette)
      vim.g.colors_name = 'stylix'
      -- Nixvim derives BAT_THEME from the name, but this theme is nvim-only.
      vim.env.BAT_THEME = nil
    '';
    colorschemes.base16 = lib.mkIf (config.stylix.enable or false) {
      enable = true;
      colorscheme = palette;
      setUpBar = true;
    };
    performance.combinePlugins = {
      enable = false;
      standalonePlugins = [
        "copilot.lua"
        "nvim-treesitter"
        "hmts.nvim"
      ];
    };
    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    highlightOverride = lib.mkIf (config.stylix.enable or false) (
      with config.lib.stylix.colors.withHashtag;
      {
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
      }
    );

    opts = {
      background = lib.mkIf (config.stylix.enable or false) config.stylix.polarity;
      termguicolors = true;
      mouse = "a";
      showmode = false;
      breakindent = true;
      updatetime = 250;
      timeoutlen = 300;
      splitbelow = true;
      list = true;
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
      inccommand = "split";
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
        key = "<Leader>3";
        action = ":BufferLineGoToBuffer 3<cr>";
      }
      {
        mode = "n";
        key = "<Leader>4";
        action = ":BufferLineGoToBuffer 4<cr>";
      }
      {
        mode = "n";
        key = "<Leader>5";
        action = ":BufferLineGoToBuffer 5<cr>";
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
    ];
    plugins = {
      sleuth.enable = true; # automatically set shiftwidth and expandtab based on the file
      nvim-surround.enable = true;
      repeat.enable = true;
      lastplace.enable = true;
      nvim-autopairs.enable = true;
      endwise.enable = true;
      markdown-preview.enable = true;
    };
    extraPlugins =
      with pkgs.vimPlugins;
      lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        fcitx-vim
      ];
  };
}
