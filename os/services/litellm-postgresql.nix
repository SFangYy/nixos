{
  lib,
  pkgs,
  config,
  ...
}:
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
    settings = {
      listen_addresses = lib.mkForce "127.0.0.1";
      port = 5432;
    };
  };
  # Apply ownership after the module has ensured the role/database exist.
  systemd.services.postgresql.postStart = lib.mkAfter ''
    ${config.services.postgresql.package}/bin/psql -d postgres -f ${./litellm-postgresql-init.sql}
  '';
}
