{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.storage.zfs.autoscrub;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.storage.zfs.autoscrub = {
    enable = mkEnableOption "ZFS auto scrubbing";
  };

  config = mkIf cfg.enable {
    services.zfs.autoScrub.enable = true;
  };
}
