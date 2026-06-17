{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs = {
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    fish = {
      enable = true;
      shellAbbrs = {
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
        gcl = "git clone";
        glog = "git log --oneline --graph --decorate";

        # Navigation & Files
        ".." = "cd ..";
        "..." = "cd ../..";
        md = "mkdir -p";

        # SSH
        s = "ssh";
        sa = "ssh-add";
        sl = "ssh-add -l";
        s3 = "ssh songfangyuan@172.19.20.3";

        vim = "nvim";
        n = "nvim";
        vi = "nvim";
      } // (pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        # NixOS Specific
        nixu = "NH_ELEVATION_STRATEGY=sudo nh os switch --ask";
        homeu = "nh home switch --ask";
        nixc = "sudo systemctl start nh-clean.service";
      });
      shellAliases = {
        "ls" = "exa";
        "l" = "exa -lah --icons=auto";
        "docker" = "podman";
      };
      shellInit = ''
        export PATH="$HOME/.local/bin:$HOME/.juliaup/bin:$PATH"

        if test -n "$container"
          export PATH="$HOME/.local/bin:$HOME/.juliaup/bin:$HOME/.npm-global/bin:$PATH"
          if test -f /home/linuxbrew/.linuxbrew/bin/brew
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"
          end
        end

        set -g fish_color_command blue --italics
        set -g fish_color_quote yellow --italics
        set -g fish_key_bindings fish_vi_key_bindings
      '';
      interactiveShellInit = ''
        # Initialize pay-respects (command correction tool)
        if type -q pay-respects
          pay-respects fish --alias | source
        end

        # Toggle sudo with Alt+s
        function __toggle_sudo
            set -l cmd (commandline)
            [ -z "$cmd" ] && set cmd $history[1]
            if string match -q "sudo *" "$cmd"
                commandline -r (string replace -r '^sudo ' "" "$cmd")
            else
                commandline -r "sudo $cmd"
            end
        end
        bind \es __toggle_sudo
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
        fnos = ''
          /home/${config.home.username}/scripts/mount-fnos $argv
        '';
      };
    };
  };
  programs.man.generateCaches = false;
}
