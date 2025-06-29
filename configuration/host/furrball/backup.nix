{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    sops.secrets."restic/s3_access_key" = {
      sopsFile = config.sopsFiles.tool;
    };

    sops.secrets."restic/s3_secret_key" = {
      sopsFile = config.sopsFiles.tool;
    };

    sops.templates."furrball_nas_env_file" = {
      content = ''
        AWS_DEFAULT_REGION="us-east-1"
        AWS_ACCESS_KEY_ID=${config.sops.placeholder."restic/s3_access_key"}
        AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."restic/s3_secret_key"}
      '';
    };

    sops.secrets."restic/repositories/furrball/s3/password" = {
      sopsFile = config.sopsFiles.tool;
    };

    services.restic.backups.furrball_nas = {
      initialize = true;
      paths = [
        "/var/lib"
      ];
      repository = "s3:https://s3.service.looniversity.net/restic-furrball";
      passwordFile = config.sops.secrets."restic/repositories/furrball/s3/password".path;

      environmentFile = config.sops.templates."furrball_nas_env_file".path;
    };
  };
}
