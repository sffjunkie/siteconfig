{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.tool.ssh;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.network.tool.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      startAgent = (config.services.gnome.gnome-keyring.enable == false);
      enableAskPassword = (config.services.gnome.gnome-keyring.enable == false);
      askPassword = mkIf (
        config.services.gnome.gnome-keyring.enable == false
      ) "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    };
  };
}
