{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.looniversity.fs.cifs;

  cifsShare = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Share name
        '';
      };
      path = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Path to export
        '';
      };
      opts = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = lib.mdDoc ''
          Export options
        '';
      };
      description = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Description
        '';
      };
    };
  };
in
{
  options.looniversity.fs.cifs = {
    shares = mkOption {
      type = types.listOf cifsShare;
      default = [ ];
      description = lib.mdDoc ''
        List of shares
      '';
    };
    opts = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = lib.mdDoc ''
        Default share options
      '';
    };
  };

  config = mkIf (cfg.shares != [ ]) {
    services.samba.settings = (
      builtins.foldl' (
        acc: shareDef:
        let
          name = shareDef.name;
          shareOpts = cfg.opts // shareDef.opts;
          share = lib.removeAttrs shareDef [
            "name"
            "opts"
          ];
        in
        ({ "${name}" = share // shareOpts; } // acc)
      ) { } cfg.shares
    );
  };
}
