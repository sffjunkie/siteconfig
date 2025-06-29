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
    services.postgresql = {
      enable = true;
      package = pgPackage;

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

      authentication = mkOverride 10 ''
        #type database  DBuser  auth-method optional_ident_map
        local sameuser  all     peer        map=superuser_map
      '';

      settings = {
        password_encryption = "scram-sha-256";
      };
    };
  };
}
