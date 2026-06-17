{ pkgs, ... }: {
  home.username = "yourname"; # 请在此处修改为你的 macOS 用户名
  home.homeDirectory = "/Users/yourname"; # 请在此处修改为你的 macOS 用户名
  home.stateVersion = "23.11";

  imports = [
    ./home/programs/shell/fish.nix
    ./home/programs/terminal/tmux.nix
    ./home/programs/coding/nixvim
  ];

  # macOS 额外需要的包
  home.packages = with pkgs; [
    exa
    zoxide
    pay-respects
  ];

  programs.home-manager.enable = true;
}
