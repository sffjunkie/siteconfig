{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.postgresql;
  pgPackage = lib.network.serviceServiceHandlerPackage config "postgresql";

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkOverride
    types
    ;
in
{
  options.looniversity.service.postgresql = {
    enable = mkEnableOption "postgresql";

    databases = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        A list of databases to create.

        For each database a user will be created name the same
        as the database.
        Can be set in each individual service configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      5432
    ];

    services.postgresql = {
      enable = true;
      package = pgPackage;

      enableTCPIP = true;

      ensureDatabases = cfg.databases;
      ensureUsers =
        (map (elem: {
          name = toString elem;
          ensureDBOwnership = true;
        }) cfg.databases)
        ++ [
          { name = "sysadmin"; }
          { name = "dbadmin"; }
        ];

      authentication = lib.mkForce ''
        host  all  all       0.0.0.0/0      scram-sha-256
        local all  postgres  peer           map=postgres
        local all  all       peer
        host  all  all       127.0.0.1/32   md5
        host  all  all       ::1/128        md5
      '';

      settings = {
        password_encryption = "scram-sha-256";
      };
    };
  };
}
