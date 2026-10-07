{ config, lib, ... }:
let
  cfg = config.programs.llmMemory;
in
{
  config = lib.mkIf cfg.enable {
    # Keep the encrypted file in the flake source so pure evaluation can read it.
    sops.defaultSopsFile = ./secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    sops.secrets = {
      litellm_master_key = { };
      openai_kxy_api_key = { };
      openai_unitychip_api_key = { };
      minimax_api_key = { };
    };

    sops.templates."llm-memory.env" = {
      content = ''
        LITELLM_MASTER_KEY=${config.sops.placeholder.litellm_master_key}
        UI_USERNAME=admin
        UI_PASSWORD=${config.sops.placeholder.litellm_master_key}
        OPENAI_KXY_API_KEY=${config.sops.placeholder.openai_kxy_api_key}
        OPENAI_UNITYCHIP_API_KEY=${config.sops.placeholder.openai_unitychip_api_key}
        MINIMAX_API_KEY=${config.sops.placeholder.minimax_api_key}
      '';
      mode = "0400";
    };
  };
}
