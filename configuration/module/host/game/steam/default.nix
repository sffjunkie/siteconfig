{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.steam;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.game.steam = {
    enable = mkEnableOption "steam";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable32Bit = true;

    programs.gamemode = enabled;
    programs.steam = {
      enable = true;

      extest = enabled;
      gamescopeSession = enabled;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
