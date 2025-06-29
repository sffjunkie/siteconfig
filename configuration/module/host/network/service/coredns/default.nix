{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.service.coredns;
  lanDev = lib.network.netDevice config "pinky" "lan";
  lanIpv4 = lib.network.lanIpv4 config "pinky";
  dynamicZoneDataDir = "/var/lib/coredns/dynamic";

  dnsPort = 1053;

  ttl = 180;

  # TODO: version number needs to change before auto will load new zone files.
  # Need some way to increment these numbers.
  staticZoneDataFile = pkgs.writeText "looniversity.zone" ''
    $ORIGIN ${config.looniversity.network.domainName}.
    @       IN SOA ns nomail (
            2024021401  ; Version number
            60          ; Zone refresh interval
            30          ; Zone update retry timeout
            ${toString ttl}         ; Zone TTL
            3600)       ; Negative response TTL

    looniversity. IN NS ns.${config.looniversity.network.domainName}.

    ; Static IPs
    ns            ${toString ttl} IN   A     ${lanIpv4}
  '';

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.coredns = {
    enable = mkEnableOption "coredns";
  };

  config = mkIf cfg.enable {
    services.coredns = {
      enable = true;

      config = ''
        .:${toString dnsPort} {
          forward . ${toString config.looniversity.network.extraNameServers}
          cache
          log
        }

        ${config.looniversity.network.domainName}:${toString dnsPort} {
          cache
          file ${staticZoneDataFile}
          auto {
            directory ${config.looniversity.network.serviceHandlers.coredns.config.dynamicZoneDataDir}
          }
          log
        }
      '';
    };

    systemd.services.coredns.serviceConfig = {
      StateDirectory = "coredns";
    };

    system.activationScripts.makeDNSDynamicZoneDataDir = ''
      mkdir -p ${dynamicZoneDataDir}
    '';

    networking.firewall.interfaces = {
      ${lanDev} = {
        allowedTCPPorts = [ dnsPort ];
        allowedUDPPorts = [ dnsPort ];
      };
    };
  };
}
