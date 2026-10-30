# Run with: ue bash /path/to/check-eda-env.sh
set -euo pipefail
for tool in vcs verdi picker verilator swig cmake g++ python3 pytest; do
    command -v "$tool"
done
picker --version
picker --check
verilator --version
python3 - <<'PYTHON'
import sys
import toffee
import toffee_test
import xspcomm
print("Python:", sys.version)
print("Toffee:", toffee.__file__)
print("Toffee-test:", toffee_test.__file__)
print("xspcomm:", xspcomm.__file__)
PYTHON
