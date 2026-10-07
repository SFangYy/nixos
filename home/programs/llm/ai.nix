{
  pkgs,
  ...
}:
{
  programs.antigravity-cli.enable = true;
  programs.claude-code.enable = true;

  home.sessionVariables = {
    # Keep provider credentials in sops-nix; do not put them in Nix strings.
    ANTHROPIC_BASE_URL = "https://anyrouter.top";
  };

  home.packages = with pkgs; [
    codex
    uv
    gitingest
    opencode
    pi-coding-agent
  ];
}
