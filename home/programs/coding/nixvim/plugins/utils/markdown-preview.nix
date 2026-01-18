{
  programs.nixvim = {
    plugins.markdown-preview.enable = true;
    keymaps = [
      {
        mode = "n";
        key = "<leader>p";
        action = "<cmd>MarkdownPreviewToggle<cr>";
        options = {
          silent = true;
          desc = "Markdown内容预览";
        };
      }
    ];
  };
}
