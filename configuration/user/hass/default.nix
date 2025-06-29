{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.user.hass;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.user.hass = {
    enable = mkEnableOption "hass user";
  };

  config = mkIf cfg.enable {
    users.users.hass = {
      isNormalUser = false;
      uid = 1101;
      description = "Home Assistant";
    };
    users.groups.hass = {
      gid = users.users.hass.uid;
    };
  };
}
