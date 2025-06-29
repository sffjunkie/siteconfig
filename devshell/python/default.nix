{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    pdm
    poetry
    python311
    python311.pkgs.myst-parser
    python311.pkgs.pip
    python311.pkgs.pipx
    python311.pkgs.pytest
    python311.pkgs.sphinx
    python311.pkgs.sphinx-book-theme
    python311.pkgs.tox
    python311.pkgs.virtualenv
    python311.pkgs.virtualenvwrapper
    python311.pkgs.rich
  ];
}
