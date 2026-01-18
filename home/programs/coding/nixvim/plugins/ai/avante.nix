{
  programs.nixvim = {
    plugins.avante.enable = true;
    plugins.avante.lazyLoad = {
      enable = true;
      settings = {
        event = [
          "InsertEnter"
          "CmdlineEnter"
        ];
        cmd = ["AvanteFocus" "AvanteRefresh" "AvanteToggle" "AvanteModels" "AvanteAsk" "AvanteEdit" "AvanteStop"];
      };
    };
    plugins.avante.settings = {
      # NOTE: AI行内补全,强烈不建议开启
      # auto_suggestions_provider = "deepseek";
      # behaviour = {
      #   auto_suggestions = true; # 实验阶段
      # };
      suggestion = {
        debounce = 600; # 可调整防抖时间
        throttle = 600;
      };
      provider = "deepseek";
      providers = {
        deepseek = {
          __inherited_from = "openai";
          api_key_name = "DEEPSEEK_API_KEY";
          endpoint = "https://api.deepseek.com";
          model = "deepseek-coder";
        };
        qianwen = {
          __inherited_from = "openai";
          api_key_name = "DASHSCOPE_API_KEY";
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1";
          model = "qwen3-max";
        };
        openrouter = {
          __inherited_from = "openai";
          endpoint = "https://openrouter.ai/api/v1";
          api_key_name = "OPENROUTER_API_KEY";
          model = "deepseek/deepseek-r1";
        };
        claude = {
          endpoint = "https://api.anthropic.com";
          model = "claude-sonnet-4-20250514";
          timeout = 30000;
          extra_request_body = {
            temperature = 0.75;
            max_tokens = 64000;
          };
        };
        openai = {
          endpoint = "https://api.openai.com/v1";
          model = "gpt-4o";
          timeout = 30000;
          extra_request_body = {
            temperature = 0.75;
            max_completion_tokens = 16384;
          };
        };
      };
      windows = {
        edit = {
          border = "rounded"; # 可选: "single"; "double"; "rounded"; "solid"; 或自定义边框字符数组
          start_insert = true;
        };
        ask = {
          floating = false;
          border = "single";
          start_insert = true;
        };
        sidebar_header = {
          enabled = true;
          align = "center";
          rounded = true;
        };
      };
    };
  };
}
