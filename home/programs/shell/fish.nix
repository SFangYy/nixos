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
        # Desktop-launched terminals can inherit an incomplete PATH even when
        # NixOS profile initialization is marked done. Append missing profile
        # directories so existing development environment priorities survive.
        if [[ -d /run/current-system/sw/bin ]]; then
          for nix_profile_bin in \
            "$HOME/.local/bin" \
            /run/wrappers/bin \
            "$HOME/.nix-profile/bin" \
            "''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profile/bin" \
            "/etc/profiles/per-user/$USER/bin" \
            /nix/var/nix/profiles/default/bin \
            /run/current-system/sw/bin; do
            case ":$PATH:" in
              *":$nix_profile_bin:"*) ;;
              *) export PATH="''${PATH:+$PATH:}$nix_profile_bin" ;;
            esac
          done
          unset nix_profile_bin
        fi

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
      }
      // (
        if pkgs.stdenv.isLinux then
          {
            # NixOS Specific
            nixu = "NH_ELEVATION_STRATEGY=sudo nh os switch --ask";
            nixc = "sudo systemctl start nh-clean.service";
          }
        else
          {
            # macOS Specific
            homeu = "home-manager switch --flake .#fy";
          }
      );
      shellAliases = {
        "ls" = "eza";
        "l" = "eza -lah --icons=auto";
        "analyze" = "ls *.Rmd | fzf | xargs -I {} R -e \"rmarkdown::render('{}', quiet = FALSE)\"";
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

        if test (uname) = Darwin
          if not set -q DISPLAY
            set -l launchd_display (/bin/launchctl getenv DISPLAY 2>/dev/null)
            if test -n "$launchd_display"
              set -x DISPLAY "$launchd_display"
            else if test -x /opt/X11/bin/Xquartz
              set -x DISPLAY :0
            end
          end
        end

        set -g fish_color_command blue --italics
        set -g fish_color_quote yellow --italics
        set -g fish_key_bindings fish_vi_key_bindings

        # Vi mode tuning: raise the escape timeout so Esc reliably enters
        # normal mode over SSH/tmux, and shape the cursor per vi mode.
        set -g fish_escape_delay_ms 300
        set -g fish_cursor_default block blink
        set -g fish_cursor_insert line blink
        set -g fish_cursor_visual block
        set -g fish_cursor_replace_one underscore blink
      '';
      interactiveShellInit = ''
        # Initialize pay-respects (command correction tool)
        if type -q pay-respects
          pay-respects fish --alias | source
        end

        # fzf.fish: rebind away from fish defaults. File search moves from
        # Ctrl+f (accepts autosuggestions) to Ctrl+t; git log moves from
        # Ctrl+l (clear screen) to Alt+l. Unspecified bindings keep defaults
        # (Ctrl+r history, Ctrl+g git status, Ctrl+v variables).
        if functions -q fzf_configure_bindings
          fzf_configure_bindings --directory=\ct --git_log=\el
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
        {
          name = "fzf-fish";
          src = fzf-fish.src;
        }
        {
          # Colorize interactive output of systemctl, journalctl, ping, ...
          # Wrappers defined at conf.d time are overridden by the later
          # `ls` alias in config.fish, so eza still wins.
          name = "grc";
          src = grc.src;
        }
      ];
      functions = {
        fish_greeting = "";
        # Default config uses API; auth.config.toml selects ChatGPT login.
        # Keep shared sessions and bypass the failing proxy only for this API host.
        codex = ''
          set -lx NO_PROXY "$NO_PROXY,api.kxyai.top"
          set -lx no_proxy "$no_proxy,api.kxyai.top"
          command codex $argv
        '';
        codex-api = ''
          codex $argv
        '';
        codex-auth = ''
          command codex --profile auth $argv
        '';
        fnos = ''
          ${config.home.homeDirectory}/scripts/mount-fnos $argv
        '';
        # Toggle terminal proxies. git/ssh already route via 127.0.0.1:7890;
        # this covers curl/pip/go and other tools that read the environment.
        proxy = ''
          if test "$argv" = off
            set -e http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
            echo "proxy off"
          else
            set -gx http_proxy http://127.0.0.1:7890
            set -gx https_proxy http://127.0.0.1:7890
            set -gx all_proxy socks5://127.0.0.1:7890
            echo "proxy on"
          end
        '';
      };
    };

    # Multi-shell completion engine: structured Tab completions for hundreds
    # of commands layered on top of fish's native completions.
    carapace.enable = true;

    # Auto-load .envrc on cd; nix-direnv caches `use flake` dev shells so
    # re-entering a project is instant.
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  programs.man.generateCaches = false;
}
