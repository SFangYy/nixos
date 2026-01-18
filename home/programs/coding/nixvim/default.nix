{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./core
    ./plugins
  ];

  stylix.targets.nixvim.enable = true;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

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
      spelllang = [ "en_us" "cjk" ];
      spellsuggest = "best,4";
    };
  };
}