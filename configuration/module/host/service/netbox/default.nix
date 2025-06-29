{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.netbox;
  port = lib.tool.getToolPort config "netbox";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.netbox = {
    enable = mkEnableOption "netbox service";
  };

  config = mkIf cfg.enable {
    sops.secrets."netbox/secret_key" = {
      sopsFile = config.sopsFiles.tool;
    };

    services.netbox = {
      enable = true;
      port = port;

      secretKeyFile = config.sops.secrets."netbox/secret_key".path;
    };
  };
}
