{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.games_machine;
  inherit (lib)
    disabled
    enabled
    mkEnableOption
    mkIf
    ;
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
        roms = disabled;
      };
    };

    hardware = {
      xone = enabled;
    };
  };
}
