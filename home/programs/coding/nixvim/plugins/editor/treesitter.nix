{pkgs, ...}: {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      folding = false;
      nixvimInjections = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection.enable = true;
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash # bashls
        c # clangd
        cpp # clangd
        cmake
        make
        ninja
        lua # lua_ls
        python # pyright, ruff
        rust # rust_analyzer
        go # gopls
        javascript # ts_ls
        typescript # ts_ls
        tsx
        html # html, emmet_ls
        css # cssls, stylelint_lsp
        json # jsonls
        toml # taplo
        nix # nil_ls
        markdown # marksman
        vim # vimscript
        vimdoc # vim help
        xml # 一些 XML 文件
        yaml # yaml 文件
        diff
      ];
    };

    plugins.treesitter.lazyLoad = {
      enable = true;
      settings = {
        # event = ["FileType"];
        event = ["User LazyFile"];
      };
    };
  };
}
