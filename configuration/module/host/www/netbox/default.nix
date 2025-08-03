{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.netbox;

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
      };
    };

    services.nginx = {
      enable = true;

      user = "netbox";
      recommendedTlsSettings = true;
      clientMaxBodySize = "25m";

      virtualHosts."${config.networking.fqdn}" = {
        locations = {
          "/" = {
            # proxyPass = "http://0.0.0.0:8001";
            proxyPass = "http://${config.services.netbox.listenAddress}:${toString config.services.netbox.port}";
          };
          "/static/" = {
            root = "${config.services.netbox.dataDir}";
          };
        };
        # forceSSL = true;
        serverName = "${config.networking.fqdn}";
      };
    };
  };
}
