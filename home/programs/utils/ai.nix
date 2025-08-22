{ pkgs, ... }:
{
  programs.gemini-cli = {
    enable = true;
    settings = {
      theme = "ANSI";
      vimMode = true;
      preferredEditor = "nvim";
      autoAccept = false;
    };
  };
  home.packages = with pkgs; [ qwen-code ];
}
