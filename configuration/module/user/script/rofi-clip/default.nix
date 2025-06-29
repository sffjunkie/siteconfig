{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.rofi-clip;

  rofi-clip-script = pkgs.writeScriptBin "rofi-clip" ''
    #!${lib.getExe pkgs.bash}
    help() {
      echo "rofi-clip - rofi clipboard management"
      echo
      echo "Usage:  rofi-clip [options]"
      echo "  -c, --copy      copy an item from list of clips"
      echo "  -d, --delete    delete an item from list of clips"
      echo "  -h, --help      show this help message"
    }

    VALID_ARGS=$(getopt -o hcd --long help,copy,delete -- "''$@")
    if [[ $? -ne 0 ]] || [[ $# -eq 0 ]]; then
      help
      exit 0;
    fi

    rofi_clip_select() {
      cliphist list | \
        rofi -dmenu -theme-str '@import "looniversity"' -p "clipboard - select" | \
        cliphist decode | \
        wl-copy
    }

    rofi_clip_delete() {
      cliphist list | \
        rofi -dmenu -theme-str '@import "looniversity"' -p "clipboard - delete" | \
        cliphist delete
    }

    output=""
    copy=0
    delete=0
    eval set -- "$VALID_ARGS"
    while [ : ]; do
      case "$1" in
        -h | --help)
          help
          exit 0
          ;;
        -c | --copy)
          copy=1
          break
          ;;
        -d | --delete)
          delete=1
          break
          ;;
        --)
          break
          ;;
      esac
    done

    if [ $delete -eq 1 ]; then
      rofi_clip_delete
    else
      rofi_clip_select
    fi
  '';
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.script.rofi-clip = {
    enable = mkEnableOption "rofi-clip script";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.looniversity.wayland.clipboard.wl-clipboard.enable;
        message = "wl-clipboard must be enabled";
      }
      {
        assertion = config.looniversity.wayland.clipboard.cliphist.enable;
        message = "cliphist must be enabled";
      }
    ];

    home.packages = [ rofi-clip-script ];
  };
}
