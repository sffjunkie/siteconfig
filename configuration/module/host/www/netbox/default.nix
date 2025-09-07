{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.netbox;
  postgresql_hostname = lib.network.serviceHandlerFQDN "postgresql";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.netbox = {
    enable = mkEnableOption "netbox";
  };

  config = mkIf cfg.enable {
    sops.secrets."netbox/secret_key" = {
      sopsFile = config.sopsFiles.service;
      owner = config.users.users.netbox.name;
      group = config.users.users.netbox.group;
    };

    sops.secrets."netbox/password" = {
      sopsFile = config.sopsFiles.service;
      owner = config.users.users.netbox.name;
      group = config.users.users.netbox.group;
    };

    services.netbox = {
      enable = true;
      port = 9001;
      listenAddress = "0.0.0.0";
      package = pkgs.netbox_4_3;
      secretKeyFile = config.sops.secrets."netbox/secret_key".path;

      settings = {
        CSRF_TRUSTED_ORIGINS = [
          "http://furrball.looniversity.net"
          "http://localhost"
        ];

        AUTH_PASSWORD_VALIDATORS = [ ];

        DATABASES = {
          default = {
            NAME = "netbox";
            USER = "netbox";
            HOST = "${postgresql_hostname}";
            PORT = 5432;
          };
        };

      };
    };

    looniversity.db.postgresql.databases = [ "netbox" ];
  };
}
