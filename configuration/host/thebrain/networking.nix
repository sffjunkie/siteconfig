{ lib, ... }:
{
  config = {
    networking = {
      hostId = "cadbfefe";
      hostName = "thebrain";
      domain = "looniversity.net";

      useDHCP = lib.mkDefault true;
      # interfaces.enp4s0.useDHCP = lib.mkDefault true;
      # interfaces.wlp3s0.useDHCP = lib.mkDefault true;
    };
  };
}
