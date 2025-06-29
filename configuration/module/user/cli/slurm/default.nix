{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.slurm;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.cli.slurm = {
    enable = mkEnableOption "slurm";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.slurm-nm
    ];
  };
}
