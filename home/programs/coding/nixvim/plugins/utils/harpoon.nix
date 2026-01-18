{
  programs.nixvim = {
    plugins.harpoon.enable = true;
    plugins.harpoon.lazyLoad = {
      enable = true;
      settings = {
        event = ["User LazyFile"];
      };
    };
    plugins.harpoon.settings = {
      settings = {
        save_on_toggle = true;
        save_on_change = true;
      };
    };

    keymaps = [
    {
      action.__raw = ''
        function()
        	require("harpoon"):list():add()
        end
      '';
      key = "<leader>ma";
      options = {
        silent = true;
        desc = "添加标记";
      };
    }

    {
      action.__raw = ''
        function()
        	require("harpoon"):list():remove()
        end
      '';
      key = "<leader>md";
      options = {
        silent = true;
        desc = "移除标记";
      };
    }

    {
      action.__raw = ''
        function()
        	require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end
      '';
      key = "<leader>mm";
      options = {
        silent = true;
        desc = "切换Harpoon菜单";
      };
    }

    {
      action.__raw = ''
        function()
          require("harpoon"):list():select(1)
        end
      '';
      key = "<leader>m1";
      options = {
        silent = true;
        desc = "跳转标记1";
      };
    }

    {
      action.__raw = ''
        function()
          require("harpoon"):list():select(2)
        end
      '';
      key = "<leader>m2";
      options = {
        silent = true;
        desc = "跳转标记2";
      };
    }

    {
      action.__raw = ''
        function()
          require("harpoon"):list():select(3)
        end
      '';
      key = "<leader>m3";
      options = {
        silent = true;
        desc = "跳转标记3";
      };
    }

    {
      action.__raw = ''
        function()
          require("harpoon"):list():prev()
        end
      '';
      key = "<leader>m[";
      options = {
        silent = true;
        desc = "上一个标记";
      };
    }

    {
      action.__raw = ''
        function()
          require("harpoon"):list():next()
        end
      '';
      key = "<leader>m]";
      options = {
        silent = true;
        desc = "下一个标记";
      };
    }
  ];
  };
}
