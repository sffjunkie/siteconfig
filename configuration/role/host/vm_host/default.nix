{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.vm_host;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.role.vm_host = {
    enable = mkEnableOption "vm host role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      virtualisation = {
        quickemu.enable = true;
        system.enable = true;
        vagrant.enable = true;
      };

      # TODO: Fix NAS
      mount.iso.enable = false;
    };
  };
}
