{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.streamdeck;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.streamdeck = {
    enable = mkEnableOption "streamdeck";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.streamdeck-ui
    ];

    services.status-notifier-watcher.enable = true;

    systemd.user.services.streamdeck = {
      Install.WantedBy = [ "default.target" ];
      Unit.Description = "A Linux compatible UI for the Elgato Stream Deck.";
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.streamdeck-ui}/bin/streamdeck -n";
        Restart = "on-failure";
      };
    };
  };
}
