{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.bind.dnsutils
    pkgs.cifs-utils
    pkgs.nfs-utils
    pkgs.nmap
    pkgs.tcpdump
    pkgs.wakelan
  ];
}
