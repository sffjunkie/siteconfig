{
  config,
  lib,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.acme;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.acme = {
    enable = mkEnableOption "acme";
  };

  config = mkIf cfg.enable {
    # sops.secrets."acme/cloudflare_email" = {};
    # sops.secrets."acme/cloudflare_api_key" = {};
    sops.secrets."acme/cloudflare_dns_api_token" = {
      owner = config.users.users.acme.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."acme/cloudflare_zone_api_token" = {
      owner = config.users.users.acme.name;
      sopsFile = config.sopsFiles.service;
    };

    security.acme = {
      acceptTerms = true;
      email = "sffjunkie@gmail.com";
      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      certs = {
        "${config.looniversity.network.domain}" = {
          domain = "${config.looniversity.network.domain}";
          extraDomainNames = [
            "*.${config.looniversity.network.domain}"
            "service.${config.looniversity.network.domain}"
            "*.service.${config.looniversity.network.domain}"
          ];

          dnsProvider = "cloudflare";
          credentialsFiles = {
            # "CF_API_EMAIL_FILE" = config.sops.secrets."acme/cloudflare_email".path;
            # "CF_API_KEY_FILE" = config.sops.secrets."acme/cloudflare_api_key".path;
            "CF_DNS_API_TOKEN_FILE" = config.sops.secrets."acme/cloudflare_dns_api_token".path;
            "CF_ZONE_API_TOKEN_FILE" = config.sops.secrets."acme/cloudflare_zone_api_token".path;
          };
        };
      };
    };
  };
}
