{
  config,
  pkgs,
  lib,
  ...
}:
{
  age.identityPaths = [
    "${config.home.homeDirectory}/.ssh/id_rsa"
  ];

  # Flake metadata is fetched by the client, not only by the daemon. Keep its
  # authenticated configuration private and out of the world-readable store.
  xdg.configFile."nix/nix.conf".text = ''
    !include ${config.xdg.configHome}/nix/access-tokens.conf
  '';
  home.activation.nixGithubToken = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -z "''${DRY_RUN:-}" ]]; then
      token="$(${pkgs.age}/bin/age --decrypt \
        -i ${lib.escapeShellArg "${config.home.homeDirectory}/.ssh/id_rsa"} \
        ${./github-token.age})"
      token_dir=${lib.escapeShellArg "${config.xdg.configHome}/nix"}
      mkdir -p "$token_dir"
      chmod 700 "$token_dir"
      token_tmp="$(umask 077; ${pkgs.coreutils}/bin/mktemp "$token_dir/.access-tokens.XXXXXX")"
      printf 'access-tokens = github.com=%s\n' "$token" > "$token_tmp"
      chmod 600 "$token_tmp"
      mv -f "$token_tmp" "$token_dir/access-tokens.conf"
      unset token
    fi
  '';
}
