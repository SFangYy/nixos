set -euo pipefail
python="$LITELLM_PROJECT_DIR/.venv/bin/python"
[[ -x "$python" && -x "$LITELLM_COMMAND" ]] || {
  echo 'LiteLLM virtual environment is missing; create it with Python 3.13.' >&2
  exit 1
}
version=$("$python" -c 'import sys; print("%d.%d" % sys.version_info[:2])')
[[ $version == 3.13 ]] || { echo "LiteLLM requires Python 3.13, found $version." >&2; exit 1; }
engine_dir=$("$python" -c 'from prisma._config import config; print(config.binary_cache_dir)')
export PRISMA_QUERY_ENGINE_BINARY="$engine_dir/node_modules/prisma/query-engine-debian-openssl-3.0.x"
export PRISMA_SCHEMA_ENGINE_BINARY="$engine_dir/node_modules/prisma/schema-engine-debian-openssl-3.0.x"
export PRISMA_QUERY_ENGINE_LIBRARY="$engine_dir/node_modules/prisma/libquery_engine-debian-openssl-3.0.x.so.node"
for engine in "$PRISMA_QUERY_ENGINE_BINARY" "$PRISMA_SCHEMA_ENGINE_BINARY" "$PRISMA_QUERY_ENGINE_LIBRARY"; do
  [[ -f "$engine" ]] || { echo "Prisma engine is missing: $engine; regenerate the project's Prisma client." >&2; exit 1; }
done
export PATH="$engine_dir/node_modules/.bin:$LITELLM_PROJECT_DIR/.venv/bin:$PATH"
[[ ${1:-} != --check ]] || exit 0
exec "$LITELLM_COMMAND" --config "$LITELLM_PROJECT_DIR/config/litellm.yaml" --host 127.0.0.1 --port "$LITELLM_PORT" "$@"
