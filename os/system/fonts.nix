{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-emoji
    nerd-fonts.symbols-only
    nerd-fonts.droid-sans-mono
    nerd-fonts.monofur
    font-awesome
    lxgw-wenkai
    nasin-nanpa
  ];
  fonts.fontDir.enable = true;
}
