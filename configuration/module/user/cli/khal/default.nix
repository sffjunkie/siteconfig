{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.khal;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.khal = {
    enable = mkEnableOption "khal";
  };

  config = mkIf cfg.enable {
    programs.khal = {
      enable = true;

      locale = {
        timeformat = "%H:%M";
        dateformat = "%Y-%m-%d";
        longdateformat = "%Y-%m-%d";
        datetimeformat = "%Y-%m-%d %H:%M";
        longdatetimeformat = "%Y-%m-%d %H:%M";
        default_timezone = "Europe/London";
      };
    };
  };
}
