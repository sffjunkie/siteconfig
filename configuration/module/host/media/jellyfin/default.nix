{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.media.jellyfin;

  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.media.jellyfin = {
    enable = mkEnableOption "jellyfin";
  };

  config = mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
      };

      traefik = mkIf config.looniversity.network.service.traefik.enable {
        dynamicConfigOptions = {
          http = {
            routers = {
              jellyfin = {
                tls = "true";
                entryPoints = [ "websecure" ];
                rule = "Host(`jellyfin.service.${config.looniversity.network.domainName}`)";
                service = "jellyfin";

                # https://jellyfin.org/docs/general/networking/traefik
                passHostHeader = true;
                headers = {
                  SSLForceHost = true;
                  SSLHost = "jellyfin.service.${config.looniversity.network.domainName}";
                  SSLRedirect = true;
                  contentTypeNosniff = true;
                  forceSTSHeader = true;
                  STSSeconds = 315360000;
                  STSIncludeSubdomains = true;
                  STSPreload = true;
                  customResponseHeaders = "X-Robots-Tag:noindex,nofollow,nosnippet,noarchive,notranslate,noimageindex";
                  frameDeny = true;
                };
              };
            };

            services = {
              jellyfin = {
                loadBalancer = {
                  servers = [ { url = "http://127.0.0.1:8096"; } ];
                };
              };
            };
          };
        };
      };
    };

    looniversity = {
      mount = {
        movies = enabled;
        music = enabled;
        private = enabled;
      };
    };
  };
}
