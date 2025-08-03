{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.service.ssh;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.network.service.ssh = {
    enable = mkEnableOption "ssh";
    askPassword = mkOption {
      type = types.str;
      default = "1";
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      # startAgent = true;
      enableAskPassword = true;
      askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    };
  };
}
