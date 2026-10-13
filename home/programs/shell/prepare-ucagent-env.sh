# Load UCAgent from the canonical checkout, updating dependencies by content.
prepare_ucagent_env() {
  export UCAGENT_ROOT="${UCAGENT_ROOT:-$HOME/work/XSV/repos/UCAgent}"
  local venv="$UCAGENT_ROOT/.venv"
  if [[ ! -f "$UCAGENT_ROOT/pyproject.toml" || ! -f "$UCAGENT_ROOT/requirements.txt" ]]; then
    echo "UCAgent checkout is missing: $UCAGENT_ROOT" >&2
    return 1
  fi
  if [[ ! -x "$venv/bin/python" ]]; then
    uv venv --python "${UCAGENT_PYTHON:-python3}" "$venv" || return 1
  fi
  local fingerprint installed
  fingerprint=$({
    sha256sum "$UCAGENT_ROOT/requirements.txt" "$UCAGENT_ROOT/pyproject.toml"
    "$venv/bin/python" --version
  } | sha256sum | cut -d ' ' -f1)
  installed=$(cat "$venv/.ucagent-dependencies.sha256" 2>/dev/null || true)
  if [[ "$fingerprint" != "$installed" ]]; then
    uv pip install --python "$venv/bin/python" -e "$UCAGENT_ROOT" || return 1
    printf '%s\n' "$fingerprint" > "$venv/.ucagent-dependencies.sha256"
  fi
  local rpath_fingerprint sofile failed=0
  rpath_fingerprint=$(printf '%s' "$fingerprint:${UCAGENT_WHEEL_RPATH:-}" | sha256sum | cut -d ' ' -f1)
  if [[ -n "${UCAGENT_WHEEL_RPATH:-}" && "$rpath_fingerprint" != "$(cat "$venv/.ucagent-rpath.sha256" 2>/dev/null || true)" ]]; then
    while IFS= read -r -d '' sofile; do
      case "$sofile" in */._*) continue ;; esac
      if ! "${UCAGENT_PATCHELF:-patchelf}" --add-rpath "$UCAGENT_WHEEL_RPATH" "$sofile"; then
        echo "Failed to patch wheel: $sofile" >&2
        failed=1
      fi
    done < <(find "$venv/lib" \( -name '*.so' -o -name '*.so.*' \) -print0)
    [[ $failed -eq 0 ]] || return 1
    printf '%s\n' "$rpath_fingerprint" > "$venv/.ucagent-rpath.sha256"
  fi
  # This activation file is generated at runtime by uv.
  # shellcheck disable=SC1091
  source "$venv/bin/activate"
  export PYTHONPATH="$UCAGENT_ROOT${PYTHONPATH:+:$PYTHONPATH}"
}
prepare_ucagent_env
