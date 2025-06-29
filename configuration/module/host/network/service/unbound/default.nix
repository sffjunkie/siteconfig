{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.service.unbound;
  lanIpv4 = lib.network.lanIpv4 config "pinky";

  dnsPort = 1053;

  ttl = 180;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.network.service.unbound = {
    enable = mkEnableOption "unbound";
  };

  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          port = dnsPort;
          prefer-ip4 = true;
          interface = lanIpv4;
          access-control = "${config.looniversity.network.networkAddress}/${toString config.looniversity.network.prefixLength} allow";

          aggressive-nsec = true;
          qname-minimisation = true;
          tls-system-cert = true;
        };

        local-zone = [
          "${config.looniversity.network.domainName}. static"
        ];

        local-data = [
          "looniversity. IN NS ns.${config.looniversity.network.domainName}."
          "ns            ${toString ttl} IN   A     ${lanIpv4}"
        ];

        forward-zone = [
          {
            name = ".";
            forward-addr = [ "1.1.1.1@853#cloudflare-dns.com" ];
            forward-tls-upstream = true;
          }
        ];

        remote-control = {
          control-enable = true;
        };
      };
    };
  };
}
