{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      git
      git-lfs
      nano
      pciutils
      pipx
      psmisc
      unzip
      usbutils
      zip
    ];
  };
}
