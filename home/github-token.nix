{ config, lib, ... }:
let
  secretPath = config.age.secrets.github_token.path;
  confPath = "${config.home.homeDirectory}/.config/nix/access-tokens.conf";
in
{
  home.activation.createNixAccessTokens = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f "${secretPath}" ]; then
      token=$(cat "${secretPath}")
      echo "access-tokens = github.com=$token" > "${confPath}"
    fi
  '';

  nix.extraOptions = ''
    !include ${confPath}
  '';
}
