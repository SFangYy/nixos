{
  imports = [
    ./aerial.nix
    ./autotag.nix
    ./mini-files.nix
    ./mini-indentscope.nix # 高亮当前块缩进参考线
    ./indent-blankline.nix # 缩进参考线(全部)
    ./neo-tree.nix
    ./ufo.nix
    ./treesitter.nix
    ./todo-comments.nix
    ./rainbow-delimiters.nix
  ];

  programs.nixvim = {
    plugins.nvim-autopairs.enable = true;
    plugins.nvim-autopairs.lazyLoad = {
      enable = true;
      settings = {
        event = ["InsertEnter"];
      };
    };
  };
}
