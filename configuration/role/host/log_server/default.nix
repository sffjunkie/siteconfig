{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.log_server;

  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.role.log_server = {
    enable = mkEnableOption "log server role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      monitoring = {
        grafana = enabled;
        alloy = enabled;
        loki = enabled;
        prometheus = enabled;
      };
    };
  };
}
