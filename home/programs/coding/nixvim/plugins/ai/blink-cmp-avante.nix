{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      blink-cmp-avante
    ];

    extraConfigLua = ''
      require("lz.n").load {
        {
          "blink-cmp-avante",
          event = { "InsertEnter", "CmdlineEnter" },
          after = function()
            require("blink-cmp-avante")
          end,
        }
      }
    '';
  };
}
