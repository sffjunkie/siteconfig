{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.buildPackages.go
  ];
}
