{
  programs.nixvim = {
    plugins.rainbow-delimiters = {
      enable = true;
    };
    plugins.rainbow-delimiters.lazyLoad = {
      settings = {
        event = ["User CookLazy"];
      };
    };
    # plugins.rainbow-delimiters.strategy = {
    #  "" = "global";
    #   html = "local";
    #  };
    plugins.rainbow-delimiters.settings = {
      blacklist = [
        "json"
      ];
      highlight = [
        "RainbowDelimiterViolet"
        "RainbowDelimiterBlue"
        "RainbowDelimiterGreen"
      ];
    };
  };
}
