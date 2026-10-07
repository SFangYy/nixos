{ lib, pkgs, ... }:
{
  users.users.sfangyy.extraGroups = [ "postgres" ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "litellm" ];
    ensureUsers = [
      {
        name = "sfangyy";
      }
    ];
    initialScript = ./litellm-postgresql-init.sql;
    settings = {
      listen_addresses = lib.mkForce "127.0.0.1";
      port = 5432;
    };
    authentication = lib.mkAfter ''
      host litellm sfangyy 127.0.0.1/32 trust
    '';
  };
}
