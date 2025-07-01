{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.container_host;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.role.container_host = {
    enable = mkEnableOption "container host role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      system.podman = enabled;
    };
  };
}
