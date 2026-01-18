{
  programs.nixvim = {
    plugins.img-clip.enable = true;
    plugins.img-clip.lazyLoad = {
      enable = true;
      settings = {
        event = ["User LazyFile"];
      };
    };
  };
}
