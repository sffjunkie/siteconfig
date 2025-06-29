{
  config,
  lib,
  sops,
  ...
}:
let
  cfg = config.looniversity.storage.minio;

  listenPort = lib.network.serviceHandlerNamedPort config "minio" "listen";
  consolePort = lib.network.serviceHandlerNamedPort config "minio" "console";

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.storage.minio = {
    enable = mkEnableOption "minio";

    dataDir = mkOption {
      default = [ "/var/lib/minio/data" ];
      type = types.listOf (types.either types.path types.str);
      description = lib.mdDoc "The list of data directories or nodes for storing the objects. Use one path for regular operation and the minimum of 4 endpoints for Erasure Code mode.";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."minio/root_user" = {
      owner = config.users.users.minio.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."minio/root_password" = {
      owner = config.users.users.minio.name;
      sopsFile = config.sopsFiles.service;
    };

    sops.templates."minio_env_file" = {
      content = ''
        MINIO_ROOT_USER=${config.sops.placeholder."minio/root_user"}
        MINIO_ROOT_PASSWORD=${config.sops.placeholder."minio/root_password"}
      '';
      owner = config.users.users.minio.name;
    };

    services.minio = {
      enable = true;
      listenAddress = ":${toString listenPort}";
      consoleAddress = ":${toString consolePort}";
      rootCredentialsFile = config.sops.templates."minio_env_file".path;
      dataDir = config.looniversity.storage.minio.dataDir;
    };

    networking.firewall.allowedTCPPorts = [
      listenPort
      consolePort
    ];
  };
}
