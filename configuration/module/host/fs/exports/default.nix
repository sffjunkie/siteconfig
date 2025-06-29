{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.looniversity.fs.nfs;

  nfsExport = types.submodule {
    options = {
      path = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Path to export
        '';
      };
      clients = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Clients allowed to mount export
        '';
      };
      opts = mkOption {
        type = types.listOf types.str;
        default = [ ];
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
  options.looniversity.fs.nfs = {
    exports = mkOption {
      type = types.listOf nfsExport;
      default = [ ];
      description = lib.mdDoc ''
        List of exports
      '';
    };
    clients = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        Default clients allowed to mount export
      '';
    };
    opts = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = lib.mdDoc ''
        Default export options
      '';
    };
  };

  config = mkIf (cfg.exports != [ ]) {
    services.nfs.server = {
      exports = lib.concatMapStringsSep "\n" (
        share:
        let
          clients = if share.clients != "" then share.clients else cfg.clients;
          opts = if share.opts != [ ] then share.opts else cfg.opts;
          comment = if share.description != "" then "\t\t# ${share.description}" else "";
        in
        "${share.path} ${clients}(${lib.concatStringsSep "," opts})${comment}"
      ) cfg.exports;
    };
  };
}
