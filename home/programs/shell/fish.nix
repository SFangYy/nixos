{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs = {
    bash = {
      enable = true;

      # Keep the login shell POSIX-compatible for SSH/VS Code Remote-SSH.
      # Only interactive bash sessions are replaced by fish.
      initExtra = ''
        if [[ $- == *i* ]] && command -v fish >/dev/null 2>&1; then
          exec fish
        fi
      '';
    };
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
        nixc = "sudo systemctl start nh-clean.service";
      });
      shellAliases = {
        "ls" = "exa";
        "l" = "exa -lah --icons=auto";
        "docker" = "podman";
      };
      shellInit = ''
        export PATH="$HOME/.local/bin:$HOME/.juliaup/bin:$PATH"

        # The formal FHS environment exports its dedicated picker wrapper.
        # Re-prepend it after the user-local PATH setup above so a globally
        # installed picker cannot shadow the formal-specific version.
        if test -n "$FORMAL_PICKER_BIN"
          set -gx PATH "$FORMAL_PICKER_BIN" $PATH
        end

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
        codex-api = ''
          set -l codex_home "$HOME/.codex-api"
          command mkdir -p -- "$codex_home"; or return
          set -lx CODEX_HOME "$codex_home"
          command codex $argv
        '';
        codex-auth = ''
          set -l codex_home "$HOME/.codex-auth"
          command mkdir -p -- "$codex_home"; or return
          set -lx CODEX_HOME "$codex_home"
          command codex $argv
        '';
        fnos = ''
          /home/${config.home.username}/scripts/mount-fnos $argv
        '';
      };
    };
  };
  programs.man.generateCaches = false;
}
