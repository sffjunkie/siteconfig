{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.vm_host;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.role.vm_host = {
    enable = mkEnableOption "vm host role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      virtualisation = {
        quickemu = enabled;
        system = enabled;
        vagrant = enabled;
      };

      # TODO: Fix NAS
      mount.iso.enable = false;
    };
  };
}
