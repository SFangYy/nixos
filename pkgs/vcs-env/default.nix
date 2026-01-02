{ pkgs, ... }:

(pkgs.buildFHSUserEnv {
  name = "vcs-env";
  targetPkgs = p: (with p; [
    git
    gh
    git-absorb
    git-cliff
    lazygit
    yq-go
  ]);
  profile = ''
    export GITHUB_TOKEN=$(cat ~/.config/gh/hosts.yml | yq '.github.com.oauth_token')
  '';
}).env
