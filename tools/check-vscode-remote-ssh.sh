#!/usr/bin/env bash

# Read-only diagnostic helper for VS Code Remote-SSH on NixOS.
# It only creates and removes a uniquely named temporary directory under $HOME
# to verify that the SSH user can write there.

set -u

section() {
    printf '\n===== %s =====\n' "$1"
}

run() {
    printf '+ %s\n' "$*"
    "$@"
}

section 'basic identity and environment'
printf 'date: '; date
printf 'user: '; id
printf 'HOME=%s\n' "${HOME:-<unset>}"
printf 'SHELL=%s\n' "${SHELL:-<unset>}"
printf 'PATH=%s\n' "${PATH:-<unset>}"
printf 'PWD=%s\n' "$PWD"

section 'home directory ownership and write test'
run ls -ld "${HOME:-.}"
if [[ -n "${HOME:-}" ]] && [[ -d "$HOME" ]]; then
    if [[ -w "$HOME" ]]; then
        echo 'shell reports: HOME is writable'
    else
        echo 'shell reports: HOME is NOT writable'
    fi

    test_dir="$HOME/.vscode-remote-ssh-check-$$"
    if mkdir "$test_dir" 2>/tmp/vscode-ssh-check-mkdir.err &&
       touch "$test_dir/test-file" 2>/tmp/vscode-ssh-check-touch.err; then
        echo 'create test: OK (VS Code Server can create files under HOME)'
        rm -f "$test_dir/test-file"
        rmdir "$test_dir"
    else
        echo 'create test: FAILED'
        [[ -s /tmp/vscode-ssh-check-mkdir.err ]] && sed 's/^/mkdir: /' /tmp/vscode-ssh-check-mkdir.err
        [[ -s /tmp/vscode-ssh-check-touch.err ]] && sed 's/^/touch: /' /tmp/vscode-ssh-check-touch.err
        rm -f "$test_dir/test-file" 2>/dev/null || true
        rmdir "$test_dir" 2>/dev/null || true
    fi
else
    echo 'HOME is unset or is not a directory'
fi

section 'filesystem mount status'
if command -v findmnt >/dev/null 2>&1; then
    run findmnt -T "${HOME:-/}" -o TARGET,SOURCE,FSTYPE,OPTIONS
else
    run mount
fi

section 'disk and inode usage'
run df -h "${HOME:-/}" /tmp
run df -ih "${HOME:-/}" /tmp

section 'NixOS and nix-ld'
command -v nixos-version >/dev/null 2>&1 && run nixos-version || echo 'nixos-version: not found'
if command -v nixos-option >/dev/null 2>&1; then
    run nixos-option programs.nix-ld.enable
else
    echo 'nixos-option: not found'
fi
printf 'nix-ld executable: '
command -v nix-ld || echo 'not found in PATH'

section 'required commands'
for command_name in bash sh tar gzip curl wget; do
    printf '%-8s ' "$command_name"
    command -v "$command_name" || echo 'NOT FOUND'
done

section 'default shell and non-interactive shell output'
getent passwd "$(id -un)" 2>/dev/null || true
printf '%s\n' '-- bash --'
bash -c 'printf "bash start\n"; printf "bash end\n"' 2>&1 || true
if command -v fish >/dev/null 2>&1; then
    printf '%s\n' '-- fish --'
    fish -c 'printf "fish start\n"; printf "fish end\n"' 2>&1 || true
fi

section 'VS Code Server files and processes'
if [[ -d "${HOME:-}/.vscode-server" ]]; then
    run ls -lad "$HOME/.vscode-server"
    find "$HOME/.vscode-server" -type f \( -name '*.log' -o -name 'log.txt' \) -print 2>/dev/null |
        while IFS= read -r log_file; do
            printf '%s\n' "--- $log_file (last 120 lines)"
            tail -n 120 "$log_file"
        done
else
    echo "$HOME/.vscode-server does not exist"
fi
ps -ef | grep -E 'vscode-server|server-main|code-server' | grep -v grep || echo 'no VS Code Server process found'

section 'shell startup files (first 160 lines)'
for startup_file in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile" "$HOME/.zshrc" "$HOME/.config/fish/config.fish"; do
    if [[ -f "$startup_file" ]]; then
        printf '%s\n' "--- $startup_file"
        sed -n '1,160p' "$startup_file"
    fi
done

section 'interpretation'
cat <<'EOF'
Look for these results:
  - create test FAILED with "Read-only file system": the actual HOME filesystem is read-only.
  - HOME is writable but default shell is fish: test with bash as the login shell; VS Code Remote-SSH expects POSIX shell behavior.
  - nix-ld is false/not found, or logs mention ld-linux/shared libraries: enable programs.nix-ld.enable and rebuild.
  - ~/.vscode-server does not exist: installation failed before Server startup; inspect the VS Code Remote-SSH trace log and shell output.
EOF

rm -f /tmp/vscode-ssh-check-mkdir.err /tmp/vscode-ssh-check-touch.err
echo
echo 'Diagnostic complete. No NixOS or Home Manager configuration was changed.'
