{
  config,
  lib,
  pkgs,
  ...
}:
let
  script = pkgs.writeScriptBin "nixos-vm" ''
    #!${lib.getExe pkgs.bash}
    VALID_ARGS=$(getopt -o sv --long show-trace,verbose -- "''$@")
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi

    extra_args=()
    eval set -- "$VALID_ARGS"
    while [ : ]; do
      case "$1" in
        -v | --verbose)
            extra_args+=("--verbose")
            shift
            ;;
        -s | --show-trace)
            extra_args+=("--show-trace")
            shift
            ;;
        --) shift;
            break
            ;;
      esac
    done

    if [ -z "$2" ]; then
      target="$(hostname)"
    else
      target="$2"
    fi

    COLUMNS=$(tput cols)
    case "$1" in
      build)
        ${pkgs.figlet}/bin/figlet \
          -d "${pkgs.figlet}/share/figlet" \
          -f doom \
          -w "''${COLUMNS}" \
          "$target  :  build vm"

        nixos-rebuild build-vm \
          "''${extra_args[@]}" \
          --flake ".#''${target}" \
          --impure \
          --log-format internal-json |& ${pkgs.nix-output-monitor}/bin/nom --json
        ;;

      boot)
        if [ ! -f result/bin/run-*-vm ]; then echo "VM not built yet"; exit 1; fi
        result/bin/run-*-vm
        ;;

      *)
        [ $# -eq 0 ] && echo -n "No mode specified. "
        echo "Mode must be one of build, boot'"
        exit 1
        ;;
    esac
  '';
in
script
