{ inputs, config, lib, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  age.identityPaths = [ "/home/sfangyy/.ssh/id_rsa" ];

  age.secrets.davfs_system = {
    file = ../../secrets/davfs_credentials.age;
    path = "/etc/davfs2/secrets";
    mode = "600";
    owner = "root";
  };

  age.secrets.github_token = {
    file = ../../secrets/github-token.age;
    mode = "400";
    owner = "root";
  };

  # Generate /etc/nix/access-tokens.conf from the decrypted secret
  system.activationScripts.nix-access-tokens = let
    tokenPath = config.age.secrets.github_token.path;
    confPath = "/etc/nix/access-tokens.conf";
  in ''
    if [ -f "${tokenPath}" ]; then
      echo "access-tokens = github.com=$(cat "${tokenPath}")" > "${confPath}"
      chmod 400 "${confPath}"
    fi
  '';

  nix.extraOptions = ''
    !include /etc/nix/access-tokens.conf
  '';
}
