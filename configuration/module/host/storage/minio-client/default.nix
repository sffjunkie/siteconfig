{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.storage.minio-client;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.storage.minio-client = {
    enable = mkEnableOption "minio-client";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.minio-client
    ];
  };
}
