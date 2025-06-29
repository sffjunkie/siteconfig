{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.wake;

  hostToMac = map (host: {
    name = host.name;
    mac = lib.attrByPath [ "netDevice" "lan" "mac" ] "" host.value;
  }) (lib.attrsToList config.looniversity.network.hosts);

  hostWithMac = builtins.filter (item: builtins.elem ":" (lib.stringToCharacters item.mac)) hostToMac;

  hostArrayDef = lib.concatStringsSep "\n" (
    map (macAttrs: "hostToMac[${macAttrs.name}]=\"${macAttrs.mac}\"") hostWithMac
  );

  hostsArray = ''
    declare -A hostToMac
    ${hostArrayDef}
  '';

  hostNamesWithMac = map (host: host.name) hostWithMac;
  hostsCase = "${lib.concatStringsSep " | " hostNamesWithMac})";

  wakeScript = pkgs.writeScriptBin "wake" ''
    #!${pkgs.runtimeShell}
    ${hostsArray}
    case $1 in
      ${hostsCase}
        echo "Sending WOL packet to $1 with MAC ''${hostToMac[$1]}"
        ${pkgs.wakeonlan}/bin/wakeonlan "''${hostToMac[$1]}"
        ;;
      *)
        echo "Unknown host $1"
        ;;
    esac
  '';
in
{
  options.looniversity.script.wake = {
    enable = lib.mkEnableOption "wake script";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      wakeScript
    ];
  };
}
