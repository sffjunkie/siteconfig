{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.security.passage;
  passageDir = "~/.local/state/passage";

  inherit (lib)
    enabled
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.security.passage = {
    enable = mkEnableOption "passage";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.passage
    ];

    home.shellAliases = {
      PASSAGE_DIR = passageDir;
      PASSAGE_EXTENSIONS_DIR = "${passageDir}/identities";
    };

    home.activation = {
      passsageDir = ''
        mkdir -p ${passageDir}
      '';
    };
  };
}
