{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.storage.zfs.autoscrub;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.storage.zfs.autoscrub = {
    enable = mkEnableOption "ZFS auto scrubbing";
  };

  config = mkIf cfg.enable {
    services.zfs.autoScrub = enabled;
  };
}
