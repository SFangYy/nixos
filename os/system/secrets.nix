{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
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

  # The daemon receives a credential; clients use a private home config.
  # Plaintext never enters a public include file, the Nix store or argv.
  systemd.services.nix-daemon.serviceConfig = {
    LoadCredential = "github-token:${config.age.secrets.github_token.path}";
    # This service extends the package's unit; reset its original ExecStart.
    ExecStart = lib.mkForce [
      ""
      (pkgs.writeShellScript "nix-daemon-with-token" ''
        token="$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/github-token")"
        export NIX_CONFIG="''${NIX_CONFIG:+$NIX_CONFIG
        }access-tokens = github.com=$token"
        exec ${config.nix.package}/bin/nix-daemon --daemon
      '')
    ];
  };
  system.activationScripts.removePublicGithubToken.text = ''
    rm -f /etc/nix/access-tokens.conf
  '';
}
