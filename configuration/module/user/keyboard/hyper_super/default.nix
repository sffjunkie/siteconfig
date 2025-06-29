# key codes - /run/current-system/sw/share/X11/xkb/keycodes/evdev
# US keyboard symbols - /run/current-system/sw/share/X11/xkb/symbols/us
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.keyboard.hyper_super;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.keyboard.hyper_super = {
    enable = mkEnableOption "separate hyper and cmd keys";

    name = mkOption {
      type = types.str;
      default = "hyper_super";
    };
  };

  config = mkIf cfg.enable {
    home.file.".xkb/symbols/${config.looniversity.keyboard.hyper_super.name}".text = ''
      default partial modifier_keys

      xkb_symbols "basic" {
        include "us(basic)"
        name[Group1] = "US Keyboard, Separate HYPER_L (CapsLock) and SUPER_L";

        // Rebind CapsLock to Hyper_L
        key <CAPS> { [ Hyper_L, Hyper_L ] };

        // Rebind right Super (windows key) into a Compose key
        key <RWIN> {[ Multi_key ]};

        modifier_map Mod3 { <CAPS> };
        modifier_map Mod4 { Super_L };
      };
    '';
  };
}
