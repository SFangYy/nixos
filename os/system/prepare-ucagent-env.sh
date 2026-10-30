# Load UCAgent from the canonical checkout, updating dependencies by content.
# UCAgent is optional in the shared environment: accounts without a checkout
# get plain VCS/Verdi tooling. Export UCAGENT_REQUIRED=1 to restore the strict
# behavior.
prepare_ucagent_env() {
  export UCAGENT_ROOT="${UCAGENT_ROOT:-$HOME/work/XSV/repos/UCAgent}"
  local venv="$UCAGENT_ROOT/.venv"
  if [[ ! -f "$UCAGENT_ROOT/pyproject.toml" || ! -f "$UCAGENT_ROOT/requirements.txt" ]]; then
    if [[ -z "${UCAGENT_REQUIRED:-}" ]]; then
      echo "UCAgent checkout not found at $UCAGENT_ROOT; skipping UCAgent setup." >&2
      return 0
    fi
    echo "UCAgent checkout is missing: $UCAGENT_ROOT" >&2
    return 1
  fi
  # Recreate stale UCAgent environments when the configured Picker/Python ABI
  # changes. An existing 3.13 venv must not survive after UE switches to the
  # Python 3.12 toolchain used by Picker/CMake.
  if [[ -x "$venv/bin/python" && -x "${UCAGENT_PYTHON:-python3}" ]]; then
    current_tag=$("$venv/bin/python" -c 'import sys; print(sys.implementation.cache_tag)' 2>/dev/null || true)
    expected_tag=$("${UCAGENT_PYTHON:-python3}" -c 'import sys; print(sys.implementation.cache_tag)' 2>/dev/null || true)
    if [[ -n "$current_tag" && -n "$expected_tag" && "$current_tag" != "$expected_tag" ]]; then
      echo "Recreating UCAgent venv for Python ABI $expected_tag (was $current_tag)." >&2
      rm -rf -- "$venv"
    fi
  fi
  if [[ ! -x "$venv/bin/python" ]]; then
    uv venv --python "${UCAGENT_PYTHON:-python3}" "$venv" || return 1
  fi

  local fingerprint installed
  fingerprint=$({
      sha256sum "$UCAGENT_ROOT/requirements.txt" "$UCAGENT_ROOT/pyproject.toml"
      "$venv/bin/python" - <<'PY'
import sys
print(sys.implementation.cache_tag)
print(sys.version_info[:3])
PY
  } | sha256sum | cut -d ' ' -f1)
  installed=$(cat "$venv/.ucagent-dependencies.sha256" 2>/dev/null || true)
  if [[ "$fingerprint" != "$installed" ]]; then
    local requirements_file="$UCAGENT_ROOT/requirements.txt"
    local local_toffee="$HOME/work/XSV/repos/toffee"
    local local_toffee_test="$HOME/work/XSV/repos/toffee-test"
    local temp_requirements=""
    if [[ -d "$local_toffee" && -d "$local_toffee_test" ]]; then
      temp_requirements=$(mktemp "${TMPDIR:-/tmp}/ucagent-requirements.XXXXXX") || return 1
      sed \
        -e "s#^pytoffee@.*#${local_toffee}#" \
        -e "s#^toffee-test@.*#${local_toffee_test}#" \
        "$requirements_file" > "$temp_requirements"
      requirements_file="$temp_requirements"
      trap 'rm -f -- "${temp_requirements:-}"' RETURN
    fi
    if [[ -n "$temp_requirements" ]]; then
      uv pip install --python "$venv/bin/python" -r "$requirements_file" || return 1
      uv pip install --python "$venv/bin/python" -e "$UCAGENT_ROOT" --no-deps || return 1
    else
      uv pip install --python "$venv/bin/python" -e "$UCAGENT_ROOT" || return 1
    fi
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
