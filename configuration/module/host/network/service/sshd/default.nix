{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.looniversity.network.service.sshd;
in
{
  options.looniversity.network.service.sshd = {
    enable = mkEnableOption "sshd";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.openssh.settings.AllowUsers != "";
        message = "AllowUsers config option is empty";
      }
    ];

    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
