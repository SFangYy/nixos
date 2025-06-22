{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    telegram-desktop
    fractal
    wechat
    nur.repos.xddxdd.dingtalk
  ];
}
