{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  font = types.submodule {
    options = {
      family = mkOption {
        type = types.str;
        default = "";
        description = "Font family";
      };
      size = mkOption {
        type = types.int;
        default = 13;
        description = "Font size";
      };
    };
  };
in
{
  options.looniversity.ui = {
    desktop = {
      display = { };
      font = {
        serif = mkOption {
          type = types.attrsOf font;
          description = "Serif font definition";
          default = {
            family = "NotoSerif";
          };
        };
        sans-serif = mkOption {
          type = types.attrsOf font;
          description = "Sans-serif font definition";
          default = {
            family = "NotoSans";
          };
        };
        monospace = mkOption {
          type = types.attrsOf font;
          description = "Monospace font definition";
          default = {
            family = "Hack Nerd Font";
          };
        };
      };
    };
  };
}
