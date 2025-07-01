{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.nextcloud;

  inherit (lib)
    enabled
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.service.nextcloud = {
    enable = mkEnableOption "nextcloud";
  };

  config = mkIf cfg.enable {
    sops.secrets."nextcloud/admin_password" = {
      owner = config.users.users.nextcloud.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."nextcloud/db_password" = {
      owner = config.users.users.nextcloud.name;
      sopsFile = config.sopsFiles.service;
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "cloud.looniversity.net";

      autoUpdateApps = enabled // {
        startAt = "05:00:00";
      };

      settings = {
        overwriteprotocol = "https";
      };

      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        dbpassFile = config.sops.secrets."nextcloud/db_password".path;

        adminpassFile = config.sops.secrets."nextcloud/admin_password".path;
      };
    };

    looniversity.service.postgresql = {
      enable = true;
      databases = [ config.services.nextcloud.config.dbname ];
    };
  };
}
