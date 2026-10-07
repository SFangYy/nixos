{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.llmMemory;
in
{
  imports = [ ./ai.nix ./sops.nix ];

  options.programs.llmMemory = {
    enable = lib.mkEnableOption "the personal LiteLLM proxy";

    projectDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.home.username}/work/llm-memory";
      description = "Path to the llm-memory application repository.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4000;
      description = "Local port for the LiteLLM endpoint.";
    };

    litellmCommand = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.projectDir}/.venv/bin/litellm";
      description = "LiteLLM executable, normally from the project's virtualenv.";
    };

    apiBases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        OPENAI_KXY_API_BASE = "http://172.28.11.121:18080/";
        OPENAI_UNITYCHIP_API_BASE = "https://gateway.light-rain.top/v1";
        MINIMAX_API_BASE = "https://replace-with-minimax-api-base/v1";
      };
      description = "Non-secret OpenAI-compatible provider base URLs.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isLinux;
        message = "programs.llmMemory currently requires Linux systemd user services.";
      }
    ];

    systemd.user.services.litellm = {
      Unit = {
        Description = "LiteLLM OpenAI-compatible proxy";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Service = {
        ExecStart = "${cfg.litellmCommand} --config ${cfg.projectDir}/config/litellm.yaml --host 127.0.0.1 --port ${toString cfg.port}";
        # Keep this independent of the venv's Python minor version. The proxy
        # needs Python 3.13 because Prisma's generated client is incompatible
        # with Python 3.14.
        WorkingDirectory = cfg.projectDir;
        EnvironmentFile = config.sops.templates."llm-memory.env".path;
        Environment =
          (lib.mapAttrsToList (name: value: "${name}=${value}") cfg.apiBases)
          ++ [
            "LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib"
            "PYTHONPATH=${cfg.projectDir}/src"
            "PATH=${pkgs.python313}/bin:/home/${config.home.username}/.cache/prisma-python/binaries/5.17.0/393aa359c9ad4a4bb28630fb5613f9c281cde053/node_modules/.bin:${cfg.projectDir}/.venv/bin:${pkgs.coreutils}/bin:${pkgs.bash}/bin:${pkgs.openssl}/bin:${pkgs.nodejs}/bin"
            "DATABASE_URL=postgresql://sfangyy@127.0.0.1:5432/litellm"
            "PRISMA_QUERY_ENGINE_BINARY=/home/${config.home.username}/.cache/prisma-python/binaries/5.17.0/393aa359c9ad4a4bb28630fb5613f9c281cde053/node_modules/prisma/query-engine-debian-openssl-3.0.x"
            "PRISMA_SCHEMA_ENGINE_BINARY=/home/${config.home.username}/.cache/prisma-python/binaries/5.17.0/393aa359c9ad4a4bb28630fb5613f9c281cde053/node_modules/prisma/schema-engine-debian-openssl-3.0.x"
            "PRISMA_QUERY_ENGINE_LIBRARY=/home/${config.home.username}/.cache/prisma-python/binaries/5.17.0/393aa359c9ad4a4bb28630fb5613f9c281cde053/node_modules/prisma/libquery_engine-debian-openssl-3.0.x.so.node"
            "PRISMA_BINARY_PLATFORM=debian-openssl-3.0.x"
            "PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING=1"
            "NO_PROXY=localhost,127.0.0.1,::1"
            "no_proxy=localhost,127.0.0.1,::1"
            "DISABLE_SCHEMA_UPDATE=true"
          ];
        Restart = "on-failure";
        RestartSec = 5;
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
