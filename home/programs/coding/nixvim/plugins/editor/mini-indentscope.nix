{
  programs.nixvim = {
    plugins.mini-indentscope.enable = true;
    plugins.mini-indentscope.lazyLoad = {
      enable = true;
      settings = {
        event = ["InsertEnter"];
      };
    };
    plugins.mini-indentscope.settings = {
      symbol = "│";
      options = {
        try_as_border = true;
      };
      filetype_exclude = [
        "alpha"
        "dashboard"
        "snacks_dashboard"
      ];
      buftype_exclude = [
        "nofile"
        "prompt"
        "terminal"
      ];
    };
  };
}
