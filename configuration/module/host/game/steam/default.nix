{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.steam;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.game.steam = {
    enable = mkEnableOption "steam";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable32Bit = true;

    programs.gamemode.enable = true;
    programs.steam = {
      enable = true;

      extest.enable = true;
      gamescopeSession.enable = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
