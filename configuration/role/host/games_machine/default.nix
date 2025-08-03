{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.games_machine;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.role.games_machine = {
    enable = mkEnableOption "games machine role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      role.gui = enabled;
      game = {
        steam = enabled;
        lutris = enabled;

        retroarch = enabled;
      };
      media = {
        pipewire = enabled;
      };

      mount = {
        roms.enable = false;
      };
    };

    hardware = {
      xone = enabled;
    };
  };
}
