{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    fira-code
    nerd-fonts.symbols-only
    nerd-fonts.monofur
    jetbrains-mono
    sarasa-gothic
  ];
  fonts.fontDir.enable = true;
}
