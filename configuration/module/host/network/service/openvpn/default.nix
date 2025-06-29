{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.looniversity.network.service.openvpn;
in
{
  options.looniversity.network.service.openvpn = {
    enable = mkEnableOption "openvpn";
  };

  config = mkIf cfg.enable {
    # TODO: Add paths to secrets
    services.openvpn = {
      servers = {
        looniversityVPN = {
          config = ''
            client
            tls-client
            auth-user-pass
            dev tun
            persist-tun
            persist-key
            ncp-disable
            cipher AES-256-CBCauth SHA256
            resolv-retry infinite
            remote looniversity.net 1194 udp4
            nobindverify-x509-name "openvpn" name
            remote-cert-tls server
            explicit-exit-notify
          '';
        };
      };
    };
  };
}
