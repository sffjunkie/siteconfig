# ports: 9200, 9300
{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.elasticsearch;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options = {
    looniversity.service.elasticsearch = {
      enable = mkEnableOption "elasticsearch";
    };
  };

  config = mkIf cfg.enable {
    services.elasticsearch = {
      enable = true;
      single_node = true;
    };
  };
}
