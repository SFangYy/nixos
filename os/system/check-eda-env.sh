# Run with: ue bash /path/to/check-eda-env.sh
set -euo pipefail
for tool in vcs verdi verilator swig cmake g++ python3; do
    command -v "$tool"
done
verilator --version
python3 - <<'PYTHON'
import sys
print("Python:", sys.version)
PYTHON
