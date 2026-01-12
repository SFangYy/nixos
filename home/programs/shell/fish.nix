{ pkgs, inputs, ... }:
{
  programs = {
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    fish = {
      enable = true;
      shellAbbrs = {
        # Nix
        nixu = "nh os switch --ask";
        homeu = "nh home switch --ask";
        nixc = "doas systemctl start nh-clean.service";

        # Git
        g = "git";
        ga = "git add";
        gc = "git commit -m";
        gp = "git push";
        gl = "git pull";
        gst = "git status";
        gd = "git diff";
        gb = "git branch";
        gco = "git checkout";

        # SSH
        s = "ssh";
        sa = "ssh-add";
        sl = "ssh-add -l";

        # Others
        vim = "nvim";
        n = "nvim";
        vi = "nvim";
      };
      shellAliases = {
        "ls" = "exa";
        "l" = "exa -lah --icons=auto";
      };
      shellInit = ''
        export PATH="$HOME/.local/bin:$HOME/.juliaup/bin:$PATH"
        set -g fish_color_command = blue --italics
        set -g fish_color_quote = yellow --italics
      '';
      interactiveShellInit = ''
        # Initialize pay-respects (command correction tool)
        pay-respects fish --alias | source
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
