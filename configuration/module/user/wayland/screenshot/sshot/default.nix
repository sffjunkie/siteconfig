{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.screenshot.sshot;

  sshot = pkgs.writeScriptBin "sshot" ''
    #!${lib.getExe pkgs.bash}

    help() {
      echo "sshot - wayland screenshot script"
      echo
      echo "Usage:  sshot [options]"
      echo "  -e, --edit      send screenshot to swappy"
      echo "  -r, --region    screenshot a region"
      echo "  -v, --verbose   display information about actions taken"
      echo
      echo "If '-e' not specified then the output will be sent to the clipboard"
      echo "If '-r' not specified the entire screen will be captured"
    }

    [ -f ''${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs ] && source ''${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs
    screenshot_dir="''${XDG_PICTURES_DIR:-$HOME/pictures}/Screenshots"

    VALID_ARGS=$(getopt -o herv --long help,edit,region,verbose -- "''$@")
    if [[ $? -ne 0 ]]; then
      help
      exit 0;
    fi

    output=""
    region=0
    verbose=0
    eval set -- "$VALID_ARGS"
    while [ : ]; do
      case "$1" in
        -h | --help)
          help
          exit 0
          ;;
        -e | --edit)
          output="swappy"
          shift
          ;;
        -r | --region)
          region=1
          shift
          ;;
        -v | --verbose)
          verbose=1
          shift
          ;;
        --)
          break
          ;;
      esac
    done

    [ -t 1 ] && verbose=0

    if [ $region -eq 1 ]; then
      if [ "$output" == "swappy" ]; then
        [ $verbose -eq 1 ] && echo "Saving screenshot to $screenshot_dir"
        mkdir -p $screenshot_dir
        ${pkgs.grim}/bin/grim -t png -g "''$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
      else
        ${pkgs.grim}/bin/grim -t png -g "''$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
        [ $? -eq 0 ] && [ $verbose -eq 1 ] && echo "Screenshot copied to clipboard"
      fi
    else
      if [ "$output" == "swappy" ]; then
        [ $verbose -eq 1 ] && echo "Saving screenshot to $screenshot_dir"
        mkdir -p $screenshot_dir
        ${pkgs.grim}/bin/grim -t png - | ${pkgs.swappy}/bin/swappy -f -
      else
        ${pkgs.grim}/bin/grim -t png - | ${pkgs.wl-clipboard}/bin/wl-copy
        [ $? -eq 0 ] && [ $verbose -eq 1 ] && echo "Screenshot copied to clipboard"
      fi
    fi
  '';

  inherit (lib)
    enabled
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    ;
in
{
  options.looniversity.wayland.screenshot.sshot.enable = mkEnableOption "screenshot script";

  config = mkIf cfg.enable {
    looniversity.wayland.screenshot.swappy = enabled;

    home.packages = [
      sshot
    ];
  };
}
