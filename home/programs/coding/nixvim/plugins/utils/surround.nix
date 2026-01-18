{
  programs.nixvim = {
    plugins.nvim-surround.enable = true;
    plugins.nvim-surround.lazyLoad = {
      enable = true;
      settings = {
        event = ["User LazyFile"];
      };
    };
  };
}
