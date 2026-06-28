{ host ? "", lib, ... }:
{
  imports = [
    ./editor
    ./ui
    ./utils
    ./git
    ./snippets
  ] ++ lib.optionals (host != "macos") [
    ./lsp
    ./dap
    ./ai
  ];

  programs.nixvim = {
    plugins = {
      lz-n.enable = true;
      web-devicons.enable = true;
      web-devicons.lazyLoad = {
        enable = true;
        settings = {
          event = ["User CookLazy"];
        };
      };
    };
  };
}
