{ pkgs, inputs, ... }:
{
  programs = {
    fish = {
      enable = true;
      package = inputs.nixpkgs-fish.legacyPackages.${pkgs.system}.fish;
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
        export PATH="$HOME/.local/bin:$HOME/.juliaup/bin:$PATH"
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
        # fish_command_not_found =
        #   /*
        #   fish
        #   */
        #   ''
        #     function fish_command_not_found
        #         if test -e /run/.containerenv -o -e /.dockerenv
        #             distrobox-host-exec $argv
        #         else
        #             __fish_default_command_not_found_handler $argv
        #         end
        #     end
        #   '';
      };
    };
  };
  programs.man.generateCaches = false;
}
