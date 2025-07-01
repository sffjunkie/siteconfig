{
  config,
  lib,
  ...
}:
let
  inherit (lib) enabled;
in
{
  config = lib.mkIf (config.looniversity.fs.cifs.shares != [ ]) {
    services.samba = {
      enable = true;
      nmbd.enable = false;
      winbindd.enable = false;
      openFirewall = true;
      settings = {
        global = {
          "security" = "user";
          "client max protocol" = "SMB3";
          "client min protocol" = "SMB2";
          "guest account" = "nobody";
          "hosts allow" = "10.44. 127.0.0.1 ::1";
          "hosts deny" = "0.0.0.0/0";
          "map to guest" = "bad user";
          "server string" = "samba";
          "workgroup" = config.looniversity.network.workgroup;
        };
      };
    };

    services.samba-wsdd = enabled;
  };
}
