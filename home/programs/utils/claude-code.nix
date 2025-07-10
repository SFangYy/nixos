{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [ claude-code ];
    sessionVariables = {
      ANTHROPIC_BASE_URL = "https://anyrouter.top";
      ANTHROPIC_AUTH_TOKEN = "$(cat ${config.age.secrets.anyrouter_token.path})";
    };
  };
}
