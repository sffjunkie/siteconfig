{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.games_machine;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.role.games_machine = {
    enable = mkEnableOption "games machine role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      role.gui.enable = true;
      game = {
        steam.enable = true;
        lutris.enable = true;

        retroarch.enable = true;
      };
      media = {
        pipewire.enable = true;
      };

      mount = {
        roms.enable = false;
      };
    };
  };
}
