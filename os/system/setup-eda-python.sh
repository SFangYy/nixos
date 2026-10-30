# Invoked by ue-setup-python inside the UE FHS environment.
set -euo pipefail

venv="${UE_PYTHON_ENV:-$HOME/.local/share/ue/venv}"
python="${UE_PYTHON:-python3}"
if [[ ! -x "$venv/bin/python" ]]; then
    uv venv --python "$python" "$venv"
fi

# Prefer locally prepared wheels; allow explicit package/source arguments.
if [[ $# -eq 0 ]]; then
    wheels="${UE_EDA_ROOT:-/opt/eda}/wheels"
    if [[ -d "$wheels" ]]; then
        shopt -s nullglob
        packages=("$wheels"/*.whl)
        shopt -u nullglob
    else
        packages=()
    fi
    if [[ ${#packages[@]} -eq 0 ]]; then
        packages=(pytoffee toffee-test)
    fi
else
    packages=("$@")
fi
install_options=()
if [[ -d "${UE_EDA_ROOT:-/opt/eda}/wheels" ]]; then
    install_options+=(--no-index --find-links "${UE_EDA_ROOT:-/opt/eda}/wheels")
fi
uv pip install --python "$venv/bin/python" "${install_options[@]}" "${packages[@]}"
uv pip check --python "$venv/bin/python"
"$venv/bin/python" -c 'import toffee, toffee_test; print("Toffee and toffee-test imports OK")'
printf 'Python environment ready: %s\nRe-enter ue to activate it.\n' "$venv"
