# NOTE: 在../dependencies中依旧安装好了lazygit
{
  programs.nixvim = {
    plugins.lazygit.enable = true;
    keymaps = [
      {
        action = "<cmd>LazyGit<cr>";
        key = "<leader>gg";
        options = {
          silent = true;
          desc = "打开LazyGit界面";
        };
      }
    ];
  };
}
