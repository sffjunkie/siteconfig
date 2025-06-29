{
  config,
  lib,
  pkgs,
  ...
}:
let
  wanDev = lib.network.netDevice config "pinky" "wan";
in
{
  config = {
    services.pppd = {
      enable = true;
      peers = {
        bt = {
          enable = true;
          autostart = true;

          config = ''
            plugin pppoe.so
            ${wanDev}
            user "homehub@btinternet.com"

            persist
            maxfail 0
            holdoff 5
            mtu 1492
            noaccomp

            noipdefault
            defaultroute
          '';
        };
      };
    };
  };
}
