{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.greeter.tuigreet;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.desktop.greeter.tuigreet = {
    enable = mkEnableOption "tuigreet";

    script = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.looniversity.desktop.display_manager.greetd.enable;
        message = "greetd service must be enabled";
      }
      {
        assertion = config.looniversity.desktop.greeter.tuigreet.script != "";
        message = "looniversity.greeter.tuigreet.script must be set";
      }
    ];

    environment.systemPackages = [
      pkgs.tuigreet
    ];

    services.greetd.settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --remember --cmd ${config.looniversity.desktop.greeter.tuigreet.script}";
  };
}
