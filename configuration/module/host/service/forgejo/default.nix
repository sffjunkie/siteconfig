{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.forgejo;

  postgresql_hostname = lib.network.serviceHandlerFQDN "postgresql";
  git_hostname = lib.network.serviceFQDN "git";
  http_port = lib.network.serviceHandlerMainPort "forgejo";

  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.service.forgejo = {
    enable = mkEnableOption "forgejo";
  };

  config = mkIf cfg.enable {
    sops.secrets."forgejo/root_password" = {
      owner = config.users.users.forgejo.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."forgejo/db_password" = {
      owner = config.users.users.forgejo.name;
      sopsFile = config.sopsFiles.service;
    };

    services.forgejo = {
      enable = true;
      appName = "Looniversity forgejo server";

      database = {
        type = "postgres";
        host = postgresql_hostname;
        user = "forgejo";
        passwordFile = config.sops.secrets."forgejo/db_password".path;
      };

      settings = {
        server = {
          DOMAIN = git_hostname;
          HTTP_PORT = http_port;
          DISABLE_REGISTRATION = true;
          COOKIE_SECURE = true;
        };
      };
    };

    looniversity.service.postgresql.databases = "forgejo";
  };
}
