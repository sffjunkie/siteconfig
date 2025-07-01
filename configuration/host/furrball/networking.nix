{ lib, config, ... }:
let
  lanDev = lib.network.netDevice config "buster" "wifi";

  inherit (lib) enabled;
in
{
  config = {
    networking = {
      hostId = "8ddbb68e";
      hostName = "furrball";
      domain = config.looniversity.network.domainName;
      networkmanager = enabled;

      useDHCP = lib.mkDefault true;
      # interfaces.enp4s0.useDHCP = lib.mkDefault true;
      # interfaces.wlp3s0.useDHCP = lib.mkDefault true;
    };
  };
}
