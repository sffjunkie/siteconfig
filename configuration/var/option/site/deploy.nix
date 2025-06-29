{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.deploy = {
    sshUser = mkOption {
      type = types.str;
      default = "";
    };
    remoteUser = mkOption {
      type = types.str;
      default = "";
    };
    targets = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };
}
