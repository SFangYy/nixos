{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      window_padding_width = "10 20 10 20";
      cursor_trail = 1;
      cursor_trail_start_threshold = 0;
      font_family = lib.mkForce "Comic Code Ligatures";
    };
    extraConfig = ''
      map ctrl+shift+p kitten hints --type path --program @
      map ctrl+shift+s kitten hints --type word --program @
      map ctrl+shift+l kitten hints --type line --program @

      symbol_map U+4E00-U+9FFF   LXGW WenKai Mono
      symbol_map U+3400-U+4DBF   LXGW WenKai Mono
      symbol_map U+20000-U+2A6DF LXGW WenKai Mono
      symbol_map U+2A700-U+2B73F LXGW WenKai Mono
      symbol_map U+2B740-U+2B81F LXGW WenKai Mono
      symbol_map U+2B820-U+2CEAF LXGW WenKai Mono
      symbol_map U+2CEB0-U+2EBEF LXGW WenKai Mono
      symbol_map U+30000-U+3134F LXGW WenKai Mono
      symbol_map U+F900-U+FAFF   LXGW WenKai Mono
      symbol_map U+2F800-U+2FA1F LXGW WenKai Mono
    '';
  };
  stylix.targets.kitty.enable = true;
  home.packages = with pkgs; [
    termpdfpy
    mdcat
  ];
}
