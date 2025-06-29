{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.font;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.system.font = {
    enable = mkEnableOption "font";
  };

  config = mkIf cfg.enable {
    fonts.packages = [
      pkgs.nerd-fonts.hack
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.noto
      pkgs.material-design-icons
      pkgs.roboto
    ];
  };
}
