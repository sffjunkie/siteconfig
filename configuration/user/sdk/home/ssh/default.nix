{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = { };
        "thebrain2" = {
          hostname = "10.44.0.2";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
        "babs" = {
          hostname = "10.44.0.3";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
      };
    };
  };
}
