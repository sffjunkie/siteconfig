{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.immich;
  postgresql_hostname = lib.network.serviceHandlerFQDN config "postgresql";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.immich = {
    enable = mkEnableOption "immich";
  };

  config = mkIf cfg.enable {
    sops.secrets."immich/db_password" = {
      sopsFile = config.sopsFiles.service;
    };

    sops.templates."immich_env_file" = {
      content = ''
        DB_PASSWORD=${config.sops.placeholder."immich/db_password"}
      '';
    };

    services.immich = {
      enable = true;
      port = 2283;
      secretsFile = config.sops.templates."immich_env_file".path;
      user = "immich";

      database = {
        enable = true;
        host = postgresql_hostname;
        name = "immich";
        user = "immich";

        enableVectors = false;
      };
    };
  };
}
