{ config, ... }:
{
  config = {
    sops.secrets."netbox/secret_key" = {
      sopsFile = config.sopsFiles.service;
    };

    services.netbox = {
      enable = true;
      secretKeyFile = config.sops.secrets."netbox/secret_key".path;
    };

    services.nginx = {
      enable = true;
      user = "netbox";
      recommendedTlsSettings = true;
      clientMaxBodySize = "25m";

      virtualHosts."${config.networking.fqdn}" = {
        locations = {
          "/" = {
            proxyPass = "http://[::1]:8001";
            # proxyPass = "http://${config.services.netbox.listenAddress}:${config.services.netbox.port}";
          };
          "/static/" = {
            alias = "${config.services.netbox.dataDir}/static/";
          };
        };
        # forceSSL = true;
        serverName = "${config.networking.fqdn}";
      };
    };
  };
}
