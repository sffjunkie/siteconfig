{
  config,
  lib,
  pkgs,
  ...
}:
let
  script = pkgs.writeScriptBin "nod" ''
    #!${lib.getExe pkgs.bash}

    usage() {
      echo "$0 host ip"
      exit 1
    }

    [[ -z "$1" ]] && usage

    host_name=$1
    host_ip="${"2:-$host_name"}"

    # Create a temporary directory
    temp=$(mktemp -d)

    # Function to cleanup temporary directory on exit
    cleanup() {
      rm -rf "$temp"
    }
    trap cleanup EXIT

    # Create the directory where sshd expects to find the host keys
    install -d -m755 "$temp/etc/ssh"

    # Decrypt your private key from the password store and copy it to the temporary directory
    ${pkgs.sops}/bin/sops decrypt --extract '["'"''${host_name}"'"]["ssh_host_ed25519_key"]' ./configuration/secret/host.yaml > "$temp/etc/ssh/ssh_host_ed25519_key"

    # Set the correct permissions so sshd will accept the key
    chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

    # Install NixOS to the host system with our secrets
    echo "Deploying to ''${host_name}"
    ${pkgs.nixos-anywhere}/bin/nixos-anywhere --extra-files "$temp" --flake '.#'"''${host_name}" --target-host "root@''${host_ip}"
  '';
in
script
