{
  programs.nixvim = {
    plugins.dressing.enable = true;
    plugins.dressing.lazyLoad = {
      enable = true;
      settings = {
        event = ["User LazyFile"];
      };
    };
    plugins.dressing.settings = {
      input = {
        enabled = false;
      };
      select = {
        enabled = false; #禁用选择框美化
      };
    };
  };
}
