# Personal LLM secrets and LiteLLM

This module contains the personal LLM tools, LiteLLM service, and SOPS secret wiring.

1. Add `sops-nix` to the flake inputs and rebuild to obtain its module.
2. Copy `secrets.example.yaml` to `secrets.yaml` and encrypt it with SOPS/age.
3. Set `programs.llmMemory.enable = true;` in the Linux host's Home Manager module.
4. Set the three provider API bases with `programs.llmMemory.apiBases`; API keys belong only in the encrypted SOPS file.

`ai.nix` contains the existing LLM-related CLI tools and provider defaults. `sops.nix` contains only the encrypted-secret declarations and runtime environment template.

The SOPS module uses the dedicated age identity at `~/.config/sops/age/keys.txt`. Keep that private key outside this repository and back it up securely. `secrets.yaml` must contain only SOPS-encrypted values before it is added to Git.

Create and edit the encrypted file from the repository root:

```bash
cp home/programs/llm/secrets.example.yaml home/programs/llm/secrets.yaml
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops --encrypt --in-place home/programs/llm/secrets.yaml
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops home/programs/llm/secrets.yaml
```

Do not enable the module until `secrets.yaml` has been encrypted and added to Git. Flakes only see tracked files when they evaluate the repository.

The service runs as a user systemd service on `127.0.0.1:4000` and uses the project repository's non-secret `config/litellm.yaml`.

The startup wrapper checks for Python 3.13 and discovers the engine cache from
the installed Prisma client, so a client upgrade does not leave stale revision
paths in the Nix configuration. Missing engines fail with a regeneration hint.
PostgreSQL uses the local Unix socket with peer authentication instead of a TCP
`trust` rule; ownership is ensured after the database role exists.
