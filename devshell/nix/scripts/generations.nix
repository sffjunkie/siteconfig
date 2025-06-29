{
  config,
  lib,
  pkgs,
  ...
}:
let
  script = pkgs.writeScriptBin "nog.sh" ''
    #!${lib.getExe pkgs.bash}

    time_period=(-1)
    period_to_seconds() {
      day_pattern='[0-9]+d'
      hour_pattern='[0-9]+h'
      if [[ ''${1} =~ $day_pattern ]]; then
        position=''${#BASH_REMATCH[0]}
        let "position--"
        days=''${1:0:''$position}
        let time_period=''${days}*86400
      elif [[ ''${1} =~ $hour_pattern ]]; then
        position=''${#BASH_REMATCH[0]}
        let "position--"
        hours=''${1:0:''$position}
        let time_period=''${hours}*3600
      fi
    }

    VALID_ARGS=$(getopt -o ao:y --long all-old,older-than:,yes -- "''$@")
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi

    period=
    delete_all=0
    extra_args=()
    eval set -- "$VALID_ARGS"
    while [ : ]; do
      case "$1" in
        -a | --all-old)
          echo "delete all"
          delete_all=1
          shift
          ;;
        -o | --older-than)
          period=$2
          shift
          shift
          ;;
        --)
          shift;
          break
          ;;
      esac
    done

    COLUMNS=$(tput cols)
    LINES=$(tput lines)
    case "$1" in
      list)
        nixos-rebuild list-generations 2>/dev/null
        ;;

      delete)
        if [ ''${delete_all} == 1 ]; then
          ${pkgs.dialog}/bin/dialog --defaultno --yesno "Are you sure you wish to delete all previous generations?" 8 40
          # if [ $? -eq 0 ]; then sudo nix-collect-garbage -d; fi
        else
          period_to_seconds "''$period"
          if [ $time_period -ne -1 ]; then
            generations=$(\
              nixos-rebuild list-generations --json 2>/dev/null | \
              jq -r --arg TIMEPERIOD ''${time_period} \
                '.[] | select(.date < ((now - (''$TIMEPERIOD | tonumber)) | strftime("%Y-%m-%dT%H:%M:%S"))) | ["\(.generation)        ", "\(.date)  ", "\(.nixosVersion)  ", "\(.kernelVersion)\n"] | @tsv'\
            )

            count=''$(echo "''${generations}" | wc -l)
            let height=count+12

            if [ ''$height -gt ''$LINES ]; then
              height=''$LINES
            fi

            ${pkgs.dialog}/bin/dialog \
              --defaultno --yesno \
              "Deleting generations older than ''${period}\n\nThis will delete the following generation\n\nGeneration  Date                   Nixos                    Kernel\n''${generations}\n\nAre you sure you wish to continue?" \
              "''${height}" 80
            if [ $? -eq 0 ]; then sudo nix-collect-garbage --delete-older-than "''${period}"; fi
          fi
        fi
        ;;

      *)
        [ $# -eq 0 ] && echo -n "No mode specified. "
        echo "Mode must be one of 'list' or 'delete'"
        exit 1
        ;;
    esac
  '';
in
script
