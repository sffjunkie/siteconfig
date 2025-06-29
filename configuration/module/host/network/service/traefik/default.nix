{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.service.traefik;

  # certDir = lib.traceVal config.security.acme.certs."*.${config.looniversity.network.domainName}".directory;
  certDir = "/etc/ssl/certs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.traefik = {
    enable = mkEnableOption "traefik";
  };

  config = mkIf cfg.enable {
    services.traefik = {
      enable = true;

      staticConfigOptions = {
        api = {
          dashboard = true;
          debug = true;
        };

        entryPoints = {
          web = {
            address = ":80";
            http.redirections = {
              entryPoint = {
                to = "websecure";
                scheme = "https";
                permanent = true;
              };
            };
          };
          websecure = {
            address = ":443";
          };
        };

        log = {
          level = "DEBUG";
          filePath = "/run/traefik/traefik.log";
        };

        serversTransport = {
          insecureSkipVerify = true;
        };

        # providers.docker = {
        #   network = "proxy";
        #   exposedByDefault = false;
        # };
      };

      dynamicConfigOptions = {
        tls = {
          stores.default.defaultCertificate = {
            certFile = "${certDir}/LooniversityLE.fullchain";
            keyFile = "${certDir}/LooniversityLE.key";
          };

          certificates = [
            config.services.traefik.dynamicConfigOptions.tls.stores.default.defaultCertificate
          ];
        };

        http = {
          middlewares = {
            dashboard-auth.basicAuth.users = [
              "sdk:$apr1$vdvcy1tu$yNIWHjYlk3tfG/ps8OiTp."
            ];
          };

          routers = {
            dashboard = {
              tls = "true";
              entryPoints = [ "websecure" ];
              rule = "Host(`traefik-dashboard.service.looniversity.net`)";
              service = "api@internal";
              middlewares = [ "dashboard-auth" ];
            };
          };
        };
      };
    };
  };
}
