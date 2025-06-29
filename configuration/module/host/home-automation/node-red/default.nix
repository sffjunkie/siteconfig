{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.home-automation.node-red;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.home-automation.node-red = {
    enable = mkEnableOption "node-red";

    nodes = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };

    nodes = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    looniversity = {
      development.nodejs.enable = true;
    };

    environment.shellAliases = {
      node-red-pm = "npm --prefix=${config.services.node-red.userDir} --save";
    };

    services.node-red = {
      enable = true;
      openFirewall = true;
    };

    # system.activationScripts.installNodes = ''
    #   npm --prefix=${config.services.node-red.userDir} --save
    # '';
  };
}
