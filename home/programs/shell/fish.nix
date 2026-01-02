{ pkgs, inputs, ... }:
{
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        nixu = "nh os switch --ask";
        homeu = "nh home switch --ask";
        nixc = "doas systemctl start nh-clean.service";
        vim = "nvim";
        cd = "z";
      };
      shellAliases = {
        "ls" = "exa";
        "l" = "exa -lah --icons=auto";
      };
      shellInit = ''
        zoxide init fish | source
        set -x VCS_HOME $HOME/EDAHome/vcs/W-2024.09-SP1
        set -x VERDI_HOME $HOME/EDAHome/verdi/W-2024.09-SP1	
        set -x UVMC_UVMC $HOME/EDAHome/uvmc
        export PATH="$HOME/.local/bin:$VCS_HOME/bin:$VERDI_HOME/bin:$HOME/.juliaup/bin:$PATH"
        set -g fish_color_command = blue --italics
        set -g fish_color_quote = yellow --italics
      '';
      plugins = with pkgs.fishPlugins; [
        {
          name = "puffer";
          src = puffer.src;
        }
        {
          name = "pisces";
          src = pisces.src;
        }
      ];
      functions = {
        fish_greeting = "";
      };
    };
  };
  programs.man.generateCaches = false;
}
