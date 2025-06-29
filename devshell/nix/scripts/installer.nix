{
  config,
  lib,
  pkgs,
  ...
}:
let
  script = pkgs.writeScriptBin "nixos-installer" ''
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
          "installer  :  build"

        nix build \
          --verbose --log-format internal-json \
          .#nixosConfigurations.installer.config.system.build.isoImage |& \
          ${pkgs.nix-output-monitor}/bin/nom --json
        ;;

      boot)
        if [ ! -f result/iso/looniversity-minimal-x86_64-linux.iso ]; then echo "ISO not built yet"; exit 1; fi
        ${pkgs.qemu}/bin/qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/looniversity-minimal-x86_64-linux.iso
        ;;

      *)
        [ $# -eq 0 ] && echo -n "No mode specified. "
        echo "Mode must be one of build or boot"
        exit 1
        ;;
    esac
  '';
in
script
