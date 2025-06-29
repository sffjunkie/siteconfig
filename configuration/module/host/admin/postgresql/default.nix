{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.admin.postgresql;

  port = lib.tool.getToolPort config "postgresql-admin";
  pgPackage = lib.network.serviceServiceHandlerPackage config "postgresql";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.admin.postgresql = {
    enable = mkEnableOption "postgresql admin";
  };

  config = mkIf cfg.enable {
    sops.secrets."pgadmin/initial_password" = {
      owner = config.users.users.pgadmin.name;
      sopsFile = config.sopsFiles.tool;
    };

    services.postgresql.package = pgPackage;

    services.pgadmin = {
      enable = true;
      port = port;

      initialEmail = "siteadmin@looniversity.lan";
      initialPasswordFile = config.sops.secrets."pgadmin/initial_password".path;
    };
  };
}
