{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.antigravity-cli = {
    enable = true;
  };
  programs.claude-code = {
    enable = true;
  };
  home.sessionVariables = {
    #GEMINI_API_KEY = "$(cat ${config.age.secrets.gemini_token.path})";
    #ANTHROPIC_AUTH_TOKEN = "$(cat ${config.age.secrets.anyrouter_token.path})";
    ANTHROPIC_BASE_URL = "https://anyrouter.top";
    #SILICONFLOW_API_KEY = "$(cat ${config.age.secrets.siliconflow_token.path})";
  };
  home.packages = with pkgs; [
    codex
    gitingest
  ];
}
